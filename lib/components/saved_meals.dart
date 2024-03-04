import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';
import 'package:food_delivery/classes/cart.dart';
import 'package:food_delivery/firebase_services.dart';
import 'dart:math';
import '../../classes/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SavedMealsScreen extends StatefulWidget {
  const SavedMealsScreen({super.key});

  @override
  _SavedMealsScreenState createState() => _SavedMealsScreenState();
}

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

String getRandomImageName() {
  Random random = Random();
  int index = random.nextInt(imageNames.length);
  return imageNames[index];
}

List<String> imageNames = [
  'yellow.jpg',
  'blue.jpg',
  'green.jpg',
  'bleen.jpg',
  'purple.jpg'
];

late List<Product> LikeProducts = [];
bool _loading = false;

class _SavedMealsScreenState extends State<SavedMealsScreen> {
  @override
  void initState() {
    getLikedProducts();

    super.initState();
  }

  Future<void> getLikedProducts() async {
    setState(() {
      _loading = true;
    });

    List<Product> likedProducts = [];

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      // Retrieve the document reference for the customer
      DocumentSnapshot customerSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user!.uid)
          .get();

      // Check if customer document exists and convert data to a Map
      Map<String, dynamic>? customerData =
          customerSnapshot.data() as Map<String, dynamic>?;

      // If customerData is not null and contains the 'Liked Products' key
      if (customerData != null && customerData.containsKey('Liked Products')) {
        // Get the Liked Products array
        List<dynamic> likedProductsData = customerData['Liked Products'];
        print("eee: ${likedProductsData}");

        // Convert the Liked Products array into a list of Product objects
        for (Map<String, dynamic> productData in likedProductsData) {
          Product product = Product(
            id: productData['Product ID'],
            name: productData['Prod Name'],
            restaurantID: productData['Restaurant ID'],
            restaurantName: productData['Restaurant Name'],
            categoryName: productData['Category Name'],
            price: productData['Price'],
            liked: true,
          );
          likedProducts.add(product);
        }
      }
      print("Liked products fetched");
    } catch (error) {
      print('Error fetching liked products: $error');
    }

    LikeProducts = likedProducts;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading)
      return Center(
          child: CircularProgressIndicator(
        color: Colors.white60,
        strokeWidth: 2,
      ));
    else {
      return Scaffold(
        backgroundColor: ui.val(0),
        body: ListView.builder(
          itemCount: LikeProducts.length,
          itemBuilder: (context, index) {
            final product = LikeProducts[index];
            return Container(
              color: ui.val(0),
              child: InkWell(
                onTap: () {
                  if (Cart.cart.length == 0) {
                    Cart.addNewProduct(product);
                    snackbar('${product.name} added to cart', context, false);
                  } else if (Cart.cart.length > 0) {
                    if (Cart.cart[0].product.restaurantID ==
                        product.restaurantID) {
                      Cart.addNewProduct(product);
                      snackbar('${product.name} added to cart', context, false);
                    } else {
                      if (Cart.cart[0].product.restaurantID !=
                          product.restaurantID) {
                        snackbar(
                            'Cannot add products from different restaurant',
                            context,
                            true);
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
                                      product.restaurantName,
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
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //     color: Colors.grey.withOpacity(
                                      //         0.5), // Color of the shadow
                                      //     spreadRadius: 5, // Spread radius
                                      //     blurRadius: 7, // Blur radius
                                      //     offset: Offset(
                                      //         0, 3), // Offset of the shadow
                                      //   ),
                                      // ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        var db = FirebaseServices();
                                        db.dislikeProduct(product);
                                        // remove this product here
                                        setState(() {
                                          LikeProducts.removeAt(index);
                                        });
                                      },
                                      child: product.liked == true
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_outline,
                                              color: ui.val(1),
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      if (index == LikeProducts.length - 1) ...[
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
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
