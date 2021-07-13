import 'package:ayz_eh/screens/search_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/splash_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/shops.dart';
import './providers/offers.dart';
import './screens/edit_offer_screen.dart';
import './screens/offer_detail_screen.dart';
import './screens/offers_list_screen.dart';
import './screens/search_product_screen.dart';
import './screens/shop_list_screen.dart';
import './providers/auth.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/edit_shop_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Shops>(
          update: (ctx, auth, previousProducts) => Shops(
            auth.token,
            previousProducts == null ? [] : previousProducts.shops,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Offers>(
          update: (ctx, auth, previousOffers) => Offers(
            auth.token,
            previousOffers == null ? [] : previousOffers.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.productsByName,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            accentColor: Colors.blue,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ShopListScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            SearchResultScreen.routeName:(ctx)=>SearchResultScreen(),
            SearchProductScreen.routeName: (ctx) => SearchProductScreen(),
            EditOfferScreen.routeName: (ctx) => EditOfferScreen(),
            OfferListScreen.routeName: (ctx) => OfferListScreen(),
            ShopListScreen.routeName: (ctx) => ShopListScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            OfferDetailScreen.routeName: (ctx) => OfferDetailScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            EditShopScreen.routeName: (ctx) => EditShopScreen(),
          },
        ),
      ),
    );
  }
}
