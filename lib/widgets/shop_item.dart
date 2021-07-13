import 'package:ayz_eh/providers/auth.dart';
import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/user_products_screen.dart';

import '../screens/edit_shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';
import '../models/location_helper.dart';

class ShopItem extends StatelessWidget {
  final String shopId;
  final String title;
  final String imageUrl;
  final String lat;
  final String lon;

  ShopItem(this.shopId, this.title, this.imageUrl, this.lat, this.lon);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(UserProductsScreen.routeName, arguments: ScreenArguments(shopId, null, null,title,imageUrl));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: ListTile(
          title: Text(title),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : null,
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditShopScreen.routeName, arguments:ScreenArguments(shopId, null, null,title,imageUrl));
                  },
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      String userId = Provider.of<Auth>(context, listen: false).userId;
                      await Provider.of<Shops>(context, listen: false)
                          .deleteShop(shopId , userId);
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Deleting successful'),
                        ),
                      );
                    } catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text('Deleting failed'),
                        ),
                      );
                    }
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
