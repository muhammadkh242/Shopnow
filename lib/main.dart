import 'package:flutter/material.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/product_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ProductsProvider(),
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.deepOrangeAccent,
                secondary: Colors.blueGrey,
              ),
          fontFamily: 'Lato',
        ),
        home: const HomeScreen(),
        routes: {
          ProductDetailsScreen.routeName : (ctx) => const ProductDetailsScreen()
        },
      ),
    );
  }
}
