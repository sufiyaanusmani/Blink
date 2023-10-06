import 'package:flutter/material.dart';

import '../components/searchbar.dart';
import 'RestrauntHelperfiles/model/product_category.dart';


class SearchResults extends StatefulWidget {
  static const String id = 'search_screen';

  @override
  State<SearchResults> createState() => _SearchResultsState();
}



  List<Product2> dummyProducts = [
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: 'images/mac.jpg',
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
  ];

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(onSubmitted: onSearchTextChanged),
            ),
            Expanded(child: SearchList(listItem: dummyProducts)),
          ],
        ),
      ),
    );
  }
}

class SearchList extends StatelessWidget {
  const SearchList({Key? key, required this.listItem}) : super(key: key);

  final List<Product2> listItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listItem.length, // Specify the number of items
      itemBuilder: (context, index) {
        final product = listItem[index];
        return InkWell(
          onTap: () {
            print("Item ${index} added to cart");
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                maxLines: 4,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.price,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
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
                              product.image,
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


