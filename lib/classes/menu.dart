import 'package:food_delivery/classes/product.dart';


// a re-implementaion of restraunt.dart
// this class is wes never used

class menu {
  int rating;
  String restraunt_name;
  String description;
  int time;
  List<product> products;



  menu(
    {
      required this.rating,
      required this.restraunt_name,
      required this.description,
      required this.time,
      required this.products
    });
}
