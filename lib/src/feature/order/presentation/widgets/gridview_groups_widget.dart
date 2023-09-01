import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';

class GridviewGroupsWidget extends StatelessWidget {
  const GridviewGroupsWidget({
    super.key,
    required this.items,
  });

  final List<ProductModel> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .80,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ItemCardWidget(
            order: items,
            item: items[index],
          ),
        );
      },
    );
  }
}
