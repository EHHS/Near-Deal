import '../providers/product_arguments.dart';
import '../widgets/search_product_item.dart';
import 'package:flutter/material.dart';

class SearchResultScreen extends StatelessWidget {
  static const routeName = '/search-results';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ProductArguments;
    final shopId = args.shopId;
    final shopName = args.shopName;
    final shopImageUrl = args.shopImageUrl;
    final _results = args.results;
    print(shopId);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product Results'),
          backgroundColor: Color.fromRGBO(225, 245, 240, 1),
        ),
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
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ListView.builder(
              itemCount: _results.length,
              itemBuilder: (_, i) => Column(
                children: [
                  SearchProductItem(shopId, _results[i].id, _results[i].name,
                      _results[i].image_url,_results[i].description,shopName,shopImageUrl),
                  Divider(),
                ],
              ),
            ),
          ),
        ));
  }
}
