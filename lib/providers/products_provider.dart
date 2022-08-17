import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/providers/auth.dart';
import 'product.dart';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http_parser/http_parser.dart';


class ProductsProvider with ChangeNotifier {
  AuthProvider? _authProvider;

  void updateProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  final List<Product> _items = [];

  List<Product> get items {
    return _items;
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  var isFavorite = false;

  void toggleHomeFilter({required bool fav}) {
    isFavorite = fav;
    notifyListeners();
  }

  Future addProduct(Product product, File imgFile) async {
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/products.json?auth=${_authProvider!
        .token}";
    var uri = Uri.parse(url);

    await http
        .post(
      uri,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': 'data:image/jpg;base64,${base64Encode(imgFile.readAsBytesSync())}',
        'creatorId': _authProvider!.userId,
      }),
    )
        .then((response) {
      final addedProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(addedProduct);
      notifyListeners();
    }).catchError((err) {
      throw err;
    });
    return Future.value;
  }

  Future fetchProducts([bool filterByUser = false]) async {
    final filterString = filterByUser
        ? 'orderBy="creatorId"&equalTo="${_authProvider!.userId}"'
        : '';
    var url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/products.json?auth=${_authProvider!
        .token}&$filterString';
    _items.clear();
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    print(jsonResponse);
    final favUrl =
        "https://shop-b55ab-default-rtdb.firebaseio.com/userFavorites/${_authProvider!
        .userId}.json?auth=${_authProvider!.token}";
    final favResponse = await http.get(Uri.parse(favUrl));

    Map<String, dynamic> favData = json.decode(favResponse.body);
    if(jsonResponse == null || jsonResponse.isEmpty){
      print("here fetching products");
      return const HttpException("no products");
    }
    jsonResponse.forEach((productID, product) {
      _items.add(
        Product(
          id: productID,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
          isFavorite: favData == null ? false : favData[productID] ?? false,
        ),
      );
    });
    notifyListeners();
  }

  Future removeProduct(String id) async {
    final url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/products/$id.json?auth=${_authProvider!
        .token}';
    var uri = Uri.parse(url);

    await http.delete(uri).then((response) {
      if (response.statusCode == 200) {
        _items.removeWhere((product) => product.id == id);
        notifyListeners();
      } else {
        throw Future.error;
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future updateProduct(Product updatedProduct) async {
    final productIndex = _items
        .indexWhere((currentProduct) => currentProduct.id == updatedProduct.id);

    final url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/products/${updatedProduct
        .id}.json?auth=${_authProvider!.token}';

    var uri = Uri.parse(url);
    await http
        .patch(uri,
        body: json.encode({
          'title': updatedProduct.title,
          'description': updatedProduct.description,
          'price': updatedProduct.price,
          'imageUrl': updatedProduct.imageUrl,
          'isFavorite': updatedProduct.isFavorite
        }))
        .then((response) {
      if (response.statusCode == 200) {
        _items[productIndex] = updatedProduct;
        notifyListeners();
      } else {
        throw Future.error;
      }
    }).catchError((error) {
      throw error;
    });
  }
}
