import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/screens/orders_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Shopnow'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text("Shop"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.payment,
            ),
            title: const Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text("Manage Products"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            onTap: (){
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            leading: const Icon(
              Icons.exit_to_app_outlined,
            ),
            title: const Text("Logout"),

          ),
        ],
      ),
    );
  }
}
