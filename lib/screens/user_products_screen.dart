import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshedProducts(BuildContext context) async {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(shopId);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: ScreenArguments(shopId, null, null,shopName,shopImageUrl));
            },
          ),
        ],
      ),
      drawer: AppDrawer(shopId,shopName,shopImageUrl),
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
          future: _refreshedProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshedProducts(context),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                  shopId,
                                  productsData.items[i].id,
                                  productsData.items[i].name,
                                  productsData.items[i].image_url,
                                  shopName,
                                  shopImageUrl
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
