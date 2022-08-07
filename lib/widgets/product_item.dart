import 'package:flutter/material.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) //required this.title, required this.imageUrl, required this.id})
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    print("build");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, provider, child) {
              return IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: provider.isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  provider.toggleFavorite();
                },
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.add_shopping_cart_outlined),
            onPressed: () {},
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
