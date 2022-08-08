import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/widgets/product_item.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorites,
  All,
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final productList = productsProvider.isFavorite
        ? productsProvider.favItems
        : productsProvider.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
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
            icon: const Icon(Icons.filter_list_outlined),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
              ),
              CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 12,
                child: Consumer<Cart>(
                  builder: (ctx, cartProvider, _){
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
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, i) {
          return ChangeNotifierProvider.value(
            value: productList[i],
            child: const ProductItem(),
          );
        },
        itemCount: productList.length,
      ),
    );
  }
}
