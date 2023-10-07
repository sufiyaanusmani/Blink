import 'package:food_delivery/classes/product.dart';

class Category {
  int id;
  String name;
  List<Product> products = [];

  Category({required this.id, required this.name});
}
