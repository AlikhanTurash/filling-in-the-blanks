import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitb_pantry_app/student.dart';
import 'package:fitb_pantry_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'completed.dart';
import 'globals.dart';
import 'order.dart';

void main() {
  runApp(
      MaterialApp(debugShowCheckedModeBanner: false, home: OrderSummaryPage()));
}

List<String> itemList = [];
List<String> imageList = [];
String matchedDocument = '';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  List<String> orderDetails = []; // To store order details

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
    updateValue();
    updateValue2();
    getImages(); // Fetch order details when the page is initialized
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
              image: AssetImage('assets/images/fitb.png'),
            ),
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 6, // Number of columns in the grid view
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                shrinkWrap: true,
                itemCount: orderDetails.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          child: Image.network(
                            itemList[index],
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit
                                .cover, // Adjusts the image to fit within the container
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          orderDetails[index],
                          style: TextStyle(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CompletePage()));
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
            const SizedBox(height: 50),
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

      List<String> detailsList = []; // Store the order details

      querySnapshot.docs.forEach((doc) {
        String studentId = doc['studentId'];
        print(studentId);
        print(globaldocumentid);
        String idCheck = studentId;

        if (studentId.isNotEmpty) {
          if (idCheck == globaldocumentid) {
            matchedDocument = doc.id;
            String details = '';
            doc['items'].forEach((item) {
              details =
                  'Item: ${item['itemId']}\n Quantity: ${item['quantity']}\n';
              detailsList.add(details);
              String itemName = item['itemId'];
              itemList.add(itemName);
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

  Future<Map<dynamic, List<Item>>> getImages() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Items').get();
    final Map<dynamic, List<Item>> lists = {};

    querySnapshot.docs.forEach((doc) {
      final itemImage = doc['image'];
      final itemId = doc['id'];
      final itemGrouping = doc['group'];

      if (querySnapshot.docs.isNotEmpty) {
        for (var i in itemList) {
          if (i = itemId) {
            imageList.add(itemImage);
            print(itemImage);
          }
        }
      }
    });

    return lists;
  }

  Future<void> updateValue() async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Student').doc(globalDocumentId);

    // Get the current value from Firestore
    DocumentSnapshot snapshot = await documentReference.get();
    int currentValue = snapshot['isValidStudent'];

    // Increment the value by one
    int newValue = currentValue + 1;

    // Update the value in Firestore
    await documentReference.update({'isValidStudent': newValue});
  }

  Future<void> updateValue2() async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Orders').doc(matchedDocument);

    // Get the current value from Firestore
    DocumentSnapshot snapshot = await documentReference.get();
    int currentValue = snapshot['isValidOrder'];

    // Increment the value by one
    int newValue = currentValue + 1;

    // Update the value in Firestore
    await documentReference.update({'isValidOrder': newValue});
  }
}
