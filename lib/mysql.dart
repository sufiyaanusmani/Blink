import 'package:food_delivery/components/time_selector.dart';
import 'package:mysql_client/mysql_client.dart';

class Mysql {
  static String host = 'bqquhv7hiskomx4izkti-mysql.services.clever-cloud.com';
  static String user = 'ucavnwuvwpt2fdby';
  static String password = 'V8PQZ8r0QlbmEJriBE5f';
  static String db = 'bqquhv7hiskomx4izkti';

  static int port = 3306;

  Mysql();

  Future<MySQLConnection> getConnection() async {
    return await MySQLConnection.createConnection(
      host: host,
      port: port,
      userName: user,
      password: password,
      databaseName: db,
    );
  }

  Future<Iterable<ResultSetRow>> getResults(String query) async {
    var conn = await getConnection();
    await conn.connect();
    var results = await conn.execute(query);
    conn.close();
    return results.rows;
  }

  Future<int> placeOrder(int customerID, int restaurantID, int price) async {
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn.prepare(
        'INSERT INTO Orders (customer_id, restaurant_id, price) VALUES (?, ?, ?)');
    await stmt.execute([customerID, restaurantID, price]);
    await stmt.deallocate();
    conn.close();
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT order_id, name, status, price FROM Orders INNER JOIN Restaurant ON Orders.restaurant_id=Restaurant.restaurant_id WHERE customer_id=$customerID ORDER BY placed_at DESC LIMIT 1;');
    int orderID = 0;
    if (rows.length == 1) {
      for (var row in rows) {
        orderID = int.parse(row.assoc()['order_id']!);
      }
    }
    return orderID;
  }

  Future<int> placePreOrder(int customerID, int restaurantID, int price) async {
    int orderID = await placeOrder(customerID, restaurantID, price);
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn.prepare(
        'INSERT INTO Preschedule (order_id, time) VALUES (?, CONCAT(CONCAT(CURRENT_DATE, " "), ?))');
    int hour = HomePage.preOrderHour;
    if (HomePage.preOrderText.toLowerCase().contains("pm") &&
        HomePage.preOrderHour != 12) {
      hour = hour + 12;
    } else if (HomePage.preOrderText.toLowerCase().contains("am") &&
        HomePage.preOrderHour == 12) {
      hour = 0;
    }
    String time = "$hour:${HomePage.preOrderMinute}";
    await stmt.execute([orderID, time]);
    await stmt.deallocate();
    conn.close();
    return orderID;
  }

  void addOrderDetail(int orderID, int productID, int quantity) async {
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn.prepare(
        'INSERT INTO OrderDetail (order_id, product_id, quantity) VALUES (?, ?, ?)');
    await stmt.execute([orderID, productID, quantity]);
    await stmt.deallocate();
    conn.close();
  }

  void incrementViewCount(int restaurantID) async {
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn
        .prepare('UPDATE Impressions SET views=views+1 WHERE restaurant_id=?');
    await stmt.execute([restaurantID]);
    await stmt.deallocate();
    conn.close();
  }

  Future<bool> alreadyOrdered(int customerID) async {
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Orders WHERE customer_id=$customerID AND status IN ("pending", "preparing");');
    if (rows.length == 1) {
      return true;
    } else {
      return false;
    }
  }
}
