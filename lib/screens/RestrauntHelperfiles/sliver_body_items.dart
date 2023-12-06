import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/classes/cart.dart';

import '../../classes/product.dart';
import 'package:food_delivery/classes/UIColor.dart';
import 'dart:math';
// class ProductCategory {
//   ProductCategory({
//     required this.category,
//     required this.products,
//   });

//   final String category;
//   final List<Product2> products;
// }

// class Product2 {
//   final String name;
//   final String description;
//   final String price;
//   final String image;

//   Product2({
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image,
//   });
// }

class SliverBodyItems extends StatefulWidget {
  const SliverBodyItems(
      {Key? key, required this.listItem, required this.customerID})
      : super(key: key);

  final List<Product> listItem;
  final int customerID;

  @override
  State<SliverBodyItems> createState() => _SliverBodyItemsState();
}

class _SliverBodyItemsState extends State<SliverBodyItems> {
  List<String> imageNames = [
    'yellow.jpg',
    'blue.jpg',
    'green.jpg',
    'bleen.jpg',
    'purple.jpg'
  ];

  String getRandomImageName() {
    Random random = Random();
    int index = random.nextInt(imageNames.length);
    return imageNames[index];
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = widget.listItem[index];
          return Container(
            color: ui.val(1),
            child: InkWell(
              onTap: () {
                if (Cart.cart.length == 0) {
                  Cart.addNewProduct(product);
                  AnimatedSnackBar.material(
                    '${product.name} added to cart',
                    borderRadius: BorderRadius.circular(10),
                    duration: Duration(seconds: 4),
                    type: AnimatedSnackBarType.success,
                    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                  ).show(context);
                } else if (Cart.cart.length > 0) {
                  if (Cart.cart[0].product.restaurantID ==
                      product.restaurantID) {
                    Cart.addNewProduct(product);
                    AnimatedSnackBar.material(
                      '${product.name} added to cart',
                      borderRadius: BorderRadius.circular(10),
                      duration: Duration(seconds: 4),
                      type: AnimatedSnackBarType.success,
                      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                    ).show(context);
                  } else {
                    if (Cart.cart[0].product.restaurantID !=
                        product.restaurantID) {
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

                print('pressed ${product.name}');
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Column(
                  children: [
                    Divider(color: ui.val(4).withOpacity(0.1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "this is a description",
                                    maxLines: 4,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: ui.val(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Rs ${product.price}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: ui.val(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "images/${getRandomImageName()}",
                                    ),
                                  ),
                                ),
                                height: 140,
                                width: 130,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  margin: EdgeInsets.only(top: 5, right: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(171, 255, 255, 255),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(
                                            0.5), // Color of the shadow
                                        spreadRadius: 5, // Spread radius
                                        blurRadius: 7, // Blur radius
                                        offset: Offset(
                                            0, 3), // Offset of the shadow
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      var db = Mysql();
                                      if (product.liked == false) {
                                        setState(() {
                                          product.liked = true;
                                        });
                                        db.likeProduct(
                                            widget.customerID, product.id);
                                      } else {
                                        setState(() {
                                          product.liked = false;
                                        });
                                        db.dislikeProduct(
                                            widget.customerID, product.id);
                                      }
                                    },
                                    child: product.liked == true
                                        ? Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : Icon(
                                            Icons.favorite_outline,
                                            color: Colors.black,
                                          ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (index == widget.listItem.length - 1) ...[
                      const SizedBox(height: 32),
                      Container(
                        height: .5,
                        // color: Colors.white.withOpacity(.3),
                      ),
                    ],
                    Divider(color: ui.val(4).withOpacity(0.1)),
                  ],
                ),
              ),
            ),
          );
        },
        childCount: widget.listItem.length,
      ),
    );
  }
}
