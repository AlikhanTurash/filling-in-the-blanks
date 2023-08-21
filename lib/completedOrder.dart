import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/student.dart';
import 'package:fitb_pantry_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart';
import 'order.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false, home: CompletedOrderPage()));
}

class CompletedOrderPage extends StatefulWidget {
  const CompletedOrderPage({super.key});

  @override
  State<CompletedOrderPage> createState() => _CompletedOrderPageState();
}

class _CompletedOrderPageState extends State<CompletedOrderPage> {
  String orderDetails = ''; // To store order details

  @override
  void initState() {
    super.initState();
    fetchOrderDetails(); // Fetch order details when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: double.infinity, height: 100),
            const Image(
              image: AssetImage('assets/fitb.png'),
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid view
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              shrinkWrap: true,
              itemCount: orderDetails.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    orderDetails[index],
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
            const SizedBox(height: 460),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompletedOrderPage()));
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
                  'Confirm Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchOrderDetails() async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('Orders');
      // Access the collection where your data is stored

      // Retrieve all documents within the collection
      QuerySnapshot querySnapshot = await collectionRef.get();

      String detailsList = ''; // Store the order details

      querySnapshot.docs.forEach((doc) {
        String studentId = doc['studentId'];
        print(studentId);
        print(globaldocumentid);

        if (studentId.isNotEmpty) {
          if (studentId == globaldocumentid) {
            String details = '';
            doc['items'].forEach((item) {
              details +=
                  'Item: ${item['itemId']}, Quantity: ${item['quantity']}\n';
            });
          }
        }
      });

      setState(() {
        orderDetails = detailsList;
      });
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }
}
