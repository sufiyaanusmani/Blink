import 'package:flutter/material.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/background_sliver.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/my_header_title.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/sliver_header_data.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/widgets.dart';

class HomeSliverWithTab extends StatefulWidget {
  const HomeSliverWithTab({Key? key}) : super(key: key);

  @override
  State<HomeSliverWithTab> createState() => _HomeSliverWithTabState();
}

class _HomeSliverWithTabState extends State<HomeSliverWithTab> {
  final bloc = SliverScrollController();

  @override
  void initState() {
    super.initState();
    bloc.init();
  }

  @override
  void dispose() {
    bloc.init();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        radius: const Radius.circular(8),
        notificationPredicate: (scroll) {
          bloc.valueScroll.value = scroll.metrics.extentInside;
          return true;
        },
        child: ValueListenableBuilder<double>(
            valueListenable: bloc.globalOffsetValue,
            builder: (_, double valueCurrentScroll, __) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: bloc.scrollControllerGlobally,
                slivers: [
                  // _FlexibleSpaceBarHeader(
                  //   valueScroll: valueCurrentScroll,
                  //   bloc: bloc,
                  // ),
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
                      listItem: bloc.listCategory[i].products,
                    )
                  ]
                ],
              );
            }),
      ),
    );
  }
}

class _FlexibleSpaceBarHeader extends StatelessWidget {
  const _FlexibleSpaceBarHeader({
    Key? key,
    required this.valueScroll,
    required this.bloc,
  }) : super(key: key);
  final double valueScroll;
  final SliverScrollController bloc;

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height;
    return SliverAppBar(
      expandedHeight: 250,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      stretch: true,
      pinned: valueScroll < 90,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            const BackgroundSliver(),
            Positioned(
              right: 10,
              top: (sizeHeight + 20) - bloc.valueScroll.value,
              child: const Icon(Icons.favorite, size: 30, color: Colors.white),
            ),
            Positioned(
              left: 10,
              top: (sizeHeight + 20) - bloc.valueScroll.value,
              child:
                  const Icon(Icons.arrow_back, size: 30, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

const _maxHeaderExtent = 100.0;

class _HeaderSliver extends SliverPersistentHeaderDelegate {
  final SliverScrollController bloc;

  _HeaderSliver(this.bloc);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = shrinkOffset / _maxHeaderExtent;
    if (percent > 0.1) {
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
            color: Colors.blue,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      AnimatedOpacity(
                        opacity: percent > 0.1 ? 1 : 0,
                        duration: const Duration(milliseconds: 300),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        offset: Offset(percent < 0.1 ? -0.18 : 0.1, 0),
                        curve: Curves.easeIn,
                        child: const Text(
                          'Kavsoft Bakery',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: percent > 0.1
                        ? ListItemHeaderSliver(bloc: bloc)
                        : const SliverHeaderData(),
                  ),
                )
              ],
            ),
          ),
        ),
        if (percent > 0.1)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: percent > 0.1
                  ? Container(height: .5, color: Colors.white10)
                  : null,
            ),
          )
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
