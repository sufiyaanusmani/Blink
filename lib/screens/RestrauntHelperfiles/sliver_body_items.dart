import 'package:flutter/material.dart';
import 'package:food_delivery/screens/RestrauntHelperfiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperfiles/model/product_category.dart';
import 'package:food_delivery/classes/cart.dart';

import '../../classes/product.dart';

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

class SliverBodyItems extends StatelessWidget {
  const SliverBodyItems({Key? key, required this.listItem}) : super(key: key);

  final List<Product> listItem;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = listItem[index];
          return InkWell(
            onTap: () {
              Cart.addNewProduct(product);
              print('pressed ${product.name}');
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "this is a description",
                                  maxLines: 4,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Rs ${product.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                    "images/kfc.jpg",
                                  ),
                                ),
                              ),
                              height: 140,
                              width: 130,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 35,
                                height: 35,
                                margin: EdgeInsets.only(top: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(171, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(
                                          0.5), // Color of the shadow
                                      spreadRadius: 5, // Spread radius
                                      blurRadius: 7, // Blur radius
                                      offset:
                                          Offset(0, 3), // Offset of the shadow
                                    ),
                                  ],
                                ),
                                child: InkWell(
                                  onTap: () {
                                    print("product: ${product.name} Liked");
                                  },
                                  child: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  if (index == listItem.length - 1) ...[
                    const SizedBox(height: 32),
                    Container(
                      height: .5,
                      color: Colors.white.withOpacity(.3),
                    ),
                  ],
                  Divider(),
                ],
              ),
            ),
          );
        },
        childCount: listItem.length,
      ),
    );
  }
}
