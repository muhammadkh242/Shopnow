import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  AuthProvider? _authProvider;

  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }
  void updateToken(AuthProvider authProvider){
    _authProvider = authProvider;
  }
  Future addOrder({
    required List<CartItem> cartProducts,
    required double amount,
  }) async {
    final url =
        "https://shop-b55ab-default-rtdb.firebaseio.com/orders/${_authProvider!.userId}.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);
    await http
        .post(
      uri,
      body: json.encode({
        'products': cartProducts.map((cartProduct) {
          return {
            'id': cartProduct.id,
            'title': cartProduct.title,
            'quantity': cartProduct.quantity,
            'price': cartProduct.price,
          };
        }).toList(),
        'dateTime': DateTime.now().toString(),
        'amount': amount,
      }),
    )
        .then((response) {
      if (response.statusCode == 200) {
        _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)["name"],
            amount: amount,
            products: cartProducts,
            dateTime: DateTime.now(),
          ),
        );
        notifyListeners();
      } else {
        throw const HttpException("can't add order");
      }
    }).catchError((error) {
      throw error;
    });
  }

  Future fetchOrders() async {
    _orders.clear();
    final url = "https://shop-b55ab-default-rtdb.firebaseio.com/orders/${_authProvider!.userId}.json?auth=${_authProvider!.token}";
    var uri = Uri.parse(url);
    final response = await http.get(uri);
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if(jsonResponse == null){
      return;
    }
    jsonResponse.forEach((orderId, orderItem) {
      _orders.add(
        OrderItem(
          id: orderId,
          amount: orderItem['amount'],
          products: (orderItem['products'] as List<dynamic>).map((item) {
            return CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            );
          }).toList(),
          dateTime: DateTime.parse(orderItem['dateTime']),
        ),
      );
    });
    print(orders.length);
    _orders.reversed;
    notifyListeners();
  }
}
