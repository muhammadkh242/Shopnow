import 'dart:convert';

import 'package:flutter/material.dart';

import 'auth.dart';
import 'package:http/http.dart' as http;

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  List<CartItem> _cartList = [];

  List<CartItem> get cartList {
    return [..._cartList];
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future removeItem({required String productId}) async {
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/cart/${_authProvider!.userId}/$productId.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);
    await http.delete(uri).then((response) {
      if (response.statusCode == 200) {
        _items.remove(productId);
        notifyListeners();
      }
    });
  }

  void undoAddToCart({required String id}) {
    if (!(_items.keys.contains(id))) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void addItem({
    required String id,
    required String title,
    required double price,
  }) {
    print(id);
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
                price: existingItem.price,
              ));
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    print(_items);
    notifyListeners();
  }

  AuthProvider? _authProvider;

  void updateToken(AuthProvider authProvider) {
    _authProvider = authProvider;
  }

  Future addCartItem({
    required String id,
    required String title,
    required double price,
  }) async {
    var quantity;
    if (_items.containsKey(id)) {
      quantity = _items['id']!.quantity + 1;
      _items.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      quantity = 1;
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/cart/${_authProvider!.userId}.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);

    await http
        .post(uri,
            body: json.encode({
              'id': id,
              'title': title,
              'price': price,
              'quantity': quantity,
            }))
        .then((response) {
      print("cart response status code : ${response.statusCode}");
      if (response.statusCode == 200) {
        notifyListeners();
      }
    });
  }

  Future fetchCart() async {
    _items.clear();
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/cart/${_authProvider!.userId}.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    Map<String, dynamic> cartResponse = json.decode(response.body);
    if(cartResponse == null){
      return;
    }
    cartResponse.forEach(
      (itemID, item) {
        item = CartItem(
          id: item['id'],
          title: item['title'],
          quantity: item['quantity'],
          price: item['price'],
        );
        _items.putIfAbsent(itemID, () => item);
      },
    );
    print(_items);
    notifyListeners();
  }

  Future clear() async {
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/cart/${_authProvider!.userId}.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);
    await http.delete(uri).then((response) {
      if (response.statusCode == 200) {
        _items = {};
        notifyListeners();
      }
    });
  }
}
