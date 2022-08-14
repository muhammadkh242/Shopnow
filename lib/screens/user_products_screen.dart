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
    print("refreshitems");
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {

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
      body: FutureBuilder(
        future: _refreshItems(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshItems(context),
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productsData, _) => ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: productsData.items.length,
                        itemBuilder: (ctx, i) {
                          return UserProductItem(
                              id: productsData.items[i].id,
                              imageUrl: productsData.items[i].imageUrl,
                              title: productsData.items[i].title);
                        },
                      ),
                    )),
      ),
    );
  }
}
