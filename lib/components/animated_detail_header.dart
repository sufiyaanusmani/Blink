import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/classes/menu.dart';

class AnimatedDetailHeader extends StatelessWidget {
  const AnimatedDetailHeader({
    Key? key,
    required this.topPercent,
    required this.bottomPercent,
    // required this.menu,
  }) : super(key: key);

  // final restraunt menu;
  final double topPercent;
  final double bottomPercent;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final image = 'images/kfc.jpg';

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: Stack(
            children:[
              Padding(
                padding: EdgeInsets.only(
                  top: (20 + topPadding) * (1 - bottomPercent),
                  bottom: 160 * (1 - bottomPercent),
                ),
                child: Transform.scale(
                  scale: lerpDouble(1, 1.3, bottomPercent)!,
                  child: PlaceImagesPageView(images: image),
                ),
              ),
              Positioned(
                top: topPadding,
                left: -60 * (1 - bottomPercent),
                child: BackButton(
                  color: Colors.white,
                )
              ),
              Positioned(
                top: topPadding,
                right: -60 * (1 - bottomPercent),
                child: IconButton(
                  onPressed: (){},
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  ),
                  color: Colors.white,
                )
              ),
              Positioned(
                top: lerpDouble(-30, 140, topPercent)!.clamp(topPadding + 10, 140),
                left: lerpDouble(60, 20, topPercent)!.clamp(20.0, 50.0),
                right: 20,
                child: AnimatedOpacity(
                  duration: kThemeAnimationDuration,
                  opacity: bottomPercent < 1 ? 0 : 1,
                  child: Text(
                    "Dhaaba",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: lerpDouble(30, 40, 2*topPercent),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ),
              Positioned(
                left: 20,
                top: 200,
                child: AnimatedOpacity(
                  duration: kThemeAnimationDuration,
                  opacity: bottomPercent < 1 ? 0 : 1,
                  child: Opacity(
                    opacity: topPercent,
                    child: Text(
                      "Custom widget",
                      style: TextStyle(
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

        Positioned.fill(
          top: null,
          bottom: -140 * (1 - topPercent),
          child: TranslateAnimation(
            child: MenuInfoContainer(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(color: Colors.white, height: 10),
        ),
        Positioned.fill(
          top: null,
          child: TranslateAnimation(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
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
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                primary: Colors.black,
                // textStyle: context.,
                shape: const StadiumBorder(),
              ),
              icon: const Icon(CupertinoIcons.heart),
              label: Text("ratings"),
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
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * value),
          child: child!,
        );
      },
      child: child,
    );
  }
}

class PlaceImagesPageView extends StatelessWidget {
  const PlaceImagesPageView({
    super.key,
    required this.images,
  });

  // final List<String> images;
  final images;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            itemCount: 5,
            physics: const BouncingScrollPhysics(),
            controller: PageController(viewportFraction: .9),
            itemBuilder: (context, index) {
              const imageUrl = 'images/kfc.jpg';
              return Container(
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  image: DecorationImage(
                    image: AssetImage('images/kfc.jpg'),
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              5, // <-- ITEM COUNT
              (index) => Container(
                    color: Colors.black12,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 3,
                    width: 10,
                  )),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
