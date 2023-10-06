import 'package:flutter/material.dart';
import 'package:food_delivery/screens/search_results.dart';

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
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Recent Search',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentSearches.length,
                itemBuilder: (context, index) {
                  final searchItem = recentSearches[index];
                  return Container(
                    padding: EdgeInsets.only(left: 16, bottom: 18, right: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.grey,
                              size: 20,
                            ),
                            SizedBox(width: 7),
                            Text(searchItem,
                                style: TextStyle(
                                  color: Colors.black,
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
                            color: Colors.grey,
                            // size: 17,
                          ),
                        ),
                      ],
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


