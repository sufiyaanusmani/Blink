import 'package:food_delivery/classes/cart.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/mysql.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Product {
  String id;
  String name;
  String restaurantID;
  String restaurantName;
  String categoryName;
  int price;
  bool liked;

  Product(
      {required this.id,
      required this.name,
      required this.restaurantID,
      required this.categoryName,
      required this.price,
      required this.restaurantName,
      required this.liked});

  static Future<List<Product>> getProducts(Restaurant restaurant) async {
    List<Product> products = [];

    try {
      QuerySnapshot foodItemsSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurant.restaurantID)
          .collection('foodItems')
          .get();

      for (QueryDocumentSnapshot foodItem in foodItemsSnapshot.docs) {
        Map<String, dynamic> foodItemData =
            foodItem.data() as Map<String, dynamic>;
        products.add(Product(
          id: foodItem.id,
          name: foodItemData['Prod Name'] ?? " ",
          restaurantID: restaurant.restaurantID,
          restaurantName: restaurant.name,
          categoryName: foodItemData['Category Name'] ?? " ",
          price: foodItemData['Price'] ?? 0,          
          liked: false,
        ));
      }

      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      // Fetch customer document
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user!.uid)
          .get();
      // Check if customer document exists
      if (customerSnapshot.exists) {
        // Get liked products array
        List<dynamic> likedProducts = customerSnapshot['Liked Products'];

        // print("cust: $likedProducts");
        // Iterate through products and mark liked if found in likedProducts
        for (Product product in products) {
          // Iterate through likedProducts to check if the product is liked
          for (Map<String, dynamic> likedProduct in likedProducts) {
            // Extract the product ID from the liked product map
            dynamic likedProductId = likedProduct['Product ID'];

            // Check if the product ID matches the current product's ID
            if (likedProductId.toString() == product.id) {
              // Ensure likedProductId is converted to string
              product.liked = true;
              // print("Liked: ${product}");
              break; // Exit the inner loop since the product is already marked as liked
            }
          }
        }
      }
    } catch (error) {
      print('Error fetching products from getProducts(): $error');
      print(products);
    }

    return products;
  }

  static Future<List<Product>> getAllProducts() async {
    var db = Mysql();
    List<Product> products = [];
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT P.product_id, P.name, P.restaurant_id, P.category_id, P.price, C.name AS category_name FROM Product P INNER JOIN Category C ON P.category_id = C.category_id;');

    // for (var row in rows) {
    //   // firstName = row.assoc()['first_name']!;
    //   Product product = Product(
    //       id: (row.assoc()['product_id']!),
    //       name: row.assoc()['name']!,
    //       restaurantID: (row.assoc()['restaurant_id']!),
    //       categoryName: row.assoc()['category_name']!,
    //       price: int.parse(row.assoc()['price']!),
    //       liked: false);
    //   products.add(product);
    // }

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
