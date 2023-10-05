import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
// import 'package:food_delivery/classes/product.dart';
// import 'package:food_delivery/classes/cart.dart';
// import 'package:food_delivery/screens/RestrauntHelperFiles/model/product_category.dart';

import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/my_header_title.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';
import 'package:grouped_list/grouped_list.dart';

import 'RestrauntHelperfiles/model/product_category.dart';

// import 'RestrauntHelperfiles/controller/sliver_scroll_controller.dart';


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



  List<Product2> dummyProducts = [
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: 'images/mac.jpg',
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 1",
      description: "Description for Product 1",
      price: "19.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 2",
      description: "Description for Product 2",
      price: "29.99",
      image: "images/mac.jpg",
    ),
    Product2(
      name: "Product 3",
      description: "Description for Product 3",
      price: "15.99",
      image: "images/mac.jpg",
    ),
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
                      child: ListItemHeaderSliver(bloc: bloc)),
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
