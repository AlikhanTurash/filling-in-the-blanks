import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/data/repositories/get_products_repositroy.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/bloc/order_bloc.dart';
import 'package:fitb_pantry_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l/l.dart';
import '../../../../../student.dart'; // Import the globals file
import '../../../../../orderSummary.dart';

class Item {
  final String id;
  final String image;
  final String grouping;
  int cardIsChecked;

  Item(
    this.id,
    this.image,
    this.grouping,
    this.cardIsChecked,
  );
}

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<String> groupNames = [];
  List<int> totalLimits = [];
  List<int> eachLimits = [];
  List<String> groupDirections = [];
  int listlength = 0;
  List<ProductModel> order = [];

  String selectedGroup = 'snacks';
  List<String> groups = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(
      const OrderEvent.getProductsEvent(),
    );
    // createLists();
    getDirections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, state) {
            return state.when(
              error: (errorText) => Center(
                child: Text(errorText),
              ),
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              success: (List<ProductModel> lists) {
                for (int i = 0; i < lists.length; i++) {
                  groups.add(lists[i].group!);
                }
                List<ProductModel> filter(
                    {required List<ProductModel> listOfProducts,
                    required String group}) {
                  List<ProductModel> result = [];
                  for (int i = 0; i < listOfProducts.length; i++) {
                    if (listOfProducts[i].group == group) {
                      result.add(listOfProducts[i]);
                    }
                  }
                  return result;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: double.infinity, height: 50),
                    const Image(
                      image: AssetImage('assets/images/fitb.png'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: groupNames.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: ChoiceChip(
                            label: Text(
                              groupNames[index],
                            ),
                            onSelected: (isSelected) {},
                            selected: false,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return displayGroups(
                          filter(
                            listOfProducts: lists,
                            group: selectedGroup,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        // if (order.isNotEmpty) {
                        //   try {
                        //     // Create a reference to the cart items collection
                        //     CollectionReference studentOrders =
                        //         FirebaseFirestore.instance.collection('Orders');

                        //     // Prepare the data to save
                        //     Map<String, dynamic> dataToSave = {
                        //       'items': order
                        //           .map((item) => {'itemId': item.id, 'quantity': 1})
                        //           .toList(),
                        //       'timestamp': FieldValue.serverTimestamp(),
                        //       'studentId': globalDocumentId,
                        //       'isValidOrder': 0,
                        //     };x

                        //     if (globalDocumentId.isNotEmpty) {
                        //       // Save the data to the cart items collection
                        //       await studentOrders.add(dataToSave);
                        //       print('Items added to cart in Firestore.');

                        //       // Clear the selectedItems list after saving
                        //       order.clear();

                        //       // Navigate to the OrderPage
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const OrderSummaryPage()),
                        //       );
                        //     } else {
                        //       print('Error find student information in Firestore');
                        //     }
                        //   } catch (e) {
                        //     print('Error adding items to cart in Firestore: $e');
                        //   }
                        // } else {
                        //   // Show a message if no items are selected
                        //   const snackBar = SnackBar(
                        //     content: Text(
                        //       'No items selected',
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //       ),
                        //     ),
                        //     backgroundColor: Colors.red,
                        //   );
                        //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0.0,
                      ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                      child: Container(
                        height: 80,
                        width: 400,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget itemCard(ProductModel item) {
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: GestureDetector(
        onTap: () async {
          setState(() {
            if (order.indexWhere((element) => element.id == item.id) >= 0) {
              // if already in order
              order.removeWhere((element) => element.id == item.id);
            } else {
              order.add(item);
            }
            print('Item card checked: ${item.id}, cardIsChecked: ${item}');
          });
        },
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (!order.isEmpty &&
                      (order.indexWhere((element) => element.id == item.id) >=
                          0))
                  ? Colors.green
                  : Colors.blueGrey,
              width: 3,
            ),
          ),
          child: Stack(
            children: [
              Image.network(
                item.image ?? '',
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
                    color: (!order.isEmpty &&
                            (order.indexWhere(
                                    (element) => element.id == item.id) >=
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
                          item.id ?? '',
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

  Widget displayGroups(List<ProductModel> items) {
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
          child: itemCard(items[index]),
        );
      },
    );
  }

  Future<void> getDirections() async {
    try {
      CollectionReference innerCollectionRef2 =
          FirebaseFirestore.instance.collection('Groups');

      QuerySnapshot querySnapshot2 = await innerCollectionRef2.get();

      if (querySnapshot2.docs.isNotEmpty) {
        for (var document in querySnapshot2.docs) {
          String directions = document['instructions'];
          String groupName = document['name'];
          int totalLimit = document['totalLimit'];
          int eachLimit = document['eachLimit'];
          setState(() {
            groupDirections.add(directions);
            groupNames.add(groupName);
            eachLimits.add(eachLimit);
            totalLimits.add(totalLimit);
          });
        }
      } else {
        print('No documents found in the collection');
      }
    } catch (e) {
      print('Error fetching information from Firestore: $e');
    }
  }
}

class PopupContent extends StatefulWidget {
  final String itemNameOrder; // Add this line

  PopupContent({required this.itemNameOrder}); // Add this constructor

  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  bool isIconActive = true;
  bool isIconActive2 = true;

  int _quantity = 1;

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

Future<Map<dynamic, List<Item>>> createLists() async {
  final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Items').get();
  final Map<dynamic, List<Item>> lists = {};

  for (var doc in querySnapshot.docs) {
    final itemImage = doc['image'];
    final itemId = doc['id'];
    final itemGrouping = doc['group'];

    if (querySnapshot.docs.isNotEmpty) {
      if (!lists.containsKey(itemGrouping)) {
        lists[itemGrouping] = [];
        // Initialize with false
      }
      var itemIsClicked = 0;
      lists[itemGrouping]
          ?.add(Item(itemId, itemImage, itemGrouping, itemIsClicked));
    }
  }
  print(lists);
  return lists;
}
