import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/offers.dart';

class OfferDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/offer-detail';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final offerId = args.offerId;
    final shopId = args.shopId;
    final loadedOffer = Provider.of<Offers>(
      context,
      listen: false,
    ).findById(offerId);
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
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(loadedOffer.product_name),
                background: Hero(
                  tag: loadedOffer.id,
                  child: Image.network(
                    loadedOffer.product_image_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(height: 15),
                  Text(
                    loadedOffer.product_name,
                    style: TextStyle(
                      color: Color.fromRGBO(225, 245, 240, 1),
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      loadedOffer.product_description,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Color.fromRGBO(225, 245, 240, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      'The Price of ${loadedOffer.product_name} = ${loadedOffer.price}',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Color.fromRGBO(225, 245, 240, 1)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Text(
                      'The Amount of Stock of ${loadedOffer.product_name} = ${loadedOffer.amount}',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(color: Color.fromRGBO(225, 245, 240, 1)),

                    ),
                  ),
                  SizedBox(
                    height: 800,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
