import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
import 'package:food_delivery/classes/product.dart';
import 'package:food_delivery/classes/cart.dart';

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

  late List<Product> itemList = [];

  void getProducts() async {
    List<Product> items =
        await Product.getProducts(widget.restaurant.restaurantID);
    setState(() {
      itemList = items;
    });
  }

  @override
  void initState() {
    getProducts();
    _controller =
        ScrollController(initialScrollOffset: widget.screenHeight * .3);
    _controller.addListener(_scrollListener);
    bottomPercentNotifier = ValueNotifier(1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _controller,
            slivers: [
              SliverPersistentHeader(
                  pinned: true,
                  delegate: BuilderPersistentDelegate(
                      maxExtent: MediaQuery.of(context).size.height,
                      minExtent: 240,
                      builder: (percent) {
                        final bottomPercent = (percent / .3).clamp(0.0, 1.0);
                        return AnimatedDetailHeader(
                          topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
                          bottomPercent: bottomPercent,
                          restaurant: widget.restaurant,
                        );
                      })),
              SliverToBoxAdapter(
                child: TranslateAnimation(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Column(
                                  children: [
                                    RestrauntMenuDisplay(itemList: itemList),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
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
      width: MediaQuery.of(context)
                  .size
                  .width *
              0.95,
      margin:
          EdgeInsets.only(top: 5, left: 5),
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(
            Radius.circular(20)),
      ),

      child: MenuRows(itemList: itemList),
    );
  }
}

class MenuRows extends StatelessWidget {
  const MenuRows({
    super.key,
    required this.itemList,
  });

  final List<Product> itemList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        final item = itemList[index];
        return Padding(
          padding: (index == 0)
              ? const EdgeInsets
                      .symmetric(
                  vertical: 10.0)
              : const EdgeInsets.only(
                  bottom: 10.0),
          child: Container(
            margin: const EdgeInsets
                    .symmetric(
                horizontal: 10.0),
            padding: const EdgeInsets.all(
                10.0),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(
                      10.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    color: Colors
                        .grey[400]!),
              ],
            ),

            // ListView row
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment
                      .center,
              children: [
                AnimatedContainer(
                  duration: Duration(
                      milliseconds: 150),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                                10.0),
                    child: Image.asset(
                      'images/mac.jpg',
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                    width: 10.0),
                AnimatedContainer(
                  duration: Duration(
                      milliseconds: 150),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Text(
                          item.name,
                          style:
                              TextStyle(
                            fontSize:18.0,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                        const SizedBox(
                            height: 10.0),
                        Text(
                          '${item.price}',
                          style:
                              TextStyle(
                            fontSize:14.0,
                            color: Colors
                                .grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Cart.addNewProduct(
                        item);
                    print(
                        'pressed ${item.name}');
                  },
                  style: ElevatedButton
                      .styleFrom(
                    backgroundColor:
                        Colors.blue,
                    foregroundColor:
                        Colors.white,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  10),
                    ),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            right: 5,
                            left: 5),
                    child: Text(
                        'Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
