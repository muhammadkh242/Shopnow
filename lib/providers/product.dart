import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future toggleFavorite(String userId, String token) async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shop-b55ab-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    var uri = Uri.parse(url);

    await http
        .put(
      uri,
      body: json.encode(
        isFavorite,
      ),
    )
        .then(
      (response) {
        if (response.statusCode != 200) {
          isFavorite = !isFavorite;
          notifyListeners();
        }
      },
    );
  }
}
