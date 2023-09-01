import 'package:fitb_pantry_app/src/feature/order/data/model/product_model.dart';
import 'package:flutter/material.dart';

class ItemCardWidget extends StatefulWidget {
  ItemCardWidget({
    super.key,
    required this.order,
    required this.item,
    required this.onSelected,
    required this.onUnselected,
    required this.isSelected,
  });

  final List<ProductModel> order;
  final ProductModel item;
  final Function() onSelected;
  final Function() onUnselected;
  bool isSelected;

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
        onTap: () {
          widget.isSelected = !widget.isSelected;
          print(widget.isSelected);
          setState(() {});
          widget.isSelected ? widget.onSelected() : widget.onUnselected();
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isSelected ? Colors.green : Colors.blueGrey,
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
                    color: widget.isSelected ? Colors.green : Colors.blueGrey,
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
