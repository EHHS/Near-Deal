import 'package:ayz_eh/providers/screen_arguments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_shop_screen.dart';
import '../widgets/shop_item.dart';
import '../providers/shops.dart';
import '../providers/auth.dart';
import '../widgets/app_drawer_shop.dart';

class ShopListScreen extends StatelessWidget {
  static const routeName = '/user-shops';

  String get userId => null;

  Future<void> _refreshedShops(BuildContext context) async {
    String userId = Provider.of<Auth>(context, listen: false).userId;
    await Provider.of<Shops>(context, listen: false).fetchAndSetShops(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Shops'),
        backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditShopScreen.routeName,arguments: ScreenArguments(null, null, null,null,null));
            },
          ),
        ],
      ),
      drawer: AppShopDrawer(),
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
          future: _refreshedShops(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _refreshedShops(context),
                      child: Consumer<Shops>(
                        builder: (ctx, shopsData, _) => Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: shopsData.shops.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                ShopItem(
                                  shopsData.shops[i].id,
                                  shopsData.shops[i].name,
                                  shopsData.shops[i].image_url,
                                  shopsData.shops[i].lat,
                                  shopsData.shops[i].lon,
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
