// import 'package:food_delivery/classes/cart.dart';
// import 'package:mysql_client/mysql_client.dart';
// import 'package:food_delivery/mysql.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String restaurantID;
  String categoryName;
  int price;
  bool liked;

  Product(
      {required this.id,
      required this.name,
      required this.restaurantID,
      required this.categoryName,
      required this.price,
      required this.liked});

  static List<Product> getProducts(String restaurantID) {
    List<Product> products = [];
    FirebaseFirestore.instance
        .collection('products')
        .where("restaurantid", isEqualTo: restaurantID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        products.add(Product(
            id: doc.id,
            name: doc["name"],
            restaurantID: doc["restaurantid"],
            categoryName: doc["category"],
            price: doc["price"],
            liked: false));
        print(doc["name"]);
      });
    });
    return products;
  }
}
