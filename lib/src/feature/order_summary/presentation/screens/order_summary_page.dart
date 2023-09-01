import 'package:auto_route/auto_route.dart';
import 'package:fitb_pantry_app/completed.dart';
import 'package:fitb_pantry_app/src/feature/order/data/model/product_model.dart';
import 'package:flutter/material.dart';

@RoutePage()
class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({
    super.key,
    required this.listOfProducts,
  });

  final List<ProductModel> listOfProducts;

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(
              width: double.infinity,
              height: 100,
            ),
            const Image(
              image: AssetImage('assets/images/fitb.png'),
            ),
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 6, // Number of columns in the grid view
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: widget.listOfProducts.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            widget.listOfProducts[index].image!,
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit
                                .cover, // Adjusts the image to fit within the container
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          widget.listOfProducts[index].group!,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompletePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0.0,
              ).copyWith(
                elevation: ButtonStyleButton.allOrNull(0.0),
              ),
              child: Container(
                height: 80,
                width: 400,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Confirm Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
