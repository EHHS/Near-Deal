import 'dart:io';

import 'package:ayz_eh/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/shop.dart';
import '../providers/auth.dart';

class Shops with ChangeNotifier {
  List<Shop> _shops = [];

  final String shopId;

  Shops(this.shopId, this._shops);

  List<Shop> get shops {
    return [..._shops];
  }

  Shop findById(String id) {
    return _shops.firstWhere((shop) => shop.id == id);
  }

  Future<void> uploadShopImage(String shopId, String filePath) async {
    print(shopId);
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://3ayez-eh.azurewebsites.net/upload_image?id=$shopId&type=shop'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }



  Future<void> fetchAndSetShops(String userId) async {
    var url = 'https://3ayez-eh.azurewebsites.net/shops/?user_id=$userId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data = extractedData['message'];
      if (extractedData == null) {
        return;
      }
      //print(data);

      final List<Shop> loadedShops = data.map((i) => Shop.fromJson(i)).toList();
      //print(loadedShops);
      _shops = loadedShops;
      //print(_shops);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addShop(Shop shop, String userId, File pickedImage,
      PlaceLocation pickedLocation) async {
    final url = 'https://3ayez-eh.azurewebsites.net/shops/';
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "shop": {
              "name": shop.name,
              "created_by": userId,
              "create_date": DateTime.now().toIso8601String(),
              "is_premium": false,
              "premium_end_date": DateTime.now().toIso8601String(),
              "weekly_views": '445455',
              "image_url": "https://storage.googleapis.com/ayz-eh.appspot.com/shops_images/9EMNNWbNGtfUBQMrgtYR.png",
              "description": shop.description,
              "lat": pickedLocation.latitude.toString(),
              "lon": pickedLocation.longitude.toString(),
            }
          }),
          headers: {'content-type': 'application/json'});
      print(response.body);
      uploadShopImage(json.decode(response.body)['message'], pickedImage.path);
      print(pickedImage.path);



      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateShop(String id, Shop newShop, File pickedImage,
      PlaceLocation pickedLocation, String userId) async {
    final shopIndex = _shops.indexWhere((shop) => shop.id == id);
    if (shopIndex >= 0) {
      final url = 'https://3ayez-eh.azurewebsites.net/shops/?shop_id=$id';
      final response = await http.put(Uri.parse(url),
          body: json.encode({
            "shop_id": id,
            "user_id": userId,
            "shop": {
              "name": newShop.name,
              "description": newShop.description,
              "created_by": newShop.created_by,
              "geohash": newShop.geohash,
              "image_url": "https://storage.googleapis.com/ayz-eh.appspot.com/shops_images/9EMNNWbNGtfUBQMrgtYR.png",
              "lat": pickedLocation.latitude.toString(),
              "lon": pickedLocation.longitude.toString(),
              "create_date": DateTime.now().toIso8601String(),
              "is_premium": false,
              "premium_end_date": DateTime.now().toIso8601String(),
              "weekly_views": '445455',
            },
          }),
          headers: {'content-type': 'application/json'});
      print(id);
      print(response.body);
      uploadShopImage(id, pickedImage.path);
      _shops[shopIndex] = newShop;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteShop(String id, String userId) async {
    final url = 'https://3ayez-eh.azurewebsites.net/shops/?shop_id=$id';
    final existingShopIndex = _shops.indexWhere((shop) => shop.id == id);
    var existingShop = _shops[existingShopIndex];
    _shops.removeAt(existingShopIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url),
        body: json.encode({
          "shop_id": id,
          "user_id": userId,
        }),
        headers: {'content-type': 'application/json'});
    print(response.body);
    print(response.statusCode);
    if (response.statusCode >= 400) {
      _shops.insert(existingShopIndex, existingShop);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    existingShop = null;

    notifyListeners();
  }
}
