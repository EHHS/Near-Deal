import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/offer.dart';
import '../models/http_exception.dart';

class Offers with ChangeNotifier {
  List<Offer> _items = [];

  final String prodId;

  Offers(this.prodId, this._items);

  List<Offer> get items {
    return [..._items];
  }

  Offer findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> uploadProductImage(String productId, String filePath) async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://3ayez-eh.azurewebsites.net/upload_image?id=$productId&type=product'));
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> fetchAndSetOffers(String shopId) async {
    var url = 'https://3ayez-eh.azurewebsites.net/offers/?shop_id=$shopId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data = extractedData['message'];
      if (extractedData == null) {
        return;
      }
      final List<Offer> loadedOffers =
          data.map((i) => Offer.fromJson(i)).toList();
      _items = loadedOffers;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addOffer(Offer offer) async {
    final url = 'https://3ayez-eh.azurewebsites.net/offers/';
    try {
    final response = await http.post(Uri.parse(url),
          body: json.encode({
            "offer": {
              "amount": offer.amount,
              "shop_id": offer.shop_id,
              "price": offer.price,
              "product_id": offer.product_id,
            }
          }),
          headers: {'content-type': 'application/json'});
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateOffer(String id, Offer newOffer) async {
    final offerIndex = _items.indexWhere((offer) => offer.id == id);
    if (offerIndex >= 0) {
      final url = 'https://3ayez-eh.azurewebsites.net/offers/';
      final response = await http.put(Uri.parse(url),
          body: json.encode({
            'offer_id': id,
            'offer': {
              "amount": newOffer.amount,
              "shop_id": newOffer.shop_id,
              "price": newOffer.price,
              "product_id": newOffer.product_id,
            },
          }),
          headers: {'content-type': 'application/json'});
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteOffer(String id) async {
    final url = 'https://3ayez-eh.azurewebsites.net/offers/';
    final existingOfferIndex = _items.indexWhere((prod) => prod.id == id);
    var existingOffer = _items[existingOfferIndex];
    _items.removeAt(existingOfferIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url),
        body: json.encode({
          "offer_id": id,
        }),
        headers: {'content-type': 'application/json'});
    if (response.statusCode >= 400) {
      _items.insert(existingOfferIndex, existingOffer);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    existingOffer = null;

    notifyListeners();
  }
}
