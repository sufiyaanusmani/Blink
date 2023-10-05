import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:food_delivery/screens/RestrauntHelperfiles/model/my_header.dart';
import 'package:food_delivery/screens/RestrauntHelperfiles/model/product_category.dart';

class SliverScrollController {
  late List<ProductCategory> listCategory;

  List<double> listOffsetItemHeader = [];

  final headerNotifier = ValueNotifier<MyHeader?>(null);

  final globalOffsetValue = ValueNotifier<double>(0);

  final goingDown = ValueNotifier<bool>(false);

  final valueScroll = ValueNotifier<double>(0);

  late ScrollController scrollControllerItemHeader;

  late ScrollController scrollControllerGlobally;

  final visibleHeader = ValueNotifier(false);



final productsw = [
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
  Product(
    name: 'Choclate Cake',
    image: 'assets/icons/cancel.png',
    description: 'hai,.,,,,.......................................',
    price: '\$19',
  ),
];


  void loadDataRandom() {
    final productsTwo = [...productsw];
    final productsThree = [...productsw];
    final productsFour = [...productsw];

    productsTwo.shuffle();
    productsThree.shuffle();
    productsFour.shuffle();




    listCategory = [
      ProductCategory(
        category: 'Order Again',
        products: productsw,
      ),
      ProductCategory(
        category: 'Picked For You',
        products: productsw,
      ),
      ProductCategory(
        category: 'Starter',
        products: productsw,
      ),
      ProductCategory(
        category: 'Roll',
        products: productsw,
      )
    ];
  }

  void init() {
    loadDataRandom();
    listOffsetItemHeader = List.generate(
      listCategory.length,
      (index) => index.toDouble(),
    );
    scrollControllerGlobally = ScrollController();
    scrollControllerItemHeader = ScrollController();
    scrollControllerGlobally.addListener(_listenToScollChange);
    headerNotifier.addListener(_listenHeaderNeotifier);
    visibleHeader.addListener(_listendVisibleHeader);
  }

  void _listendVisibleHeader() {
    if (visibleHeader.value) {
      headerNotifier.value = const MyHeader(visibile: false, index: 0);
    }
  }

  void _listenHeaderNeotifier() {
    if (visibleHeader.value) {
      for (var i = 0; i < listCategory.length; i++) {
        scrollAnimationHorizontal(index: i);       
      }
    }
  }

  void scrollAnimationHorizontal({required int index}) {
    if (headerNotifier.value?.index == index &&
        headerNotifier.value!.visibile) {
      scrollControllerItemHeader.animateTo(
          listOffsetItemHeader[headerNotifier.value!.index+1] - 16,    //<<<-------  HERE
          duration: const Duration(milliseconds: 200),
          curve: goingDown.value ? Curves.bounceOut : Curves.fastOutSlowIn);
    }
  }

  void dispose() {
    scrollControllerGlobally.dispose();
    scrollControllerItemHeader.dispose();
  }

  void _listenToScollChange() {
    globalOffsetValue.value = scrollControllerGlobally.offset;
    if (scrollControllerGlobally.position.userScrollDirection ==
        ScrollDirection.reverse) {
      goingDown.value = true;
    } else {
      goingDown.value = false;
    }
  }

  void refreshHeader(
    int index,
    bool visible, {
    int? lastIndex,
  }) {
    final headerValue = headerNotifier.value;
    final headerTitle = headerValue?.index ?? index;
    final headerVisible = headerValue?.visibile ?? false;

    if (headerTitle != index || lastIndex != null || headerVisible) {
      Future.microtask(() {
        if (!visible && lastIndex != null) {
          headerNotifier.value = MyHeader(
            visibile: true,
            index: lastIndex,
          );
        } else {
          headerNotifier.value = MyHeader(
            visibile: visible,
            index: index,
          );
        }
      });
    }
  }
}
