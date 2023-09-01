import 'order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter/services.dart';
// Import the globals file

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Student()));
}

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

String globalDocumentId = '';
int weekdaysValue = DateTime.now().weekday;
//CollectionReference collection =
//  FirebaseFirestore.instance.collection('School');
Timestamp timestamp = Timestamp.fromDate(DateTime(weekdaysValue));
final DateTime now = DateTime.now();
final builder1 = ValidationBuilder().phone();
DateTime? closeDate;
final builder2 = ValidationBuilder().email();
final TextInputFormatter digitsOnly =
    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'));
var _numberForm = GlobalKey<FormState>();
bool isValidForm = false;
var selectedSchool1;
TextEditingController _controllerPhone = TextEditingController();
TextEditingController _controllerEmail = TextEditingController();
TextEditingController _controllerFirst = TextEditingController();
TextEditingController _controllerLast = TextEditingController();
TextEditingController _controllerSchool = TextEditingController();

class _StudentState extends State<Student> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: double.infinity, height: 100),
          const Image(
            image: AssetImage('assets/images/fitb.png'),
          ),
          Column(
            children: [
              Form(
                key: _numberForm,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _controllerPhone,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                        ),
                        hintText: 'Phone Number',
                        constraints:
                            const BoxConstraints(maxWidth: 300, minWidth: 300),
                      ),
                      validator: builder1.maxLength(15).build(),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                        ),
                        hintText: "Email",
                        constraints:
                            const BoxConstraints(maxWidth: 300, minWidth: 300),
                      ),
                      validator: builder2.maxLength(50).build(),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _controllerFirst,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                        ),
                        hintText: "First Name",
                        constraints:
                            const BoxConstraints(maxWidth: 300, minWidth: 300),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Field can't be empty";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _controllerLast,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 20,
                        ),
                        hintText: "Last Name",
                        constraints:
                            const BoxConstraints(maxWidth: 300, minWidth: 300),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))
                      ],
                      validator: (String? value) {
                        if (value != null && value.isEmpty) {
                          return "Field can't be empty";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("School")
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("Loading.....");
                        } else {
                          List<DropdownMenuItem> listOfSchools = [];
                          for (int i = 0; i < snapshot.data.docs.length; i++) {
                            DocumentSnapshot snap = snapshot.data.docs[i];
                            listOfSchools.add(
                              DropdownMenuItem(
                                child: Text(
                                  snap.id,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                                value: snap.id,
                              ),
                            );
                          }
                          return Column(
                            children: [
                              SizedBox(
                                width: 300,
                                child: DropdownButtonFormField(
                                  items: listOfSchools,
                                  onChanged: (schoolValue) {
                                    setState(() {
                                      selectedSchool1 = schoolValue;
                                      _controllerSchool.text = schoolValue;
                                    });
                                  },
                                  value: selectedSchool1,
                                  isExpanded: false,
                                  hint: Text(
                                    "Select your school",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 20,
                                    ),
                                  ),
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 16,
                                ),
                              ),
                              const SizedBox(height: 75),
                              ElevatedButton(
                                onPressed: () async {
                                  bool isFormEnabled =
                                      await isTodayValidOrderDay(
                                          selectedSchool1);

                                  if (isFormEnabled) {
                                    if (_numberForm.currentState!.validate()) {
                                      setState(() {
                                        isValidForm = true;
                                      });
                                      Map<String, dynamic> dataToSave = {
                                        'phone number': _controllerPhone.text,
                                        'email': _controllerEmail.text,
                                        'first name': _controllerFirst.text,
                                        'last name': _controllerLast.text,
                                        'school': _controllerSchool.text,
                                        'isValidStudent': 0,
                                      };
                                      CollectionReference collectionRef =
                                          FirebaseFirestore.instance
                                              .collection('Student');

                                      // Add the data and get the DocumentReference
                                      DocumentReference docRef =
                                          await collectionRef.add(dataToSave);

                                      setState(() {
                                        globalDocumentId = docRef.id;
                                      });
                                      // Get the ID of the newly added document

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderPage(), // Pass the document ID
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        isValidForm = false;
                                      });
                                    }
                                  } else {
                                    const snackBar = SnackBar(
                                      content: Text(
                                        'Sorry, you cannot order from your school at this time',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Colors.red,
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shadowColor: Colors.transparent,
                                  elevation: 0.0,
                                ).copyWith(
                                    elevation:
                                        ButtonStyleButton.allOrNull(0.0)),
                                child: Container(
                                  height: 80,
                                  width: 300,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Start Order',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  Future<bool> isTodayValidOrderDay(String selectedSchool) async {
    try {
      // Retrieve the information for the school
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('School')
          .doc(selectedSchool)
          .get();

      // If the school is not active, return false

      // Check if the day is in the range
      if (documentSnapshot.exists) {
        bool isSchoolActive = documentSnapshot['is active'];
        int weekdayValue = DateTime.now().weekday;
        int openDate = documentSnapshot['open date'].toInt();
        int closeDate = documentSnapshot['close date'].toInt();
        if (isSchoolActive == true) {
          if (openDate <= closeDate) {
            return openDate <= weekdayValue && weekdayValue <= closeDate;
          } else {
            return weekdayValue >= openDate || weekdayValue <= closeDate;
          }
        } else {
          return false;
        }
      }

      return false;
    } catch (e) {
      print('Error fetching weekdays from Firestore: $e');
      return false;
    }
  }
}
