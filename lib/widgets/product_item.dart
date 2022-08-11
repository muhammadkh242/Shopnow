import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) //required this.title, required this.imageUrl, required this.id})
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, provider, child) {
              return IconButton(
                color: Theme.of(context).colorScheme.secondary,
                icon: provider.isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  provider.toggleFavorite(
                    authProvider.userId,
                    authProvider.token!,
                  );
                },
              );
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            splashColor: Theme.of(context).colorScheme.secondary,
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItem(
                id: product.id,
                title: product.title,
                price: product.price,
              );
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Item added to cart"),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () {
                      cartProvider.undoAddToCart(id: product.id);
                    },
                  ),
                ),
              );
            },
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
