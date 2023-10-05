import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
// import 'package:food_delivery/classes/product.dart';
// import 'package:food_delivery/classes/cart.dart';

import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/my_header_title.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/model/product_category.dart';

class RestaurantScreen extends StatefulWidget {
  static const String id = 'restaurant_screen';

  const RestaurantScreen(
      {Key? key, required this.screenHeight, required this.restaurant})
      : super(key: key);

  final double screenHeight;
  final Restaurant restaurant;

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  late ScrollController _controller;
  late ValueNotifier<double> bottomPercentNotifier;

  void _scrollListener() {
    var percent =
        _controller.position.pixels / MediaQuery.of(context).size.height;
    bottomPercentNotifier.value = (percent / .3).clamp(0.0, 1.0);
  }

  // late List<Product> itemList = [];

  // void getProducts() async {
  //   List<Product> items =
  //       await Product.getProducts(widget.restaurant.restaurantID);
  //   setState(() {
  //     itemList = items;
  //   });
  // }

  final bloc = SliverScrollController();

  @override
  void initState() {
    // getProducts();
    _controller =
        ScrollController(initialScrollOffset: widget.screenHeight * .3);
    _controller.addListener(_scrollListener);
    bottomPercentNotifier = ValueNotifier(1.0);

    bloc.init();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    bloc.init();

    super.dispose();
  }

  List<Product> dummyProducts = [
    Product(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: "product1.jpg",
    ),
    Product(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "product2.jpg",
    ),
    Product(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "product3.jpg",
    ),
    // Add more products as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ValueListenableBuilder<double>(
              valueListenable: bloc.globalOffsetValue,
              builder: (_, double valueCurrentScroll, __) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _controller,
                  slivers: [
                    SliverPersistentHeader(
                        pinned: true,
                        delegate: BuilderPersistentDelegate(
                            maxExtent: MediaQuery.of(context).size.height,
                            minExtent: 240,
                            builder: (percent) {
                              final bottomPercent =
                                  (percent / .3).clamp(0.0, 1.0);
                              return AnimatedDetailHeader(
                                topPercent:
                                    ((1 - percent) / .7).clamp(0.0, 1.0),
                                bottomPercent: bottomPercent,
                                restaurant: widget.restaurant,
                              );
                            })),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _HeaderSliver(bloc),
                    ),
                    for (var i = 0; i < bloc.listCategory.length; i++) ...[
                      SliverPersistentHeader(
                        delegate: MyHeaderTitle(
                          bloc.listCategory[i].category,
                          (visible) => bloc.refreshHeader(
                            i,
                            visible,
                            lastIndex: i > 0 ? i - 1 : null,
                          ),
                        ),
                      ),
                      SliverBodyItems(
                        // listItem: bloc.listCategory[i].products,
                        listItem: dummyProducts,
                      )
                    ],
                  ],
                );
              }),
        ],
      ),
    );
  }
}

const _maxHeaderExtent = 40.0;

class _HeaderSliver extends SliverPersistentHeaderDelegate {
  final SliverScrollController bloc;

  _HeaderSliver(this.bloc);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.3) {
      bloc.visibleHeader.value = true;
    } else {
      bloc.visibleHeader.value = false;
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      // child: percent > 0.1
                      //     ? ListItemHeaderSliver(bloc: bloc)
                      //     // : const SliverHeaderData(),
                      //     : SizedBox(),
                      child: ListItemHeaderSliver(bloc: bloc)
                      // : const SliverHeaderData(),
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => _maxHeaderExtent;

  @override
  // TODO: implement minExtent
  double get minExtent => _maxHeaderExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

// listview
class RestrauntMenuDisplay extends StatelessWidget {
  const RestrauntMenuDisplay({
    super.key,
    required this.itemList,
  });

  final List<Product> itemList;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: 700,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: MenuRows(itemList: itemList),
    );
  }
}

class MenuRows extends StatelessWidget {
  MenuRows({
    super.key,
    required this.itemList,
  });

  final List<Product> itemList;

  final items = [
    {
      "header": "Group A",
      "items": "Item 1",
    },
    {
      "header": "Group B",
      "items": "Item 1",
    },
    {
      "header": "Group A",
      "items": "Item 1",
    },
    {
      "header": "Group B",
      "items": "Item 1",
    },
    {
      "header": "Group A",
      "items": "Item 1",
    },
    {
      "header": "Group B",
      "items": "Item 1",
    },
    // Add more groups and items as needed
  ];

  // @override
  // Widget build(BuildContext context) {
  // return ListView.builder(
  //   physics: BouncingScrollPhysics(),
  //   itemCount: itemList.length,
  //   itemBuilder: (context, index) {
  //     final item = itemList[index];
  //     return Padding(
  //       padding: (index == 0)
  //           ? const EdgeInsets.symmetric(vertical: 10.0)
  //           : const EdgeInsets.only(bottom: 10.0),
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 10.0),
  //         padding: const EdgeInsets.all(5.0),
  //         decoration: BoxDecoration(
  //           color: Color.fromARGB(184, 237, 237, 237),
  //         ),

  //         // ListView row
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             AnimatedContainer(
  //               duration: Duration(milliseconds: 150),
  //               child: ClipRRect(
  //                 borderRadius: BorderRadius.circular(10.0),
  //                 child: Image.asset(
  //                   'images/mac.jpg',
  //                   width: 100.0,
  //                   height: 100.0,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(width: 10.0),
  //             AnimatedContainer(
  //               duration: Duration(milliseconds: 150),
  //               child: Expanded(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       item.name,
  //                       style: TextStyle(
  //                         fontSize: 18.0,
  //                         fontWeight: FontWeight.bold,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 10.0),
  //                     Text(
  //                       '${item.price}',
  //                       style: TextStyle(
  //                         fontSize: 14.0,
  //                         color: Colors.grey,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Cart.addNewProduct(item);
  //                 print('pressed ${item.name}');
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.blue,
  //                 foregroundColor: Colors.white,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10),
  //                 ),
  //               ),
  //               child: Padding(
  //                 padding:
  //                     EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 5),
  //                 child: Text('Add to Cart'),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   },
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GroupedListView<dynamic, String>(
        shrinkWrap: true,
        elements: items,
        groupBy: (element) => element['header'].substring(0, 7),
        groupSeparatorBuilder: (String groupByValue) => Container(
          height: 35,
          width: 125,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color.fromARGB(255, 50, 176, 208),
          ),
          child: Center(child: Text(groupByValue)),
        ),
        itemComparator: (item1, item2) =>
            item1['header'].compareTo(item2['header']),
        itemBuilder: (context, element) {
          return ListTile(
            title: Text(element['items']),
          );
        },
        useStickyGroupSeparators: true,
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key? key,
    required this.text,
    required this.builder,
  }) : super(key: key);

  final String text;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: builder)),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class BuilderPersistentDelegate extends SliverPersistentHeaderDelegate {
  BuilderPersistentDelegate({
    required double maxExtent,
    required double minExtent,
    required this.builder,
  })  : _maxExtent = maxExtent,
        _minExtent = minExtent;

  final double _maxExtent;
  final double _minExtent;
  final Widget Function(double percent) builder;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(shrinkOffset / _maxExtent);
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({
    required this.child,
  });

  @override
  double get minExtent => 0;

  @override
  double get maxExtent => 100; // Adjust the max height as needed

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
