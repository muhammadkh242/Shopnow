import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_procuct_item.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({Key? key}) : super(key: key);
  static const routeName = "/user-products";

  Future _refreshItems(BuildContext context) async {
    await Provider.of<ProductsProvider>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("My Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: UserProductsScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshItems(context),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: productsData.items.length,
          itemBuilder: (ctx, i) {
            return UserProductItem(
                id: productsData.items[i].id,
                imageUrl: productsData.items[i].imageUrl,
                title: productsData.items[i].title);
          },
        ),
      ),
    );
  }
}
