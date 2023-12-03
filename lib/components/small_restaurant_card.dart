import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/classes/product.dart';

import '../classes/cart.dart';

class SmallRestaurantCard extends StatelessWidget {
  final String imageID;
  final String itemName;
  final String restaurantName;
  final int productID;
  final int restaurantID;
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: Container(
          // padding: EdgeInsets.all(7.0),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    width: 140,
                    height: 160,
                    child:
                        Image.asset('images/$imageID.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
      onTap: () {
        if (Cart.cart.length == 0) {
          Cart.addNewProduct(Product(
              id: productID,
              name: itemName,
              restraunt_id: restaurantID,
              category_id: categoryID,
              category_name: categoryName,
              price: price,
              liked: liked));
          AnimatedSnackBar.material(
            '${itemName} added to cart',
            borderRadius: BorderRadius.circular(10),
            duration: Duration(seconds: 4),
            type: AnimatedSnackBarType.success,
            mobileSnackBarPosition: MobileSnackBarPosition.bottom,
          ).show(context);
        } else if (Cart.cart.length > 0) {
          if (Cart.cart[0].product.restraunt_id == restaurantID) {
            Cart.addNewProduct(Product(
                id: productID,
                name: itemName,
                restraunt_id: restaurantID,
                category_id: categoryID,
                category_name: categoryName,
                price: price,
                liked: liked));
            AnimatedSnackBar.material(
              '${itemName} added to cart',
              borderRadius: BorderRadius.circular(10),
              duration: Duration(seconds: 4),
              type: AnimatedSnackBarType.success,
              mobileSnackBarPosition: MobileSnackBarPosition.bottom,
            ).show(context);
          } else {
            if (Cart.cart[0].product.restraunt_id != restaurantID) {
              AnimatedSnackBar.material(
                'Cannot add products from different restaurant',
                borderRadius: BorderRadius.circular(10),
                duration: Duration(seconds: 4),
                type: AnimatedSnackBarType.error,
                mobileSnackBarPosition: MobileSnackBarPosition.bottom,
              ).show(context);
            }
          }
        }

        print('pressed $productID');
      },
    );
  }
}
