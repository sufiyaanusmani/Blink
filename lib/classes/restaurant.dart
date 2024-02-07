import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant {
  String restaurantID;
  String name;
  String ownerName;
  String image = '';
  String rating;
  String totalRatings;
  String estimatedTime;
  String description;

  Restaurant(
      {required this.restaurantID,
      required this.name,
      required this.ownerName,
      required this.rating,
      required this.totalRatings,
      required this.description,
      required this.estimatedTime});

  static Future<List<Restaurant>> getRestaurants() async {
    List<Restaurant> restaurants = [];
    try {
      Query<Map<String, dynamic>> restaurantsQuery =
          FirebaseFirestore.instance.collection('restaurants');
      QuerySnapshot restaurantsSnapshot = await restaurantsQuery.get();
      for (QueryDocumentSnapshot restaurant in restaurantsSnapshot.docs) {
        Map<String, dynamic> restaurantData =
            restaurant.data() as Map<String, dynamic>;

        Map<String, dynamic> reviewData = restaurantData['Review'];
        int ratingCount = (reviewData['Rating Count'] ?? 0).toInt();
        double stars = (reviewData['Stars'] ?? 0.0).toDouble();

        restaurants.add(Restaurant(
          restaurantID: restaurant.id,
          name: restaurantData['name'],
          ownerName: restaurantData['ownername'],
          description: restaurantData['Description'],
          rating: stars.toString(),
          totalRatings: ratingCount.toString(),
          estimatedTime: restaurantData['Estimated Time'].toString() + " mins",
        ));
      }
    } catch (e) {
      print(e);
    }
    return restaurants;
  }
}
