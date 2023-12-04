import 'package:flutter/material.dart';
import 'package:food_delivery/screens/search_results.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:food_delivery/classes/UIColor.dart';

import '../classes/product.dart';
import '../components/searchbar.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText = '';

  bool showSearchResults = false;

  void onSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
  }

  bool _loading = false;
  List<Product> recentSearches = [];

  List<Product> products = [];

  void getProducts() async {
    setState(() {
      _loading = true;
    });
    List<Product> items = await Product.getAllProducts();
    setState(() {
      products = items;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    getProducts();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: ui.val(0),
        body: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: ui.val(4), size: 50)),
      );
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: ui.val(0),
    ));
    return SafeArea(
      child: Scaffold(
        backgroundColor: ui.val(0),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBarWidget(
                onSubmitted: onSearchTextChanged,
                onEntry: (text) {
                  setState(() {
                    recentSearches = [];
                  });
                  for (Product product in products) {
                    if (product.name
                        .toLowerCase()
                        .contains(text.toLowerCase())) {
                      setState(() {
                        recentSearches.add(product);
                      });
                    }
                  }
                },
                onClick: () {
                  if (recentSearches.length > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SearchResults(products: recentSearches),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Results',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: ui.val(4),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final searchItem = recentSearches[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        recentSearches = [];
                      });
                      for (Product product in products) {
                        if (product.name
                            .toLowerCase()
                            .contains(searchItem.name.toLowerCase())) {
                          setState(() {
                            recentSearches.add(product);
                          });
                        }
                      }
                      if (recentSearches.length > 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResults(products: recentSearches),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16, bottom: 18, right: 17),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: ui.val(4),
                                size: 20,
                              ),
                              SizedBox(width: 7),
                              Text(searchItem.name,
                                  style: TextStyle(
                                    color: ui.val(4),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  )),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              // Implement the delete function here
                              setState(() {
                                recentSearches.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.close_sharp,
                              color: ui.val(4),
                              // size: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
