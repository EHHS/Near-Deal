import 'package:ayz_eh/providers/product.dart';

class ProductArguments {
  final String shopId;
  final List<Product> results;
  final String shopImageUrl;
  final String shopName;

  ProductArguments(this.shopId, this.results,this.shopName,this.shopImageUrl);
}