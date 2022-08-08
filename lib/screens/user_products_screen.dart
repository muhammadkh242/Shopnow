import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/user_procuct_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = "/user-products";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      body: ListView.builder(
        itemCount: productsData.items.length,
        itemBuilder: (ctx, i){
          return UserProductItem(imageUrl: productsData.items[i].imageUrl, title: productsData.items[i].title);
        },
      ),
    );
  }
}
