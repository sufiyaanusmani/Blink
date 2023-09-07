import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search_screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String searchText = '';

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

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;

  SearchBarWidget({required this.onSubmitted});

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    // Handle search text changes here
    String searchText = controller.text;
    // Notify the parent widget of the search text change
    widget.onSubmitted(searchText);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.grey,
      enableInteractiveSelection: false,
      // autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        suffixIcon: GestureDetector(
          onTap: () {
            print('Search icon pressed');
          },
          child: Icon(Icons.search, color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Color.fromARGB(116, 0, 0, 0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: const Color.fromARGB(116, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
