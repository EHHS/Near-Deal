import 'package:flutter/foundation.dart';

class Product with ChangeNotifier{
  final String id;
  final String name;
  final String description;
  final String image_url;
  final String created_by;
  final String category;
  final String brand;

  Product(
      {@required this.id,
        @required this.name,
        @required this.description,
        @required this.image_url,
        @required this.created_by,
        @required this.category,
        @required this.brand,
        });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    created_by: json["created_by"],
    image_url: json["image_url"],
    category: json['category'],
    brand: json['brand'],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "created_by": created_by,
    "image_url": image_url,
    "category": category,
    "brand":brand,
  };
}
