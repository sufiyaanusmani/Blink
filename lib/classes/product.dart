import 'package:food_delivery/classes/cart.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:food_delivery/firebase_services.dart';
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
    var db = FirebaseServices();
    List<Product> products = [];
    List<Map<String, String>> restaurants = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("restaurants").get();
      for (QueryDocumentSnapshot restaurantData in querySnapshot.docs) {
        Map<String, dynamic> res =
            restaurantData.data() as Map<String, dynamic>;
        restaurants.add({
          "id": restaurantData.id.toString(),
          "name": res["name"].toString()
        });
      }
    } catch (e) {
      print(e);
    }

    try {
      for (Map<String, String> restaurant in restaurants) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("restaurants")
            .doc(restaurant["id"])
            .collection("foodItems")
            .get();
        for (QueryDocumentSnapshot foodData in querySnapshot.docs) {
          Map<String, dynamic> food = foodData.data() as Map<String, dynamic>;
          products.add(Product(
              id: foodData.id.toString(),
              name: food["Prod Name"].toString() ?? " ",
              restaurantID: restaurant["id"].toString(),
              categoryName: food["Category Name"].toString(),
              price: food["Price"] ?? 0,
              restaurantName: restaurant["name"].toString(),
              liked: false));
        }
      }
    } catch (e) {
      print(e);
    }
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

    return products;
  }
}
