import 'package:food_delivery/mysql.dart';
import 'package:mysql_client/mysql_client.dart';

class OrderHistory {
  final int orderID;
  final String date;
  final String time;
  final String status;
  final int price;
  final String restaurantName;

  OrderHistory(
      {required this.orderID,
      required this.date,
      required this.time,
      required this.status,
      required this.price,
      required this.restaurantName});

  static Future<List<OrderHistory>> getOrderHistory(int customerID) async {
    List<OrderHistory> orders = [];
    var db = Mysql();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT O.order_id, DATE(O.placed_at) AS date, DATE_ADD(TIME(O.placed_at), INTERVAL 5 HOUR) AS time, O.status, O.price, R.name FROM Orders O INNER JOIN Restaurant R ON (O.restaurant_id = R.restaurant_id) WHERE O.customer_id=$customerID AND O.status="completed";');

    for (var row in rows) {
      orders.add(OrderHistory(
          orderID: int.parse(row.assoc()['order_id']!),
          date: row.assoc()['date']!,
          time: row.assoc()['time']!,
          status: row.assoc()['status']!,
          price: int.parse(row.assoc()['price']!),
          restaurantName: row.assoc()['name']!));
    }

    return orders;
  }
}
