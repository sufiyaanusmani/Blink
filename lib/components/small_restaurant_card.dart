import 'package:flutter/material.dart';

class SmallRestaurantCard extends StatelessWidget {
  final String imageID;

  SmallRestaurantCard({required this.imageID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(4.0),
        child: Container(
          padding: EdgeInsets.all(7.0),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 140,
                  height: 160,
                  child: Image.asset('images/$imageID.jpg', fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'item name',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    // SizedBox(height: 5),
                    Text(
                      'rest. name',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.all(Radius.circular(25)),
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
