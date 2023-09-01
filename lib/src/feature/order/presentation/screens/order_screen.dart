import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/bloc/order_bloc.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/widgets/gridview_groups_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    // getDirections();
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
                        return GridviewGroupsWidget(
                          items: filter(
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
}
