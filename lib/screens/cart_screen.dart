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
              OrderButton(cartData: cartData, ordersData: ordersData)
            ],
          ),
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartData,
    required this.ordersData,
  }) : super(key: key);

  final Cart cartData;
  final Orders ordersData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Padding(
            padding: EdgeInsets.all(10.0),
            child: CircularProgressIndicator(),
          )
        : TextButton(
            onPressed: (widget.cartData.items.isEmpty || _isLoading)
                ? null
                : () {
                    setState(() {
                      _isLoading = true;
                    });
                    widget.ordersData
                        .addOrder(
                      cartProducts: widget.cartData.items.values.toList(),
                      amount: widget.cartData.totalAmount,
                    )
                        .then((value) {
                      setState(() {
                        _isLoading = false;
                      });
                      widget.cartData.clear();
                    }).catchError((error) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Failed please check your connection and try again!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    });
                  },
            child: const Text(
              "Order Now",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
  }
}
