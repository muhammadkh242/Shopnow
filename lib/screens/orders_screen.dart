import 'package:flutter/material.dart';
import 'package:shop/providers/order.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.error != null) {
              return const Center(
                child: Text('No Orders yet!!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      itemCount: ordersData.orders.length,
                      itemBuilder: (ctx, i) => OrderRowItem(
                        orderItem: ordersData.orders[i],
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
