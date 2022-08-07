import 'package:flutter/material.dart';
import 'package:shop/shared/dummy_products.dart';

import 'product.dart';

class ProductsProvider with ChangeNotifier {

  final List<Product> _items = getProducts();

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id){
    return _items.firstWhere((product) => product.id == id);
  }

  var isFavorite = false;

  void toggleHomeFilter({required bool fav}){
    isFavorite = fav;
    notifyListeners();
  }

}
