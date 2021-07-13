import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/screen_arguments.dart';
import '../screens/search_product_screen.dart';
import '../providers/offers.dart';
import '../widgets/app_drawer.dart';
import '../widgets/offer_item.dart';

class OfferListScreen extends StatelessWidget {
  static const routeName = '/user-offers';

  String get userId => null;

  Future<void> _refreshedOffers(BuildContext context) async {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    await Provider.of<Offers>(context, listen: false).fetchAndSetOffers(shopId);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Offers'),
        backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(SearchProductScreen.routeName,
                  arguments: ScreenArguments(shopId, null, null,shopName,shopImageUrl));
            },
          ),
        ],
      ),
      drawer: AppDrawer(shopId,shopName,shopImageUrl),
      //drawer: AppDrawer(),
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

        child: FutureBuilder(
          future: _refreshedOffers(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshedOffers(context),
                      child: Consumer<Offers>(
                        builder: (ctx, offersData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: offersData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                OfferItem(
                                    offersData.items[i].id,
                                    offersData.items[i].amount.toString(),
                                    offersData.items[i].price.toString(),
                                    offersData.items[i].product_id,
                                    offersData.items[i].product_name,
                                    offersData.items[i].product_image_url,
                                    offersData.items[i].product_description,
                                    shopId,
                                  shopName,
                                  shopImageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
