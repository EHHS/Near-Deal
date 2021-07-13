import 'package:ayz_eh/providers/auth.dart';
import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/product_detail_screen.dart';
import 'package:ayz_eh/screens/user_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String shopId;
  final String shopName;
  final String shopImageUrl;

  UserProductItem(this.shopId, this.id, this.title, this.imageUrl,this.shopName,this.shopImageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: ScreenArguments(shopId, id,null,shopName,shopImageUrl),);
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
          backgroundImage: NetworkImage(imageUrl),
        ),

        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: ScreenArguments(null, id, null,shopName,shopImageUrl),);
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteProduct(id,shopId);
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
    ),);
  }
}
