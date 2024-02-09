import 'package:flutter/material.dart';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:food_delivery/components/animated_detail_header.dart';
import 'package:food_delivery/classes/product.dart';
import 'package:food_delivery/classes/category.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';
import 'RestrauntHelperfiles/model/product_category.dart';
import 'package:food_delivery/classes/UIColor.dart';

class RestaurantScreen extends StatefulWidget {
  static const String id = 'restaurant_screen';

  RestaurantScreen(
      {Key? key,
      required this.screenHeight,
      required this.resIndex,
      required this.restaurants,
      required this.customerID})
      : super(key: key);

  final double screenHeight;
  final List<Restaurant> restaurants;
  int resIndex;
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
    List<Product> items = await Product.getProducts(
      widget.restaurants[widget.resIndex],
    );
    setState(() {
      itemList = items;
    });
    return items;
  }

  late SliverScrollController bloc;
  bool _loading = false;
  bool _reLoading = false;

  void getCategories() async {
    setState(() {
      _loading = true;
    });
    List<Product> items1 = await getProducts();
    setState(() {
      itemList = items1;
    });

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

    _controller =
        ScrollController(initialScrollOffset: widget.screenHeight * .3);
    _controller.addListener(_scrollListener);
    bottomPercentNotifier = ValueNotifier(1.0);

    // bloc.init();
    // print(widget.customerID);
    super.initState();
  }

  // updates restaurant index values
  void updateResIndex(int newIndex) async {
    widget.resIndex = newIndex;
    setState(() {
      _reLoading = true;
      textWidgetsNotifier.value = true;
    });

    List<Product> items1 = await getProducts();
    setState(() {
      itemList = items1;
    });

    setState(() {
      bloc = SliverScrollController(items1);
      bloc.init();
    });

    setState(() {
      _reLoading = false;
      textWidgetsNotifier.value = false;
    });

    print("new value: $newIndex");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // a global key is assigned to our parent scaffold to allow snackbars to be displayed within its context
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> textWidgetsNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Shimmer(
        controller: _controller,
        restaurants: widget.restaurants,
        resIndex: widget.resIndex,
        updateResIndex: updateResIndex,
        textWidgetsNotifier: textWidgetsNotifier,
      );
    }
    // if (_reLoading) {
    //   return Scaffold(
    //     key: scaffoldKey,
    //     backgroundColor: ui.val(0),
    //     body: Builder(
    //       builder: (context) {
    //         return CustomScrollView(
    //           physics: const AlwaysScrollableScrollPhysics(),
    //           controller: _controller,
    //           slivers: [
    //             SliverPersistentHeader(
    //               pinned: true,
    //               delegate: BuilderPersistentDelegate(
    //                 maxExtent: MediaQuery.of(context).size.height,
    //                 minExtent: 160,
    //                 builder: (percent) {
    //                   final bottomPercent = (percent / .3).clamp(0.0, 1.0);
    //                   return AnimatedDetailHeaderShimmer(
    //                     topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
    //                     bottomPercent: bottomPercent,
    //                     restaurants: widget.restaurants,
    //                     resIndex: widget.resIndex,
    //                     updateResIndex: updateResIndex,
    //                     textWidgetsNotifier: textWidgetsNotifier,
    //                   );
    //                 },
    //               ),
    //             ),
    //             SliverPersistentHeader(
    //               pinned: true,
    //               delegate: _HeaderSliverShimmer(),
    //             ),
    //             for (var i = 0; i < 3; i++) ...[
    //               SliverPersistentHeader(
    //                 delegate: MyHeaderTitleShimmer(),
    //               ),
    //               SliverBodyItemsShimmer(),
    //             ],
    //           ],
    //         );
    //       },
    //     ),
    //   );
    // }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ui.val(0),
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
                        final bottomPercent = (percent / .3).clamp(0.0, 1.0);

                        return AnimatedDetailHeaderShimmer(
                          topPercent: ((1 - percent) / .7).clamp(0.0, 1.0),
                          bottomPercent: bottomPercent,
                          restaurants: widget.restaurants,
                          resIndex: widget.resIndex,
                          updateResIndex: updateResIndex,
                          textWidgetsNotifier: textWidgetsNotifier,
                        );
                      },
                    ),
                  ),
                  if (_reLoading) ...[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _HeaderSliverShimmer(),
                    ),
                    for (var i = 0; i < 3; i++) ...[
                      SliverPersistentHeader(
                        delegate: MyHeaderTitleShimmer(),
                      ),
                      SliverBodyItemsShimmer(),
                    ],
                  ] else ...[
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
                        scaffold: scaffoldKey.currentContext!,
                        // scaffoldkey: scaffoldKey,
                        // listItem: dummyProducts,
                      ),
                    ],
                  ]
                ],
              );
            },
          ),
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
    required this.resIndex,
    // required this.widget,
    required this.restaurants,
    required this.updateResIndex,
    required this.textWidgetsNotifier,
  }) : _controller = controller;

  // final SliverScrollController bloc;
  final ScrollController _controller;
  // final RestaurantScreen widget;
  final List<Restaurant> restaurants;
  final int resIndex;
  final Function(int) updateResIndex;
  final ValueNotifier<bool> textWidgetsNotifier;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ui.val(1),
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
                          restaurants: restaurants,
                          resIndex: resIndex,
                          updateResIndex: updateResIndex,
                          textWidgetsNotifier: textWidgetsNotifier,
                        );
                      })),
              SliverPersistentHeader(
                pinned: true,
                delegate: _HeaderSliverShimmer(),
              ),
              for (var i = 0; i < 3; i++) ...[
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
            color: ui.val(2),
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
            color: ui.val(2),
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
                              color: ui.val(10).withOpacity(0.5),
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
                              color: ui.val(10).withOpacity(0.5),
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
      color: ui.val(1),
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 5, top: 5),
        height: 30,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: ui.val(2),
        ),
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
            decoration: BoxDecoration(color: ui.val(1)),
            child: Container(
              height: 150,
              margin: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ui.val(2),
                  // borderRadius: BorderRadius.only(
                  //   topRight: Radius.circular(20),
                  //   topLeft: Radius.circular(20),
                  // ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          );
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
