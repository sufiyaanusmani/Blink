import 'package:food_delivery/mysql.dart';

import 'package:mysql_client/mysql_client.dart';

class Restaurant {
  String restaurantID;
  String name;
  String ownerName;
  String image = '';

  Restaurant(
      {required this.restaurantID,
      required this.name,
      required this.ownerName});

  static Future<List<Restaurant>> getRestaurants() async {
    var db = Mysql();
    List<Restaurant> restaurants = [];
    Iterable<ResultSetRow> rows = await db
        .getResults('SELECT restaurant_id, name, owner_name FROM Restaurant;');

    for (var row in rows) {
      // firstName = row.assoc()['first_name']!;
      Restaurant restaurant = Restaurant(
          restaurantID: "1",
          name: row.assoc()['name']!,
          ownerName: row.assoc()['owner_name']!);
      restaurants.add(restaurant);
    }

    return restaurants;
  }
}
