import 'package:food_delivery/classes/UIColor.dart';
import 'dart:ui';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:flutter/material.dart';

String getImg(String resName) {
  String image = "kfc.jpg";
  resName = resName.toLowerCase();
  if (resName.contains("burger")) {
    image = "burger.jpg";
  } else if (resName.contains("cafe")) {
    image = "cafe.jpg";
  } else if (resName.contains("dhaba")) {
    image = "dhaba.jpg";
  } else if (resName.contains("juice")) {
    image = "juice.jpg";
  } else if (resName.contains("limca")) {
    image = "limca.jpg";
  } else if (resName.contains("pathan")) {
    image = "pathan.jpg";
  } else if (resName.contains("pizza")) {
    image = "pizza.jpg";
  } else if (resName.contains("shawarma")) {
    image = "shawarma.jpg";
  } else {
    image = "kfc.jpg";
  }
  print("image: $image");
  return image;
}

class AnimatedDetailHeader extends StatefulWidget {
  const AnimatedDetailHeader({
    Key? key,
    required this.topPercent,
    required this.bottomPercent,
    required this.restaurants,
    required this.resIndex,
    required this.updateResIndex,
    required this.textWidgetsNotifier,
    // required this.menu,
  }) : super(key: key);

  final double topPercent;
  final double bottomPercent;
  final List<Restaurant> restaurants;
  final int resIndex;
  final Function(int) updateResIndex;
  final ValueNotifier<bool> textWidgetsNotifier;

  @override
  _AnimatedDetailHeaderState createState() => _AnimatedDetailHeaderState();
}

class _AnimatedDetailHeaderState extends State<AnimatedDetailHeader> {
  late String image;
  late String resName;

  @override
  void initState() {
    super.initState();
    resName = widget.restaurants[widget.resIndex].name;
    image = getImg(resName);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: widget.restaurants[widget.resIndex],
          child: Material(
            color: ui.val(0),
            child: ClipRect(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: (20 + topPadding) * (1 - widget.bottomPercent),
                      bottom: 160 * (1 - widget.bottomPercent),
                    ),
                    child: Transform.scale(
                      scale: lerpDouble(1, 1.3, widget.bottomPercent)!,
                      child: PlaceImagesPageView(
                        images: "images/$image",
                        restaurants: widget.restaurants,
                        resIndex: widget.resIndex,
                        callback: widget.updateResIndex,
                        callbackParent: widget.updateResIndex,
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    left: -60 * (1 - widget.bottomPercent),
                    child: const BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    right: -60 * (1 - widget.bottomPercent),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: lerpDouble(-30, 140, widget.topPercent)!
                        .clamp(topPadding + 10, 140),
                    left: lerpDouble(60, 20, widget.topPercent)!
                        .clamp(20.0, 50.0),
                    right: 20,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: widget.bottomPercent < 1 ? 0 : 1,
                      child: Text(
                        resName,
                        style: TextStyle(
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                          fontSize: lerpDouble(30, 40, 2 * widget.topPercent),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'britanic',
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    top: 220,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: widget.bottomPercent < 1 ? 0 : 1,
                      child: Opacity(
                        opacity: widget.topPercent,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 25,
                          child: Text(
                            widget.restaurants[widget.resIndex].description,
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                  offset: Offset(1, 1),
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: null,
          bottom: -140 * (1 - widget.topPercent),
          child: TranslateAnimation(
            child: MenuInfoContainer(
              restaurant: widget.restaurants[widget.resIndex],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(color: ui.val(2), height: 10),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: ui.val(2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(30, 10),
                  topRight: Radius.elliptical(30, 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedDetailHeaderShimmer extends StatefulWidget {
  AnimatedDetailHeaderShimmer({
    Key? key,
    required this.topPercent,
    required this.bottomPercent,
    required this.restaurants,
    required this.resIndex,
    required this.updateResIndex,
    required this.textWidgetsNotifier,
  }) : super(key: key);

  final double topPercent;
  final double bottomPercent;
  final List<Restaurant> restaurants;
  int resIndex;
  final Function(int) updateResIndex;
  final ValueNotifier<bool> textWidgetsNotifier;

  @override
  _AnimatedDetailHeaderShimmerState createState() =>
      _AnimatedDetailHeaderShimmerState();
}

class _AnimatedDetailHeaderShimmerState
    extends State<AnimatedDetailHeaderShimmer> {
  late String image;

  @override
  void initState() {
    super.initState();
    // Initialize the image
    image = getImg(widget.restaurants[widget.resIndex].name);
  }

  void updateResIndexParent(int newIndex) async {
    widget.resIndex = newIndex;
    print("new value: $newIndex");
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: widget.restaurants[widget.resIndex],
          child: Material(
            color: ui.val(0),
            child: ClipRect(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: (20 + topPadding) * (1 - widget.bottomPercent),
                      bottom: 160 * (1 - widget.bottomPercent),
                    ),
                    child: Transform.scale(
                      scale: lerpDouble(1, 1.3, widget.bottomPercent) ?? 1,
                      child: PlaceImagesPageView(
                        images: "images/$image",
                        restaurants: widget.restaurants,
                        resIndex: widget.resIndex,
                        callback: widget.updateResIndex,
                        callbackParent: updateResIndexParent,
                      ),
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    left: -60 * (1 - widget.bottomPercent),
                    child: const BackButton(
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: topPadding,
                    right: -60 * (1 - widget.bottomPercent),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    top: lerpDouble(-30, 140, widget.topPercent)!
                        .clamp(topPadding + 10, 140),
                    left: lerpDouble(60, 20, widget.topPercent)!
                        .clamp(20.0, 50.0),
                    right: 20,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: widget.bottomPercent < 1 ? 0 : 1,
                      child: ValueListenableBuilder<bool>(
                          valueListenable: widget.textWidgetsNotifier,
                          builder: (context, value, child) {
                            return Text(
                              value == true
                                  ? ""
                                  : widget.restaurants[widget.resIndex].name,
                              style: TextStyle(
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                                fontSize:
                                    lerpDouble(30, 40, 2 * widget.topPercent),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'britanic',
                              ),
                            );
                          }),
                    ),
                  ),
                  Positioned(
                    left: 25,
                    top: 220,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: widget.bottomPercent < 1 ? 0 : 1,
                      child: Opacity(
                        opacity: widget.topPercent,
                        child: Container(
                          width: MediaQuery.of(context).size.width - 25,
                          child: ValueListenableBuilder<bool>(
                              valueListenable: widget.textWidgetsNotifier,
                              builder: (context, value, child) {
                                return Text(
                                  value == true
                                      ? ""
                                      : widget.restaurants[widget.resIndex]
                                          .description,
                                  style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 20,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: null,
          bottom: -140 * (1 - widget.topPercent),
          child: TranslateAnimation(
            child: ValueListenableBuilder<bool>(
                valueListenable: widget.textWidgetsNotifier,
                builder: (context, value, child) {
                  if (value == false)
                    return MenuInfoContainer(
                      restaurant: widget.restaurants[widget.resIndex],
                    );
                  else
                    return Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 33, 33, 33),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 3, left: 3),
                                  child: Text(
                                    " ",
                                    style: TextStyle(
                                      color: ui.val(4),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    " ",
                                    style: TextStyle(
                                      color: ui.val(4),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    " ",
                                    style: TextStyle(
                                      color: ui.val(4),
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ));
                }),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(color: ui.val(2), height: 10),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                color: ui.val(2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(30, 10),
                  topRight: Radius.elliptical(30, 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MenuInfoContainer extends StatefulWidget {
  final Restaurant restaurant;

  const MenuInfoContainer({
    Key? key,
    required this.restaurant,
  }) : super(key: key);

  @override
  _MenuInfoContainerState createState() => _MenuInfoContainerState();
}

class _MenuInfoContainerState extends State<MenuInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 33, 33, 33),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.grey),
                Container(
                  margin: const EdgeInsets.only(top: 3, left: 3),
                  child: Text(
                    " ${widget.restaurant.rating} ",
                    style: TextStyle(
                      color: ui.val(4),
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Text(
                    "(${widget.restaurant.totalRatings})",
                    style: TextStyle(
                      color: ui.val(4),
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_rounded, color: Colors.grey, size: 17),
                  Text(
                    " ${widget.restaurant.estimatedTime}    100rs minimum",
                    style: TextStyle(
                      color: ui.val(4),
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

class TranslateAnimation extends StatelessWidget {
  const TranslateAnimation({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1, end: 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * value),
          child: child!,
        );
      },
      child: child,
    );
  }
}

class PlaceImagesPageView extends StatefulWidget {
  const PlaceImagesPageView({
    super.key,
    required this.images,
    required this.restaurants,
    required this.resIndex,
    required this.callback,
    required this.callbackParent,
  });

  // final List<String> images;
  final String images;
  final List<Restaurant> restaurants;
  final int resIndex;

  final Function(int) callback;
  final Function(int) callbackParent;

  @override
  State<PlaceImagesPageView> createState() => _PlaceImagesPageViewState();
}

class _PlaceImagesPageViewState extends State<PlaceImagesPageView> {
  late int currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.resIndex;
    _pageController =
        PageController(initialPage: currentIndex, viewportFraction: .9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: widget.restaurants.length,
            onPageChanged: (value) {
              setState(() => currentIndex = value);
              widget.callback(value);
              widget.callbackParent(value);
            },
            physics: const BouncingScrollPhysics(),
            controller: _pageController,
            itemBuilder: (context, index) {
              final isSelected = currentIndex == index;
              return AnimatedContainer(
                duration: kThemeAnimationDuration,
                margin: EdgeInsets.only(
                  right: 10,
                  left: 10,
                  top: isSelected ? 5 : 20,
                  bottom: isSelected ? 5 : 20,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage(
                        "images/${getImg(widget.restaurants[currentIndex].name)}"),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {},
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.restaurants.length, // <-- ITEM COUNT
              (index) {
            final isSelected = currentIndex == index;
            return AnimatedContainer(
              duration: kThemeAnimationDuration,
              color: isSelected ? Colors.white70 : Colors.white38,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 3,
              width: isSelected ? 20 : 10,
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
