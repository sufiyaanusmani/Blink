import 'package:flutter/material.dart';
import 'package:food_delivery/classes/UIColor.dart';

class SavedMealsScreen extends StatefulWidget {
  const SavedMealsScreen({super.key});

  @override
  _SavedMealsScreenState createState() => _SavedMealsScreenState();
}

class _SavedMealsScreenState extends State<SavedMealsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui.val(0),
      body: Center(
        child: Text('Hello, Saved Meals!'),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
