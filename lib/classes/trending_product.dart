import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class TrendingProduct {
  final String productID;
  final String productName;
  final String restaurantID;
  final String restaurantName;
  final int categoryID;
  final int price;
  final String categoryName;
  final bool liked;

  /// Constructor for [TrendingProduct]
  ///
  /// Parameters:
  ///   - productID: [String]
  ///   - productName: [String]
  ///   - restaurantID: [String]
  ///   - restaurantName: [String]
  ///   - categoryID: [int]
  ///   - price: [int]
  ///   - categoryName: [String]
  ///   - liked: [bool]
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// TrendingProduct obj = TrendingProduct(productID, productName, restaurantName, restaurantName, categoryName, price, categoryID, liked);
  /// ```
  TrendingProduct(
      {required this.productID,
      required this.productName,
      required this.restaurantID,
      required this.restaurantName,
      required this.categoryName,
      required this.price,
      required this.categoryID,
      required this.liked});

  /// Gets trending products
  ///
  /// Returns:
  ///   Future<List<TrendingProduct>>
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// await getTrendingProducts();
  /// ```
  static Future<List<TrendingProduct>> getTrendingProducts() async {
    List<TrendingProduct> trendingProducts = [];
    List<Map<String, dynamic>> products = [];
    List<Map<String, String>> restaurants = [];

    // get all restaurants
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("restaurants").get();
      for (QueryDocumentSnapshot restaurantData in querySnapshot.docs) {
        Map<String, dynamic> res =
            restaurantData.data() as Map<String, dynamic>;
        restaurants.add({
          "id": restaurantData.id.toString(),
          "name": res["name"].toString()
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    // get all products
    try {
      for (Map<String, String> restaurant in restaurants) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("restaurants")
            .doc(restaurant["id"])
            .collection("foodItems")
            .get();
        for (QueryDocumentSnapshot foodData in querySnapshot.docs) {
          Map<String, dynamic> food = foodData.data() as Map<String, dynamic>;
          products.add({
            "id": foodData.id,
            "name": food["Prod Name"].toString() ?? " ",
            "restaurantID": restaurant["id"].toString(),
            "categoryName": food["Category Name"].toString(),
            "price": food["Price"] ?? 0,
            "restaurantName": restaurant["name"].toString(),
            "liked": false,
            "likeCount": int.parse(food["Like Count"])
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    products.sort((a, b) => b["likeCount"].compareTo(a["likeCount"]));
    List<Map<String, dynamic>> top5 = products.sublist(0, 5);

    for (Map<String, dynamic> product in top5) {
      trendingProducts.add(TrendingProduct(
          productID: product["id"],
          productName: product["name"],
          restaurantID: product["restaurantID"],
          restaurantName: product["restaurantName"],
          categoryName: product["categoryName"],
          price: product["price"],
          categoryID: 1,
          liked: product["liked"]));
    }

    return trendingProducts;
  }
}
