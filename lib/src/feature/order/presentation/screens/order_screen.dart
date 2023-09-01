import 'package:fitb_pantry_app/src/feature/order/data/models/product_repository.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/bloc/order_bloc.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/widgets/item_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<ProductModel> cart = [];
  String selectedGroup = 'snacks';
  List<String> groups = [];
  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(
      const OrderEvent.getProductsEvent(),
    );
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
                      result.add(
                        listOfProducts[i],
                      );
                    }
                  }
                  return result;
                }

                groups = groups.toSet().toList();
                List<ProductModel> selectedProducts =
                    filter(listOfProducts: lists, group: selectedGroup);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      height: 50,
                    ),
                    const Image(
                      image: AssetImage('assets/images/fitb.png'),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: groups.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: ChoiceChip(
                            label: Text(
                              groups[index],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onSelected: (isSelected) {
                              selectedGroup = groups[index];
                              setState(() {});
                            },
                            selected: selectedGroup == groups[index],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: .80,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedProducts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ItemCardWidget(
                            onSelected: () {
                              cart.add(
                                selectedProducts[index],
                              );
                            },
                            onUnselected: () {
                              cart.remove(
                                selectedProducts[index],
                              );
                            },
                            order: selectedProducts,
                            item: selectedProducts[index],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {},
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
