import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:slide_to_act_reborn/slide_to_act_reborn.dart';
import 'package:food_delivery/components/time_selector.dart';


class CartScreen extends StatefulWidget {
  static const String id = 'cart_screen';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Color pill_B_Bg = Colors.white;
  Color pill_A_Bg = Colors.black;
  Color pill_B_Txt = Colors.black;
  Color pill_A_Txt = Colors.white;

  void onTapCart() {
    setState(() {
      pill_B_Bg = Colors.white;
      pill_A_Bg = Colors.black;
      pill_B_Txt = Colors.black;
      pill_A_Txt = Colors.white;
    });
  }

  void onTapSaved() {
    setState(() {
      pill_B_Bg = Colors.black;
      pill_A_Bg = Colors.white;
      pill_B_Txt = Colors.white;
      pill_A_Txt = Colors.black;
    });
  }

  final itemList = [
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Chicken mayo boti roll',
      'desc': 'priaaa',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'biryani',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 3',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 1',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 2',
      'desc': 'price',
    },
    {
      'image': 'assets/icons/cancel.png',
      'title': 'Item 3',
      'desc': 'price',
    }
  ];

  double translateX = 0.0;
  double translateY = 0.0;
  double myWidth = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    print('yes');
                  },
                  child: Image.asset(
                    'assets/icons/save.png',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 70,
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: pill_A_Bg,
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        width: 2.0,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          'Your cart',
                          style: TextStyle(color: pill_A_Txt),
                        ),
                        onTap: onTapCart,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: pill_B_Bg,
                      border: Border.all(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          'Saved',
                          style: TextStyle(color: pill_B_Txt),
                        ),
                        onTap: onTapSaved,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  final item = itemList[index];
                  return Padding(
                    padding: (index == 0)
                        ? const EdgeInsets.symmetric(vertical: 15.0)
                        : const EdgeInsets.only(bottom: 15.0),
                    child: Slidable(
                      key: Key('$item'),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              setState(() {
                                itemList.removeAt(index);
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 1.0,
                                spreadRadius: 1.0,
                                color: Colors.grey[400]!),
                          ],
                        ),


                        // ListView row
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.asset(
                                item['image']!,
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(
                                    item['desc']!,
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children:[
                                TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 50,
                                    child: Text(
                                      '-',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    ' 3 ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 20,
                                    height: 50,
                                    child: Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),



            // preorder

            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                    flex: 4,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 64, 140, 255),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              
                                  Container(
                                      margin: EdgeInsets.only(top:15, left:15),
                                      padding:EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromARGB(136, 255, 255, 255), // Adjust color as needed
                                      ),
                                      child: Image.asset(
                                        'assets/icons/preorder.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                  
                                
                                  ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(right:15),
                                  padding: EdgeInsets.only(bottom:5),
                                  child:Text(
                                    'Preorder',
                                    style: TextStyle(                                      
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          TextButton(
                             onPressed: () {
                                _showTimeSelectionPopup();
                              },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left:4, right:4),
                              height: 30,
                              child: Text(
                                '11:00 am',
                                style: TextStyle(
                                  color: Colors.white,
                                  
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 10,
                ),



                // Amount
                Expanded(
                    flex: 6,
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(115, 158, 158, 158),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        
                        children: [
                          Container(
                            padding:EdgeInsets.all(10),
                            margin:EdgeInsets.only(bottom: 45, left: 15),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(136, 255, 255, 255),                              
                            ),
                            child: Image.asset(
                              'assets/icons/layer.png',
                              width: 25,
                              height: 30,
                            ),
                          ),        
                          Expanded(
                            child: Container(
                              margin:EdgeInsets.only(top:20, bottom:5, right: 15),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'amount',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 34),
                                  Align(                              
                                    alignment: Alignment.bottomRight,
                                    child: const Text(
                                      'Rs 540',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 50,  
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),



            // bottom Slider

            Container(
              // decoration: BoxDecoration(
              //   color: Color.fromARGB(255, 161, 120, 172),
              // ),
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              //https://pub.dev/packages/slide_to_act_reborn
              child: SlideAction(
                // borderRadius: 30,
                innerColor: Color.fromARGB(255, 0, 0, 0),
                outerColor: Color.fromARGB(255, 171, 90, 194),
                elevation: 0,
                sliderButtonIcon:  Container(
                  child: Text(
                      'ORDER',
                      style: TextStyle(
                        fontFamily: 'Gruppo',
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                  ),
                ),
                sliderRotate: false,
                onSubmit: () {},
                child: Row(  
                  mainAxisAlignment: MainAxisAlignment.center,                
                  children: [
                    Text(
                      '> ',
                      style: TextStyle(
                        fontFamily: 'Gruppo',
                        fontSize: 55,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '> ',
                      style: TextStyle(
                        fontFamily: 'Gruppo',
                        fontSize: 55,
                        color: Color.fromARGB(171, 255, 255, 255),
                      ),
                    ),
                    Text(
                      '>',
                      style: TextStyle(
                        fontFamily: 'Gruppo',
                        fontSize: 55,
                        color: Color.fromARGB(111, 255, 255, 255),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void _showTimeSelectionPopup() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select preorder time'),
        content: Container(
          width: MediaQuery.of(context).size.width*0.4,
          height: 300,
          child: HomePage(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Close',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Save',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),                    
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

}



