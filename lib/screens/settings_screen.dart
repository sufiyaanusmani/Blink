import 'package:flutter/material.dart';
import 'package:food_delivery/classes/order_history.dart';
import 'package:food_delivery/components/setting_switch.dart';
import 'package:food_delivery/components/title_button.dart';
import 'package:food_delivery/mysql.dart';
import 'package:food_delivery/screens/privacy_policy_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mysql_client/mysql_client.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  final int customerID;
  const SettingsScreen({super.key, required this.customerID});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

/*
User settings options
Profile settings (Name/password)
  |----> password changing ke liye email verification?
App theme Dark/Light/SystemSettings
Notification preferences Turn ON OFF
stored billing information Add/Remove/Delete
view past orders
  |----> view us order ki detail
Terms of service and privacy policy
App version information
FAQs
Feedback Form
*/

class _SettingsScreenState extends State<SettingsScreen> {
  bool light = true;
  late String name = '';
  late List<OrderHistory> orders = [];

  void loadName() async {
    var db = Mysql();
    String tempFirstName, tempLastName;
    Iterable<ResultSetRow> rows = await db.getResults(
        'SELECT first_name, last_name FROM Customer WHERE customer_id=${widget.customerID}');
    if (rows.length == 1) {
      for (var row in rows) {
        tempFirstName = row.assoc()['first_name']!;
        tempLastName = row.assoc()['last_name']!;
        setState(() {
          name = '$tempFirstName $tempLastName';
        });
      }
    }
  }

  void loadOrderHistory() async {
    List<OrderHistory> temp =
        await OrderHistory.getOrderHistory(widget.customerID);
    setState(() {
      orders = temp;
    });
  }

  void loadAllInfo() async {
    loadName();
    loadOrderHistory();
  }

  @override
  void initState() {
    // TODO: implement initState
    loadAllInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Header(
          name: name,
        ),
        const SizedBox(height: 30.0),
        Divider(color: Colors.grey.shade300, thickness: 1),
        SettingSwitch(
          primaryTitle: 'Dark Mode',
          secondaryTitle: 'Turn on dark mode',
          switchValue: false,
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        TitleButton(
          title: "Order information",
          subtitle: "View past orders",
          onPressed: () {
            print('pressed');
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrdersPage(
                        customerID: widget.customerID,
                      )),
            );
          },
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        TitleButton(
          title: "Privacy Policy",
          subtitle: "Terms of service and privacy policy",
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
          },
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        TitleButton(
          title: "FAQs",
          subtitle: "Answer to your frequently asked questions",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        Divider(color: Colors.grey.shade300, thickness: 1),
        Container(
          width: 4,
          height: 80,
          padding: EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Logout'),
          ),
        )
      ],
    );
  }
}

class Header extends StatelessWidget {
  final String name;
  const Header({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 210,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(190, 100)),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(210, 100)),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.elliptical(230, 100)),
          ),
        ),
        Positioned(
          top: 70,
          left: (MediaQuery.of(context).size.width / 2) - 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black38, width: 2),
            ),
            child: ClipOval(
              child: Opacity(
                opacity: 0.75,
                child: Image.asset(
                  'assets/icons/profileIcon.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Text(
          name,
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
      ],
    );
  }
}

class OrdersPage extends StatefulWidget {
  final int customerID;
  OrdersPage({required this.customerID});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late List<OrderHistory> orderHistory = [];
  bool _loading = false;

  void getOrderHistory() async {
    setState(() {
      _loading = true;
    });
    List<OrderHistory> temp = [];
    temp = await OrderHistory.getOrderHistory(widget.customerID);
    setState(() {
      orderHistory = temp;
    });
    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.orange, size: 100)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Information'),
        backgroundColor: Colors.black,
      ),
      body: OrdersList(orderHistory: orderHistory),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<OrderHistory> orderHistory;
  OrdersList({required this.orderHistory});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: orderHistory.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: Colors.grey.shade300, thickness: 1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Order #${orderHistory[index].orderID}',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                        Text(
                            '${orderHistory[index].date}  ${orderHistory[index].time}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                    child: Text(orderHistory[index].restaurantName),
                  ),
                ],
              ),
              SizedBox(height: 5),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration:
                    BoxDecoration(color: Colors.orangeAccent.withOpacity(0.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total price: ',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                    Text('Rs. ${orderHistory[index].price}',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              SizedBox(height: 35),
            ],
          );
        },
      ),
    );
  }
}
