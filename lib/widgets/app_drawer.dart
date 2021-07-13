import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/shop_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/user_products_screen.dart';
import '../screens/offers_list_screen.dart';
import '../screens/edit_shop_screen.dart';

class AppDrawer extends StatelessWidget {
  final String shopId;
  final String shopName;
  final String shopImageUrl;

  AppDrawer(this.shopId, this.shopName, this.shopImageUrl);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello $shopName'),
            backgroundColor: Color.fromRGBO(225, 245, 240, 1),
            automaticallyImplyLeading: false,
          ),
          CircleAvatar(
            radius: 30,
            child: Image.network(
              shopImageUrl,
              fit: BoxFit.cover,
            ),
          ),
          FlatButton(
            child: Text('Edit'),
            color: Color.fromRGBO(225, 245, 240, 1),
            onPressed: () {
              Navigator.of(context).pushNamed(EditShopScreen.routeName,
                  arguments: ScreenArguments(
                      shopId, null, null, shopName, shopImageUrl));
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Manage my Offers'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  OfferListScreen.routeName,
                  arguments: ScreenArguments(
                      shopId, null, null, shopName, shopImageUrl));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  UserProductsScreen.routeName,
                  arguments: ScreenArguments(
                      shopId, null, null, shopName, shopImageUrl));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Return to My Shops'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(
                  ShopListScreen.routeName,
                  arguments: ScreenArguments(
                      shopId, null, null, shopName, shopImageUrl));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
