import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:ayz_eh/screens/offers_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_offer_screen.dart';
import '../screens/user_products_screen.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments
        as ScreenArguments; // is the id!
    final productId = args.productId;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(25, 118, 210, 1).withOpacity(0.5),
              Color.fromRGBO(13, 71, 161, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color.fromRGBO(225, 245, 240, 1),
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 10),
                  Text(
                    loadedProduct.name,
                    style: TextStyle(
                      color: Color.fromRGBO(225, 245, 240, 1),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedProduct.description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Color.fromRGBO(225, 245, 240, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Add new Offer'),
                    ),
                    color: Color.fromRGBO(225, 245, 240, 1),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        EditOfferScreen.routeName,
                        arguments: ScreenArguments(shopId, productId, null,shopName,shopImageUrl),
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
