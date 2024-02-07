import 'package:food_delivery/classes/UIColor.dart';
import 'dart:ui';
import 'package:food_delivery/classes/restaurant.dart';
import 'package:flutter/material.dart';

class AnimatedDetailHeader extends StatelessWidget {
  const AnimatedDetailHeader(
      {Key? key,
      required this.topPercent,
      required this.bottomPercent,
      required this.restaurant
      // required this.menu,
      })
      : super(key: key);

  // final restraunt menu;
  final double topPercent;
  final double bottomPercent;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    String image = "kfc.jpg";
    String resName = restaurant.name;
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

    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: restaurant,
          child: Material(
            color: ui.val(0),
            child: ClipRect(
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: (20 + topPadding) * (1 - bottomPercent),
                      bottom: 160 * (1 - bottomPercent),
                    ),
                    child: Transform.scale(
                      scale: lerpDouble(1, 1.3, bottomPercent)!,
                      child: PlaceImagesPageView(images: "images/$image"),
                    ),
                  ),
                  Positioned(
                      top: topPadding,
                      left: -60 * (1 - bottomPercent),
                      child: const BackButton(
                        color: Colors.white,
                      )),
                  Positioned(
                      top: topPadding,
                      right: -60 * (1 - bottomPercent),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          color: Colors.white,
                        ),
                        color: Colors.white,
                      )),
                  Positioned(
                      top: lerpDouble(-30, 140, topPercent)!
                          .clamp(topPadding + 10, 140),
                      left: lerpDouble(60, 20, topPercent)!.clamp(20.0, 50.0),
                      right: 20,
                      child: AnimatedOpacity(
                        duration: kThemeAnimationDuration,
                        opacity: bottomPercent < 1 ? 0 : 1,
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: lerpDouble(30, 40, 2 * topPercent),
                            fontWeight: FontWeight.bold,
                            fontFamily: 'britanic',
                          ),
                        ),
                      )),
                  Positioned(
                    left: 25,
                    top: 220,
                    child: AnimatedOpacity(
                      duration: kThemeAnimationDuration,
                      opacity: bottomPercent < 1 ? 0 : 1,
                      child: Opacity(
                        opacity: topPercent,
                        child: Text(
                          restaurant.ownerName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
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
          bottom: -140 * (1 - topPercent),
          child: const TranslateAnimation(
            child: MenuInfoContainer(),
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

class MenuInfoContainer extends StatelessWidget {
  const MenuInfoContainer({
    super.key,
  });

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
                    "4.3 ",
                    style: TextStyle(
                      color: ui.val(4),
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  child: Text(
                    "(4k+)",
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
                    " 40-50 min    100rs minimum",
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
  });

  // final List<String> images;
  final String images;

  @override
  State<PlaceImagesPageView> createState() => _PlaceImagesPageViewState();
}

class _PlaceImagesPageViewState extends State<PlaceImagesPageView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: 5,
            onPageChanged: (value) {
              setState(() => currentIndex = value);
            },
            physics: const BouncingScrollPhysics(),
            controller: PageController(viewportFraction: .9),
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
                    image: AssetImage('${widget.images}'),
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
          children: List.generate(5, // <-- ITEM COUNT
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
