import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/edit_offer_screen.dart';
import 'package:ayz_eh/screens/offer_detail_screen.dart';
import 'package:ayz_eh/screens/offers_list_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offers.dart';

class OfferItem extends StatelessWidget {
  final String offerId;
  final String amount;
  final String price;
  final String productId;
  final String productName;
  final String productImageUrl;
  final String productDescription;
  final String shopId;
  final String shopName;
  final String shopImageUrl;

  OfferItem(
      this.offerId,
      this.amount,
      this.price,
      this.productId,
      this.productName,
      this.productImageUrl,
      this.productDescription,
      this.shopId,
      this.shopName,
      this.shopImageUrl
      );


  @override
  Widget build(BuildContext context) {
    print(shopId);
    final scaffold = Scaffold.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(OfferDetailScreen.routeName,
            arguments: ScreenArguments(shopId, null, offerId,shopName,shopImageUrl));
      },
    child: Container(
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    ),
      child: ListTile(
        title: Text(productName),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(productImageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditOfferScreen.routeName,
                      arguments: ScreenArguments(shopId, productId, offerId,shopName,shopImageUrl));
                },
                color: Theme.of(context).primaryColor,
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<Offers>(context, listen: false)
                        .deleteOffer(offerId);
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
      ),),
    );
  }
}
