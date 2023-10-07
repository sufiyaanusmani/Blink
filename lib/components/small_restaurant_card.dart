import 'package:flutter/material.dart';

class SmallRestaurantCard extends StatelessWidget {
  final String imageID;
  final String itemName;
  final String itemDesc;

  SmallRestaurantCard({
    required this.imageID,
    required this.itemName,
    required this.itemDesc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.all(2.0),
        child: Container(
          // padding: EdgeInsets.all(7.0),
          child: Column(    
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                child: Opacity(
                  opacity: 0.8,
                  child: SizedBox(
                    width: 140,
                    height: 160,
                    child:
                        Image.asset('images/$imageID.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  textDirection: TextDirection.rtl,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      itemName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      itemDesc,
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
