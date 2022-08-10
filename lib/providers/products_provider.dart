import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = [];
  static const url =
      "https://shop-b55ab-default-rtdb.firebaseio.com/products.json";

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

  Future addProduct(Product product) async {
    var uri = Uri.parse(url);
    await http
        .post(
      uri,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
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

  Future fetchProducts() async {
    _items.clear();
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    Map<String, dynamic> jsonResponse = json.decode(response.body);

    jsonResponse.forEach((productID, product) {
      _items.add(
        Product(
          id: productID,
          title: product['title'],
          description: product['description'],
          price: product['price'],
          imageUrl: product['imageUrl'],
        ),
      );
    });
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();

    final url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/products/$id.json';
  }

  Future updateProduct(Product updatedProduct) async {
    final productIndex = _items
        .indexWhere((currentProduct) => currentProduct.id == updatedProduct.id);

    final url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/products/${updatedProduct.id}.json';

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
