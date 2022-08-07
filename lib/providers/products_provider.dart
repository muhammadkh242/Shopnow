import 'package:flutter/material.dart';
import 'package:shop/shared/dummy_products.dart';

import '../models/product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = getProducts();

  List<Product> get items {
    return _items;
  }

  Product findProductById(String id){
    return _items.firstWhere((product) => product.id == id);
  }
}
