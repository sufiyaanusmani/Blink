import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

import 'package:food_delivery/screens/RestrauntHelperfiles/model/my_header.dart';
// import 'package:food_delivery/screens/RestrauntHelperfiles/model/product_category.dart';

import '../../../classes/category.dart';
import '../../../classes/product.dart';

// class ProductCategory {
//   ProductCategory({
//     required this.category,
//     required this.products,
//   });

//   final String category;
//   final List<Product2> products;
// }

// class Product2 {
//   final String name;
//   final String description;
//   final String price;
//   final String image;

//   Product2({
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image,
//   });
// }

class SliverScrollController {
  late List<Category> listCategory = [];

  SliverScrollController(List<Product> items1) {
    List<Category> temp = [];
    for (Product item in items1) {
      bool found = false;
      for (int i = 0; i < temp.length; i++) {
        if (item.categoryID == temp[i].id) {
          temp[i].products.add(item);
          found = true;
        }
      }
      if (found == false) {
        temp.add(Category(id: item.categoryID, name: item.categoryName));
        temp[temp.length - 1].products.add(item);
      }

      listCategory = temp;
    }
  }

  List<double> listOffsetItemHeader = [];

  final headerNotifier = ValueNotifier<MyHeader?>(null);

  final globalOffsetValue = ValueNotifier<double>(0);

  final goingDown = ValueNotifier<bool>(false);

  final valueScroll = ValueNotifier<double>(0);

  late ScrollController scrollControllerItemHeader;

  late ScrollController scrollControllerGlobally;

  final visibleHeader = ValueNotifier(false);

  // final products = [
  //   Product2(
  //     name: 'Choclate Cake',
  //     image: 'assets/icons/cancel.png',
  //     description: 'hai,.,,,,.......................................',
  //     price: '\$19',
  //   ),
  //   Product2(
  //     name: 'Choclate Cake',
  //     image: 'assets/icons/cancel.png',
  //     description: 'hai,.,,,,.......................................',
  //     price: '\$19',
  //   ),
  //   Product2(
  //     name: 'Choclate Cake',
  //     image: 'assets/icons/cancel.png',
  //     description: 'hai,.,,,,.......................................',
  //     price: '\$19',
  //   ),
  //   Product2(
  //     name: 'Choclate Cake',
  //     image: 'assets/icons/cancel.png',
  //     description: 'hai,.,,,,.......................................',
  //     price: '\$19',
  //   ),
  // ];

  void loadDataRandom(List<Product> itemList) {
    // List<Category> temp = [];
    // for (Product item in itemList) {
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
    // listCategory = temp;
  }

  void init() {
    // loadDataRandom();
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
          listOffsetItemHeader[headerNotifier.value!.index] -
              16, //<<<-------  HERE
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
