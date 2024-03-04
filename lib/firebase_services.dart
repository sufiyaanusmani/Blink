import 'package:flutter/foundation.dart';
import 'package:food_delivery/classes/cart_product.dart';
import 'package:food_delivery/classes/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Provides various firebase services
///
/// It consists of various methods to interact with Firebase
///
/// Example:
/// ```dart
/// // Usage example of the class.
/// FirebaseServices db = FirebaseServices();
/// ```
class FirebaseServices {
  /// Places Customer's order
  ///
  /// Parameters:
  ///   - foodItems: List<CartProduct>
  ///   - restaurantID: String
  ///   - restaurantName: String
  ///   - price: int
  ///
  /// Returns:
  ///   returns this new order's ID of the type: Future<[String]>
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// db.placeOrder(foodItems, restaurantID, restaurantName, price);
  /// ```
  Future<String> placeOrder(List<CartProduct> foodItems, String restaurantID,
      String restaurantName, int price) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Reference to the orders collection
      CollectionReference orders =
          FirebaseFirestore.instance.collection('orders');

      // Convert the list of CartProduct objects into a list of maps
      List<Map<String, dynamic>> foodItemsData = foodItems.map((cartProduct) {
        return {
          cartProduct.product.name: {
            'id': cartProduct.product.id,
            'Price': cartProduct.product.price,
            'Quantity': cartProduct.quantity,
          }
        };
      }).toList();

      // Create a new document in the orders collection and get its reference
      DocumentReference newOrderRef = await orders.add({
        'customerid': uid!,
        'Food items': foodItemsData,
        'preorder': {
          'ispreorder': false,
          'time': DateTime.now(),
        },
        'placedat': DateTime.now(),
        'price': price,
        'restaurant': {
          'name': restaurantName,
          'restaurantid': restaurantID,
        },
        'status': 'pending',
      });

      if (kDebugMode) {
        print('Order added successfully');
      }
      DocumentReference customerDocRef =
          FirebaseFirestore.instance.collection('customers').doc(uid);
      await customerDocRef.update({'Placed Order': true});

      // Return the ID of the newly added order document
      return newOrderRef.id;
    } catch (error) {
      if (kDebugMode) {
        print('Error adding order: $error');
      }
      // Handle the error as needed
      return ''; // Return an empty string if there's an error
    }
  }

  /// Increments view count of the restaurant whenever user clicks on resaturant's card in homescreen
  ///
  /// Parameters:
  ///   - restaurantID: String
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// db.incrementViewCount(restaurantID);
  /// ```
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
      if (kDebugMode) {
        print('Error incrementing view count: $error');
      }
    }
  }

  /// It checks whether the user has already placed an order which is pending
  ///
  /// User can only place one order at a time. If his/her order's status is `pending`, he/she can't place another
  /// order until this order is cancelled or completed
  ///
  /// Returns:
  ///   Future<[bool]>
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// db.alreadyOrdered();
  /// ```
  Future<bool> alreadyOrdered() async {
    // Step 1: Get the current user's UID
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      try {
        // Step 2: Retrieve the customer document using the UID
        DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
            .collection('customers')
            .doc(uid)
            .get();

        // Step 3: Access the "Placed Order" field from the customer document
        bool placedOrder = customerSnapshot.get('Placed Order');

        return placedOrder;
      } catch (error) {
        if (kDebugMode) {
          print('Error retrieving customer document: $error');
        }
        // Handle the error as needed
        return false;
      }
    } else {
      // User is not authenticated
      if (kDebugMode) {
        print('User is not authenticated.');
      }
      return false;
    }
  }

  /// Likes a product
  ///
  /// Parameters:
  ///   - product: Product
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// db.likeProduct(product);
  /// ```
  void likeProduct(Product product) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    // print('User is signed in with email: ${user!.email}');
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
        'Restaurant ID': product.restaurantID,
        'Restaurant Name': product.restaurantName
      };
      likedProducts.add(likedProduct);

      // Step 4: Update the document with the updated liked products array
      await customerDocRef.update({'Liked Products': likedProducts});

      if (kDebugMode) {
        print('Liked product added successfully.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error adding liked product: $error');
      }
    }
  }

  /// Dislikes a product
  ///
  /// Parameters:
  ///   - product: Product
  ///
  /// Example:
  /// ```dart
  /// // Usage example of the function.
  /// db.dislikeProduct(product);
  /// ```
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

      if (kDebugMode) {
        print('Disliked product removed successfully.');
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error removing disliked product: $error');
      }
    }
  }
}
