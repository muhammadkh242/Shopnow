import 'package:flutter/material.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/shared/dummy_products.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productList = productsProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          return ProductItem(
            id: productList[i].id,
            title: productList[i].title,
            imageUrl: productList[i].imageUrl,
          );
        },
        itemCount: productList.length,
      ),
    );
  }
}
