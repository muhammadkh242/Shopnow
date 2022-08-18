import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order.dart';

class OrderRowItem extends StatefulWidget {
  const OrderRowItem({Key? key, required this.orderItem}) : super(key: key);

  final OrderItem orderItem;

  @override
  State<OrderRowItem> createState() => _OrderRowItemState();
}

class _OrderRowItemState extends State<OrderRowItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.orderItem.products.length *20.0 + 110.0, 200) : 95,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    "\$ ${widget.orderItem.amount.toString()}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(widget.orderItem.dateTime),
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(10.0),
                  height: _expanded
                      ? min(widget.orderItem.products.length * 50.0, 100)
                      : 0,
                  child: ListView(
                    children: widget.orderItem.products
                        .map(
                          (product) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${product.quantity}x \$${product.price}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
