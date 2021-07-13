import 'package:flutter/foundation.dart';

class Offer with ChangeNotifier {
  final String id;
  final int amount;
  final num price;
  final String shop_id;
  final String product_id;
  final String product_name;
  final String product_description;
  final String product_image_url;

  Offer(
      {@required this.id,
      @required this.amount,
      @required this.price,
      @required this.shop_id,
      @required this.product_id,
      @required this.product_image_url,
      @required this.product_name,
      @required this.product_description});

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        amount: json["amount"],
        price: json["price"],
        shop_id: json["shop_id"],
        product_id: json["product_id"],
        product_image_url: json['product_image_url'],
        product_description: json['product_description'],
        product_name: json['product_name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "price": price,
        "shop_id": shop_id,
        "product_id": product_id,
        "product_image_url": product_image_url,
        "product_description": product_description,
        "product_name": product_name,
      };
}
