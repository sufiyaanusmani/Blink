import 'package:food_delivery/classes/cart.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/mysql.dart';
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

  static Future<List<Product>> getProducts(
      String restaurantID, String CustomerID) async {
    List<Product> products = [];

    try {
      QuerySnapshot foodItemsSnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantID)
          .collection('foodItems')
          .get();

      for (QueryDocumentSnapshot foodItem in foodItemsSnapshot.docs) {
        Map<String, dynamic> foodItemData =
            foodItem.data() as Map<String, dynamic>;
        products.add(Product(
          id: foodItem.id,
          name: foodItemData['Prod Name'],
          restaurantID: restaurantID,
          categoryName: foodItemData['Category Name'],
          price: foodItemData['Price'],
          liked: false,
        ));
        print("asi: ${foodItemData}");
      }
      // Fetch customer document
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(CustomerID)
          .get();

      // Check if customer document exists
      if (customerSnapshot.exists) {
        // Get liked products array
        List<dynamic> likedProducts = customerSnapshot['Liked Products'];
        // Iterate through products and mark liked if found in likedProducts
        for (Product product in products) {
          if (likedProducts.contains(product.id)) {
            product.liked = true;
          }
        }
      }
    } catch (error) {
      print('Error fetching products: $error');      
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
          id: (row.assoc()['product_id']!),
          name: row.assoc()['name']!,
          restaurantID: (row.assoc()['restaurant_id']!),
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
