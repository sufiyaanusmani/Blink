import 'package:flutter/material.dart';

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
    return const Scaffold(
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
