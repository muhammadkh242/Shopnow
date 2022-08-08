import 'package:flutter/material.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/screens/user_products_screen.dart';
import 'package:shop/widgets/user_procuct_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[250],
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Colors.deepOrangeAccent,
                secondary: Colors.blueGrey,
              ),
          fontFamily: 'Lato',
        ),
        //home: HomeScreen(),
        routes: {
          '/': (ctx) => HomeScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
        },
      ),
    );
  }
}
