import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSubmitted;
  final Function(String text) onEntry;
  final VoidCallback onClick;

  const SearchBarWidget(
      {super.key,
      required this.onSubmitted,
      required this.onEntry,
      required this.onClick});

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
      cursorColor: ui.val(4),
      enableInteractiveSelection: false,
      style: TextStyle(
        fontSize: 20,
        color: ui.val(4),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(left: 10),
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: GestureDetector(
          onTap: widget.onClick,
          //     () {
          //   print('Search icon pressed');
          //   // Navigator.of(context).pushReplacement(
          //   //     MaterialPageRoute(builder: (context) => SearchResults()));
          //   // FocusScope.of(context).unfocus();
          // },
          child: const Icon(Icons.search, color: Colors.grey, size: 30),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ui.val(4),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ui.val(4),
          ),
        ),
      ),
      onChanged: widget.onEntry,
    );
  }
}
