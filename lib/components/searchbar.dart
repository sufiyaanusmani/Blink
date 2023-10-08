import 'package:flutter/material.dart';

import '../screens/search_results.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final Function(String text) onEntry;

  SearchBarWidget({required this.onSubmitted, required this.onEntry});

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
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search...',
        suffixIcon: GestureDetector(
          onTap: () {
            print('Search icon pressed');
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SearchResults()));
            FocusScope.of(context).unfocus();
          },
          child: const Icon(Icons.search, color: Colors.grey, size: 30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(116, 0, 0, 0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(116, 0, 0, 0),
          ),
        ),
      ),
      onChanged: widget.onEntry,
    );
  }
}
