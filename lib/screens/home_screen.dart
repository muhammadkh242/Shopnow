import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder/conditional_builder.dart';

enum FilterOptions {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;

  @override
  void initState() {
    if (_isInit) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
      Provider.of<Cart>(context, listen: false).fetchCart();

      _isInit = false;
    }
    super.initState();
  }

  Future _refreshItems(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productList = productsProvider.isFavorite
        ? productsProvider.favItems
        : productsProvider.items;
    productList.forEach((element) {
      print("element");
      print(element.id);
      print(element.isFavorite);
    });
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(productsProvider.isFavorite ? 'Favorites' :'Home'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                productsProvider.toggleHomeFilter(fav: true);
              } else {
                productsProvider.toggleHomeFilter(fav: false);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text("Only Favorites"),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text("Show All"),
              )
            ],
            icon: const Icon(
              Icons.filter_list_outlined,
              size: 31,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 3,
              right: 3.0,
            ),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  radius: 12,
                  child: Consumer<Cart>(
                    builder: (ctx, cartProvider, _) {
                      return Text(
                        cartProvider.itemsCount.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: ConditionalBuilder(
        condition: productsProvider.items.isNotEmpty,
        builder: (context) => RefreshIndicator(
          onRefresh: () => _refreshItems(context),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (ctx, i) {
              return ChangeNotifierProvider.value(
                value: productList[i],
                child: const ProductItem(),
              );
            },
            itemCount: productList.length,
          ),
        ),
        fallback: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
