import 'package:flutter/material.dart';


class SmallRestaurantCard extends StatelessWidget {
  final String imageID;

  SmallRestaurantCard({required this.imageID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox.fromSize(
            size: Size.fromRadius(90), // Image radius
            child: Image.asset('images/$imageID.jpg', fit: BoxFit.cover),
          ),
        ),
      ),
      onTap: () {
        print('Pressed $imageID');
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => RestaurantScreen()));
        // print("aa");
      },
    );
  }
}
