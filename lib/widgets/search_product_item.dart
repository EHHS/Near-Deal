import 'package:flutter/material.dart';

import '../providers/screen_arguments.dart';
import '../screens/edit_offer_screen.dart';

class SearchProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final String shopId;
  final String description;
  final String shopName;
  final String shopImageUrl;

  SearchProductItem(this.shopId, this.id, this.title, this.imageUrl,this.description,this.shopName,this.shopImageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          EditOfferScreen.routeName,
          arguments: ScreenArguments(shopId, id, null,shopName,shopImageUrl),
        );
      },
    child: Container(
      margin: EdgeInsets.only(top: 5.0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    ),child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(imageUrl),
        ),
      ),
    ),);
  }
}
