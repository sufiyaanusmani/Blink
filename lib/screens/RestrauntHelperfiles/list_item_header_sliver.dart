import 'package:flutter/material.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/get_box_offset.dart';
import 'package:food_delivery/screens/RestrauntHelperFiles/controller/sliver_scroll_controller.dart';

class ListItemHeaderSliver extends StatelessWidget {
  const ListItemHeaderSliver({
    Key? key,
    required this.bloc,
  }) : super(key: key);
  final SliverScrollController bloc;

  @override
  Widget build(BuildContext context) {
    final itemsOffset = bloc.listOffsetItemHeader;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: NotificationListener(
        onNotification: (_) => true,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            right: size.width -
                (((itemsOffset[itemsOffset.length - 1]) -
                    itemsOffset[itemsOffset.length - 2])),
          ),
          controller: bloc.scrollControllerItemHeader,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
            valueListenable: bloc.headerNotifier,
            builder: (_, __, ___) {
              return Container(
                child: Row(
                  children: List.generate(bloc.listCategory.length, (index) {
                    return GetBoxOffset(
                      offset: ((offset) => itemsOffset[index] = offset.dx),
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.only(
                          // top: 8,
                          // bottom: 8,
                          right: 8,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 109, 239, 131),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          bloc.listCategory[index].category,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
