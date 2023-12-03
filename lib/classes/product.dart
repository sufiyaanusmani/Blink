import 'package:food_delivery/classes/cart.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/mysql.dart';

class Product {
  int id;
  String name;
  int restaurantID;
  int categoryID;
  String categoryName;
  int price;
  bool liked;

  Product(
      {required this.id,
      required this.name,
      required this.restaurantID,
      required this.categoryID,
      required this.categoryName,
      required this.price,
      required this.liked});

  static Future<List<Product>> getProducts(int restaurantID) async {
    var db = Mysql();
    List<Product> products = [];
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT P.product_id, P.name, P.restaurant_id, P.category_id, P.price, C.name AS category_name FROM Product P INNER JOIN Category C ON P.category_id = C.category_id WHERE P.restaurant_id=$restaurantID;');

    for (var row in rows) {
      // firstName = row.assoc()['first_name']!;
      Product product = Product(
          id: int.parse(row.assoc()['product_id']!),
          name: row.assoc()['name']!,
          restaurantID: int.parse(row.assoc()['restaurant_id']!),
          categoryID: int.parse(row.assoc()['category_id']!),
          categoryName: row.assoc()['category_name']!,
          price: int.parse(row.assoc()['price']!),
          liked: false);
      products.add(product);
    }

    rows = await db.getResults(
        'SELECT product_id FROM Favourites WHERE customer_id=${Cart.customerID}');

    for (var row in rows) {
      int prod = int.parse(row.assoc()['product_id']!);
      for (int i = 0; i < products.length; i++) {
        if (prod == products[i].id) {
          products[i].liked = true;
        }
      }
    }

    return products;
  }

  static Future<List<Product>> getAllProducts() async {
    var db = Mysql();
    List<Product> products = [];
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT P.product_id, P.name, P.restaurant_id, P.category_id, P.price, C.name AS category_name FROM Product P INNER JOIN Category C ON P.category_id = C.category_id;');

    for (var row in rows) {
      // firstName = row.assoc()['first_name']!;
      Product product = Product(
          id: int.parse(row.assoc()['product_id']!),
          name: row.assoc()['name']!,
          restaurantID: int.parse(row.assoc()['restaurant_id']!),
          categoryID: int.parse(row.assoc()['category_id']!),
          categoryName: row.assoc()['category_name']!,
          price: int.parse(row.assoc()['price']!),
          liked: false);
      products.add(product);
    }

    rows = await db.getResults(
        'SELECT product_id FROM Favourites WHERE customer_id=${Cart.customerID}');

    for (var row in rows) {
      int prod = int.parse(row.assoc()['product_id']!);
      for (int i = 0; i < products.length; i++) {
        if (prod == products[i].id) {
          products[i].liked = true;
        }
      }
    }

    return products;
  }
}
