import 'package:flutter/material.dart';
import 'hours.dart';
import 'minutes.dart';
import 'tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = FixedExtentScrollController();
  }

   final List<int> selectedHours = [08, 09, 10, 11, 12, 01, 02, 03, 04];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 33, 33, 33),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromARGB(62, 0, 0, 0), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        // padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              width: 5,
            ),


            // hours wheel
            Container(
              width: MediaQuery.of(context).size.width*0.15,
              child: ListWheelScrollView.useDelegate(
                controller: _controller,
                itemExtent: 50,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 9,
                  builder: (context, index) {
                    return MyHours(
                      hours: selectedHours[index],
                    );
                  },
                ),
              ),
            ),

            SizedBox(
              width: 5,
            ),

            // minutes wheel
            Container(
              width: MediaQuery.of(context).size.width*0.15,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                perspective: 0.005,
                diameterRatio: 1.2,
                physics: FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: 60,
                  builder: (context, index) {
                    return MyMinutes(
                      mins: index,
                    );
                  },
                ),
              ),
            ),

            SizedBox(
              width: 5,
            ),

          ],
        ),
      ),
    );
  }
}