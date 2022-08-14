import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({Key? key}) : super(key: key);
  static const routeName = "/product-details";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false,
    ).findProductById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: productId,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  loadedProduct.description,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "\$ ${loadedProduct.price.toString()}",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 800,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/*Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Hero(
                tag: productId,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              loadedProduct.description,
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "\$ ${loadedProduct.price.toString()}",
              style: const TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),


          ],
        )*/
