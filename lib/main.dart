import 'package:flutter/material.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/providers/products_provider.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/product_details_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';
import 'package:hexcolor/hexcolor.dart';
void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => AuthProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (ctx) => ProductsProvider(),
            update: (ctx, authProvider, previousProducts) =>
                ProductsProvider()..updateProvider(authProvider),
          ),
          ChangeNotifierProxyProvider<AuthProvider, Orders>(
            create: (ctx) => Orders(),
            update: (ctx, authProvider, previousOrders) =>
                Orders()..updateToken(authProvider),
          ),
          ChangeNotifierProxyProvider<AuthProvider, Cart>(
            create: (ctx) => Cart(),
            update: (ctx, authProvider, previousCart) =>
            Cart()..updateToken(authProvider),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.grey[250],
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: HexColor('#8e4585'),
                    secondary: Colors.blue[300],
                  ),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authSnapShot) =>
                        authSnapShot.connectionState == ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            routes: {
              //'/': (ctx) => const AuthScreen(),
              ProductDetailsScreen.routeName: (ctx) =>
                  const ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        ));
  }
}
