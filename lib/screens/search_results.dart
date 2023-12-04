import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

import '../classes/cart.dart';
import '../classes/product.dart';

class SearchResults extends StatefulWidget {
  static const String id = 'search_screen';
  late List<Product> products = [];

  SearchResults({required this.products});
  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late String searchText = '';

  bool showSearchResults = false;

  void onSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
  }

  List<String> recentSearches = [
    'Pizza',
    'Burger',
    'Roll',
    'Biryani',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ui.val(0),
        body: Column(
          children: [
            Expanded(child: SearchList(listItem: widget.products)),
          ],
        ),
      ),
    );
  }
}

class SearchList extends StatelessWidget {
  const SearchList({Key? key, required this.listItem}) : super(key: key);

  final List<Product> listItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItem.length, // Specify the number of items
      itemBuilder: (context, index) {
        final product = listItem[index];
        return InkWell(
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
              if (Cart.cart[0].product.restaurantID == product.restaurantID) {
                Cart.addNewProduct(product);
                AnimatedSnackBar.material(
                  '${product.name} added to cart',
                  borderRadius: BorderRadius.circular(10),
                  duration: Duration(seconds: 4),
                  type: AnimatedSnackBarType.success,
                  mobileSnackBarPosition: MobileSnackBarPosition.bottom,
                ).show(context);
              } else {
                if (Cart.cart[0].product.restaurantID != product.restaurantID) {
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
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Divider(),
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
                                  color: ui.val(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.categoryName,
                                maxLines: 4,
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: ui.val(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Rs. ${product.price}",
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "images/kfc.jpg",
                            ),
                          ),
                        ),
                        height: 140,
                        width: 130,
                      )
                    ],
                  ),
                ),
                if (index == listItem.length - 1) ...[
                  const SizedBox(height: 32),
                  Container(
                    height: .5,
                    color: Colors.white.withOpacity(.3),
                  ),
                ],
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
