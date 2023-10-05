import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/mysql.dart';

class Product {
  int id;
  String name;
  int restraunt_id;
  int category_id;
  int price;

  Product(
      {required this.id,
      required this.name,
      required this.restraunt_id,
      required this.category_id,
      required this.price});

  static Future<List<Product>> getProducts(int restaurantID) async {
    var db = Mysql();
    List<Product> products = [];
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT * FROM Product INNER JOIN Category ON Product.category_id = Category.category_id WHERE restaurant_id=$restaurantID;');

    for (var row in rows) {
      // firstName = row.assoc()['first_name']!;
      Product product = Product(
          id: int.parse(row.assoc()['product_id']!),
          name: row.assoc()['name']!,
          restraunt_id: int.parse(row.assoc()['restaurant_id']!),
          category_id: int.parse(row.assoc()['category_id']!),
          price: int.parse(row.assoc()['price']!));
      products.add(product);
      print(int.parse(row.assoc()['category_id']!));
    }

    return products;
  }
}
