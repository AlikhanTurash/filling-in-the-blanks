import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:flutter/material.dart';

class ItemCardWidget extends StatefulWidget {
  const ItemCardWidget({
    super.key,
    required this.order,
    required this.item,
  });

  final List<ProductModel> order;
  final ProductModel item;

  @override
  State<ItemCardWidget> createState() => _ItemCardWidgetState();
}

class _ItemCardWidgetState extends State<ItemCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            if (widget.order
                    .indexWhere((element) => element.id == widget.item.id) >=
                0) {
              // if already in order
              widget.order
                  .removeWhere((element) => element.id == widget.item.id);
            } else {
              widget.order.add(widget.item);
            }
            print(
                'Item card checked: ${widget.item.id}, cardIsChecked: ${widget.item}');
          });
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (widget.order.isNotEmpty &&
                      (widget.order.indexWhere(
                              (element) => element.id == widget.item.id) >=
                          0))
                  ? Colors.green
                  : Colors.blueGrey,
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              Image.network(
                widget.item.image ?? '',
                alignment: Alignment.bottomCenter,
                fit: BoxFit
                    .cover, // Adjusts the image to fit within the container
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  constraints: const BoxConstraints.expand(
                    height: 85,
                  ),
                  decoration: BoxDecoration(
                    color: (widget.order.isNotEmpty &&
                            (widget.order.indexWhere((element) =>
                                    element.id == widget.item.id) >=
                                0))
                        ? Colors.green
                        : Colors.blueGrey,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          widget.item.id ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            size: 25.0, // You can adjust the size as needed
                            color: Colors
                                .white, // You can adjust the color as needed
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
