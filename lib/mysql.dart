import 'package:food_delivery/classes/product.dart';
import 'package:food_delivery/components/time_selector.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    await conn.transactional((conn) async {
      await conn.execute(
          "INSERT INTO Orders (customer_id, restaurant_id, price) VALUES ($customerID, $restaurantID, $price);");
    });

    // var stmt = await conn.prepare(
    //     'START TRANSACTION;COMMIT;');
    // await stmt.execute([customerID, restaurantID, price]);
    // await stmt.deallocate();
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

  void addOrderDetail(int orderID, String productID, int quantity) async {
    var conn = await getConnection();
    await conn.connect();
    var stmt = await conn.prepare(
        'INSERT INTO OrderDetail (order_id, product_id, quantity) VALUES (?, ?, ?)');
    await stmt.execute([orderID, productID, quantity]);
    await stmt.deallocate();
    conn.close();
  }

  void incrementViewCount(String restaurantID) {
    try {
      // Reference to the specific restaurant document using the provided ID
      DocumentReference restaurantDocumentRef = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID);
      // Increment the "views" field by 1
      restaurantDocumentRef.update({
        'views': FieldValue.increment(1),
      });
    } catch (error) {
      print('Error incrementing view count: $error');
    }
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

  Future<int> createNewAccount(String firstName, String lastName, String email,
      String username, String password) async {
    int customerID = -1;
    var db = Mysql();
    var conn = await getConnection();
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT * FROM Customer WHERE email="$email" OR username="$username";');
    if (rows.length > 0) {
      return -1;
    }
    conn = await getConnection();
    await conn.connect();
    await conn.transactional((conn) async {
      await conn.execute(
          'INSERT INTO Account (username, password) VALUES ("$username", "$password");');
      await conn.execute(
          'INSERT INTO Customer (first_name, last_name, email, username) VALUES ("$firstName", "$lastName", "$email", "$username");');
    });
    conn.close();
    rows = await db.getResults(
        'SELECT customer_id FROM Customer WHERE first_name="$firstName" AND last_name="$lastName" AND email="$email"S AND username=$username;');

    if (rows.length == 1) {
      for (var row in rows) {
        customerID = int.parse(row.assoc()['customer_id']!);
      }
    }
    return customerID;
  }

  void likeProduct(Product product) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // print('User is signed in with email: ${user!.email}');

    print("aaa: ${user!.uid}");
    try {
      // Step 1: Retrieve the document reference for the customer
      DocumentReference customerDocRef =
          FirebaseFirestore.instance.collection('customers').doc(user!.uid);

      // Step 2: Get the existing array of liked products, if any
      DocumentSnapshot customerSnapshot = await customerDocRef.get();
      // Step 2: Get the existing array of liked products, if any
      Map<String, dynamic>? data = customerSnapshot.data()
          as Map<String, dynamic>?; // Explicit cast to handle potential null
      List<dynamic> likedProducts =
          data?['Liked Products'] ?? []; // Null check and fallback value

      // Step 3: Append the new liked product to the array
      Map<String, dynamic> likedProduct = {
        'Category Name': product.categoryName,
        'Price': product.price,
        'Product ID': product.id,
        'Prod Name': product.name,        
        'Restaurant ID': product.restaurantID
      };
      likedProducts.add(likedProduct);

      // Step 4: Update the document with the updated liked products array
      await customerDocRef.update({'Liked Products': likedProducts});

      print('Liked product added successfully.');
    } catch (error) {
      print('Error adding liked product: $error');
    }
  }

  Future<void> dislikeProduct(Product product) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    try {
      // Step 1: Retrieve the document reference for the customer
      DocumentReference customerDocRef =
          FirebaseFirestore.instance.collection('customers').doc(user!.uid);

      // Step 2: Get the existing array of liked products, if any
      DocumentSnapshot customerSnapshot = await customerDocRef.get();
      Map<String, dynamic>? data = customerSnapshot.data()
          as Map<String, dynamic>?; // Explicit cast to handle potential null
      List<dynamic> likedProducts =
          data?['Liked Products'] ?? []; // Null check and fallback value

      // Step 3: Remove the specified product from the array
      likedProducts.removeWhere((likedProduct) =>
          likedProduct['Product ID'] == product.id &&
          likedProduct['Restaurant ID'] == product.restaurantID);

      // Step 4: Update the document with the updated liked products array
      await customerDocRef.update({'Liked Products': likedProducts});

      print('Disliked product removed successfully.');
    } catch (error) {
      print('Error removing disliked product: $error');
    }
  }
}
