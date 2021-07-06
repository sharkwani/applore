import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductDefinition {
  final String id;
  final String tittle;

  final String description;

  final double price;

  final String imageUrl;
  ProductDefinition(
      {this.id, this.tittle, this.description, this.price, this.imageUrl});

  Future<bool> addProtoFirebase(
      ProductDefinition loadedProduct, String shopID, String token) async {
    try {
      final url =
          "https://projectk-10000.firebaseio.com/Shops/$shopID/Products.json?auth=$token";
      var response = await http.post(url,
          body: json.encode({
            "tittle": loadedProduct.tittle,
            "price": loadedProduct.price,
            "imageUrl": loadedProduct.imageUrl,
            "description": loadedProduct.description,
          }));
      print(response.body);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ProductDefinition>> getProductFromFirebase(
      String shopID, token) async {
    print("in get");
    List<ProductDefinition> _items = [];
    var url =
        "https://projectk-10000.firebaseio.com/Shops/$shopID/Products.json?auth=$token";
    var response = await http.get(url);
    Map items_firebase = jsonDecode(response.body);
    print(items_firebase);
    print(response.body);
    if (items_firebase != null) {
      items_firebase.forEach((key, value) => {
            _items.add(ProductDefinition(
              id: key,
              tittle: value["tittle"],
              description: value["description"],
              price: value["price"],
              imageUrl: value["imageUrl"],
            ))
          });
      return _items;
    }
    return [];
  }
}
