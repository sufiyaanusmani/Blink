import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
import 'package:food_delivery/classes/product.dart';
import 'package:food_delivery/classes/category.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';
import 'RestrauntHelperfiles/model/product_category.dart';

class RestaurantScreen extends StatefulWidget {
  static const String id = 'restaurant_screen';

  const RestaurantScreen(
      {Key? key,
      required this.screenHeight,
      required this.restaurant,
      required this.customerID})
      : super(key: key);

  final double screenHeight;
  final Restaurant restaurant;
  final int customerID;

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
  late List<Category> categoryList = [];

  Future<List<Product>> getProducts() async {
    List<Product> items =
        await Product.getProducts(widget.restaurant.restaurantID);
    setState(() {
      itemList = items;
    });
    return items;
  }

  late SliverScrollController bloc;
  bool _loading = false;

  void getCategories() async {
    setState(() {
      _loading = true;
    });
    List<Product> items1 = await getProducts();
    setState(() {
      itemList = items1;
    });
    // for (Product item in items1) {
    //   bool found = false;
    //   for (int i = 0; i < temp.length; i++) {
    //     if (item.category_id == temp[i].id) {
    //       temp[i].products.add(item);
    //       found = true;
    //     }
    //   }
    //   if (found == false) {
    //     temp.add(Category(id: item.category_id, name: item.category_name));
    //     temp[temp.length - 1].products.add(item);
    //   }
    // }
    // setState(() {
    //   bloc.listCategory = temp;
    //   bloc.init();
    // });
    setState(() {
      bloc = SliverScrollController(items1);
      bloc.init();
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    // getProducts();
    getCategories();
    // bloc = SliverScrollController();

    _controller =
        ScrollController(initialScrollOffset: widget.screenHeight * .3);
    _controller.addListener(_scrollListener);
    bottomPercentNotifier = ValueNotifier(1.0);

    // bloc.init();
    print(widget.customerID);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    // bloc.init();

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
    if (_loading) {
      return Shimmer(
        controller: _controller,
        restaurant: widget.restaurant,
      );
    }
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
                            minExtent: 160,
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
                          bloc.listCategory[i].name,
                          (visible) => bloc.refreshHeader(
                            i,
                            visible,
                            lastIndex: i > 0 ? i - 1 : null,
                          ),
                        ),
                      ),
                      SliverBodyItems(
                        listItem: bloc.listCategory[i].products,
                        customerID: widget.customerID,
                        // listItem: dummyProducts,
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

class Shimmer extends StatelessWidget {
  const Shimmer({
    super.key,
    // required this.bloc,
    required ScrollController controller,
    // required this.widget,
    required this.restaurant,
  }) : _controller = controller;

  // final SliverScrollController bloc;
  final ScrollController _controller;
  // final RestaurantScreen widget;
  final Restaurant restaurant;

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
                      minExtent: 160,
                      builder: (percent) {
                        final bottomPercent = (percent / .3).clamp(0.0, 1.0);
                        return AnimatedDetailHeader(
                          topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
                          bottomPercent: bottomPercent,
                          restaurant: restaurant,
                        );
                      })),
              SliverPersistentHeader(
                pinned: true,
                delegate: _HeaderSliverShimmer(),
              ),
              for (var i = 0; i < 1; i++) ...[
                SliverPersistentHeader(
                  delegate: MyHeaderTitleShimmer(),
                ),
                SliverBodyItemsShimmer(),
              ],
            ],
          )
        ],
      ),
    );
  }

  static fromColors(
      {required Color baseColor,
      required Color highlightColor,
      required Duration period,
      required Container child}) {}
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
          // bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Colors.white,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(20),
            //   color: Colors.amber,
            // ),
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

//   SHIMMER
class _HeaderSliverShimmer extends SliverPersistentHeaderDelegate {
  _HeaderSliverShimmer();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          child: Container(
            height: _maxHeaderExtent,
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 45,
                          margin:
                              EdgeInsets.only(bottom: 5, left: 10, right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        Container(
                          height: 40,
                          width: 50,
                          margin:
                              EdgeInsets.only(bottom: 5, left: 10, right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ],
                    ),
                  ),
                ),
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

//   SHIMMER
class MyHeaderTitleShimmer extends SliverPersistentHeaderDelegate {
  const MyHeaderTitleShimmer();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5, top: 5),
        height: 30,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.shade200),
      ),
    );
  }

  @override
  double get maxExtent => headerTitle;

  @override
  double get minExtent => headerTitle;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

//    SHIMMER
class SliverBodyItemsShimmer extends StatelessWidget {
  const SliverBodyItemsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
              height: 100,
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ));
        },
        childCount: 1, // Three shimmering containers
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
