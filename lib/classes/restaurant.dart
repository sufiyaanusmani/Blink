import 'package:cloud_firestore/cloud_firestore.dart';

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
    List<Restaurant> restaurants = [];
    try {
      Query<Map<String, dynamic>> restaurantsQuery =
          FirebaseFirestore.instance.collection('restaurants');
      QuerySnapshot restaurantsSnapshot = await restaurantsQuery.get();
      for (QueryDocumentSnapshot restaurant in restaurantsSnapshot.docs) {
        Map<String, dynamic> restaurantData =
            restaurant.data() as Map<String, dynamic>;
        restaurants.add(Restaurant(
            restaurantID: restaurant.id,
            name: restaurantData['name'],
            ownerName: restaurantData['ownername']));
      }
    } catch (e) {
      print(e);
    }
    return restaurants;
  }
}
