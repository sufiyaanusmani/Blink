import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/classes/product.dart';

import '../classes/cart.dart';

import 'package:food_delivery/classes/UIColor.dart';

class SmallRestaurantCard extends StatelessWidget {
  final String imageID;
  final String itemName;
  final String restaurantName;
  final String productID;
  final String restaurantID;
  final int categoryID;
  final String categoryName;
  final int price;
  final bool liked;

  const SmallRestaurantCard(
      {super.key,
      required this.imageID,
      required this.itemName,
      required this.restaurantName,
      required this.productID,
      required this.restaurantID,
      required this.categoryID,
      required this.price,
      required this.categoryName,
      required this.liked});

  void snackbar(String content, BuildContext context, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor:
            error == true ? Colors.red.shade400 : Colors.blue.shade800,
        duration: Duration(seconds: 1),
        content: Text(content, style: TextStyle(color: Colors.white)),
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.white,
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(2.0),
        child: Container(
          // padding: EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            color: ui.val(1),
            borderRadius: const BorderRadius.all(Radius.circular(25)),
          ),
          // padding: EdgeInsets.all(7.0),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    width: 140,
                    height: 150,
                    child:
                        Image.asset('images/$imageID.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      itemName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    Text(
                      'Rs. $price',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (Cart.cart.isEmpty) {
          Cart.addNewProduct(Product(
              id: productID,
              name: itemName,
              restaurantName: restaurantName,
              restaurantID: restaurantID.toString(),
              categoryName: categoryName,
              price: price,
              liked: liked));

          snackbar('$itemName added to cart', context, false);
        } else if (Cart.cart.isNotEmpty) {
          if (Cart.cart[0].product.restaurantID == restaurantID) {
            Cart.addNewProduct(Product(
                id: productID,
                name: itemName,
                restaurantID: restaurantID.toString(),
                restaurantName: restaurantName,
                categoryName: categoryName,
                price: price,
                liked: liked));
            snackbar('$itemName added to cart', context, false);
          } else {
            if (Cart.cart[0].product.restaurantID != restaurantID) {
              snackbar('Cannot add products from different restaurant', context,
                  true);
            }
          }
        }
      },
    );
  }
}
