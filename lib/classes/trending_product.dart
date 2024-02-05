import 'package:food_delivery/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class TrendingProduct {
  final int productID;
  final String productName;
  final int restaurantID;
  final String restaurantName;
  final int categoryID;
  final int price;
  final String categoryName;
  final bool liked;

  TrendingProduct(
      {required this.productID,
      required this.productName,
      required this.restaurantID,
      required this.restaurantName,
      required this.categoryName,
      required this.price,
      required this.categoryID,
      required this.liked});

  static Future<List<TrendingProduct>> getTrendingProducts() async {
    List<TrendingProduct> products = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        "SELECT P.product_id, P.name AS product_name, R.restaurant_id as restaurant_id, R.name AS restaurant_name, SUM(D.quantity) AS quantity, C.category_id, C.name AS category_name, P.price FROM OrderDetail D INNER JOIN Product P ON (D.product_id = P.product_id) INNER JOIN Restaurant R ON (P.restaurant_id = R.restaurant_id) INNER JOIN Category C ON (P.category_id = C.category_id) GROUP BY P.product_id ORDER BY quantity DESC LIMIT 3;");

    for (var row in rows) {
      products.add(
        TrendingProduct(
          productID: int.parse(row.assoc()['product_id']!),
          productName: row.assoc()['product_name']!,
          restaurantID: int.parse(row.assoc()['restaurant_id']!),
          restaurantName: row.assoc()['restaurant_name']!,
          categoryName: row.assoc()['category_name']!,
          price: int.parse(row.assoc()['price']!),
          categoryID: int.parse(row.assoc()['category_id']!),
          liked: false,
        ),
      );
    }
    return products;
  }
}
