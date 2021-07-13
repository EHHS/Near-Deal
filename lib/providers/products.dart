import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _productsByName = [];

  final String prodId;

  Products(this.prodId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get productsByName {
    return [..._productsByName];
  }

  Product findById(String id) {
    print(id);
    //print(_items);
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

  Future<List> fetchAndSetProductbyName(String product_name) async {
    var url = 'https://3ayez-eh.azurewebsites.net/products/?name=$product_name';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data = extractedData['message'];
      if (extractedData == null) {
        return null;
      }
      final List<Product> loadedShops =
      data.map((i) => Product.fromJson(i)).toList();
      _productsByName = loadedShops;
      return loadedShops;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchAndSetProducts(String shopId) async {
    var url = 'https://3ayez-eh.azurewebsites.net/products/?created_by=$shopId';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data = extractedData['message'];
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedShops =
          data.map((i) => Product.fromJson(i)).toList();
      _items = loadedShops;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product, String shopId, String userId, File pickedImage) async {
    final url = 'https://3ayez-eh.azurewebsites.net/products/';
    print(product.brand);
    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            "product": {
              "name": product.name,
              "created_by": shopId,
              "image_url": 'https://storage.googleapis.com/ayz-eh.appspot.com/shops_images/9EMNNWbNGtfUBQMrgtYR.png',
              "description": product.description,
              "category": product.category,
              "brand": product.brand,
              "views": '445455',
            }
          }),
          headers: {'content-type': 'application/json'});
      print(response.statusCode);
      print(response.body);
      uploadProductImage(json.decode(response.body)['message'], pickedImage.path);



      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String shopId,
      String id, Product newProduct, String userId, File pickedImage) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://3ayez-eh.azurewebsites.net/products/?product_id=$id';
      final response = await http.put(Uri.parse(url),
          body: json.encode({
            "product_id": id,
            "shop_id": shopId,
            'product': {
              'name': newProduct.name,
              'description': newProduct.description,
              'image_url': newProduct.image_url,
              "created_by": shopId,
              'category': newProduct.category,
              "brand": newProduct.brand,
              "views":"13216",
            },
          }),
          headers: {'content-type': 'application/json'});
      uploadProductImage(id, pickedImage.path);
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id, String userId) async {
    final url =
        'https://3ayez-eh.azurewebsites.net/products/?product_id=$id';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url),
        body: json.encode({
          "product_id": id,
          "shop_id": userId,
        }),
        headers: {'content-type': 'application/json'});
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    existingProduct = null;

    notifyListeners();
  }
}
