import 'package:flutter/material.dart';
import 'package:food_delivery/screens/RestrauntHelperfiles/controller/sliver_scroll_controller.dart';
import 'package:food_delivery/screens/RestrauntHelperfiles/model/product_category.dart';

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

  final List<Product2> listItem;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = listItem[index];
          return InkWell(
            onTap: () {
              print("Item  ${index} added to cart");
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
                                  product.description,
                                  maxLines: 4,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.price,
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
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                product.image,
                              ),
                            ),
                          ),
                          height: 140,
                          width: 130,
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
