import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/cart_item.dart';

import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final ordersData = Provider.of<Orders>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text("Shopping Cart"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: cartData.items.length,
                itemBuilder: (ctx, i) => CartRowItem(
                  id: cartData.items.values.toList()[i].id,
                  productId: cartData.items.keys.toList()[i],
                  title: cartData.items.values.toList()[i].title,
                  quantity: cartData.items.values.toList()[i].quantity,
                  price: cartData.items.values.toList()[i].price,
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Chip(
                        label: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text("\$ ${cartData.totalAmount}"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //.......... add order remotely..............
                  if (cartData.items.isNotEmpty) {
                    ordersData
                        .addOrder(
                      cartProducts: cartData.items.values.toList(),
                      amount: cartData.totalAmount,
                    )
                        .then((value) {
                      cartData.clear();
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Failed please check your connection and try again!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Shopping cart is empty!"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: const Text(
                  "Order Now",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
