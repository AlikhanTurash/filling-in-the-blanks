import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/styles.dart';
import 'package:flutter/material.dart';

class PopupContent extends StatefulWidget {
  final String itemNameOrder; // Add this line

  const PopupContent(
      {super.key, required this.itemNameOrder}); // Add this constructor

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  bool isIconActive = true;
  bool isIconActive2 = true;

  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height / 2,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(Spacing.matGridUnit()),
            child: const Text(
              "Add item to Cart",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(vertical: Spacing.matGridUnit(scale: 3)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                    iconSize: 40.0,
                    icon: const Icon(Icons.remove_circle),
                    color: isIconActive2 ? Colors.green : Colors.grey,
                    onPressed: () {
                      if (_quantity >= 1) {
                        setState(() {
                          _quantity--;
                          isIconActive2 = true;
                          isIconActive = true; // Set the icon as active
                        });
                      } else {
                        setState(() {
                          isIconActive2 = false;
                        });
                      }
                      if (_quantity <= 0) {
                        isIconActive2 = false;
                      }
                    }),
                Text(
                  _quantity.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                IconButton(
                  iconSize: 40.0,
                  icon: const Icon(Icons.add_circle),
                  color: isIconActive ? Colors.green : Colors.grey,
                  onPressed: () {
                    if (_quantity <= 1) {
                      setState(() {
                        _quantity++;
                        isIconActive2 = true;
                        isIconActive = true; // Set the icon as active
                      });
                    } else {
                      setState(() {
                        isIconActive = false;
                      });
                    }
                    if (_quantity >= 2) {
                      isIconActive = false;
                    }
                  },
                )
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shadowColor: Colors.transparent,
                elevation: 0.0,
              ).copyWith(elevation: MaterialStateProperty.all<double>(0.0)),
              child: Text(
                "Add To Cart".toUpperCase(),
              ),
              onPressed: () async {
                if (_quantity > 0) {
                  // Generate a unique ID for the new order
                  String orderId =
                      FirebaseFirestore.instance.collection('Orders').doc().id;

                  // Create a reference to the new order collection
                  CollectionReference orderCollection =
                      FirebaseFirestore.instance.collection('Orders');

                  // Prepare the data to save
                  Map<String, dynamic> dataToSave = {
                    'item name': widget.itemNameOrder,
                    'quantity': _quantity,
                  };

                  try {
                    // Save the data to the new order collection
                    await orderCollection.add(dataToSave);

                    // Display a success message
                    const snackBar = SnackBar(
                      content: Text(
                        'Item added to cart',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.green,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    // Close the dialog and pass the order ID back to the main screen
                    Navigator.of(context).pop(orderId);
                  } catch (e) {
                    // Display an error message if there was an issue saving the data
                    const snackBar = SnackBar(
                      content: Text(
                        'Error adding item to cart',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  const snackBar = SnackBar(
                    content: Text(
                      'Add more items',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.red,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              })
        ],
      ),
    );
  }
}
