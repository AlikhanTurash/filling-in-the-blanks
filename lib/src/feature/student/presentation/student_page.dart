import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/feature/order/presentation/screens/order_screen.dart';
import 'package:fitb_pantry_app/src/feature/student/domain/usecases/is_valid_to_day_order.dart';
import 'package:fitb_pantry_app/src/feature/student/presentation/utils/snack_bar.dart';
import 'package:fitb_pantry_app/src/feature/student/presentation/widgets/custom_button.dart';
import 'package:fitb_pantry_app/src/feature/student/presentation/widgets/text_input_widget.dart';
import 'package:fitb_pantry_app/src/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

String globalDocumentId = '';
int weekdaysValue = DateTime.now().weekday;
//CollectionReference collection =
//  FirebaseFirestore.instance.collection('School');
Timestamp timestamp = Timestamp.fromDate(DateTime(weekdaysValue));
final DateTime now = DateTime.now();
DateTime? closeDate;
var _numberForm = GlobalKey<FormState>();
bool isValidForm = false;
var selectedSchoolOne;
TextEditingController _controllerPhone = TextEditingController();
TextEditingController _controllerEmail = TextEditingController();
TextEditingController _controllerFirst = TextEditingController();
TextEditingController _controllerLast = TextEditingController();
TextEditingController _controllerSchool = TextEditingController();

final isTodayValidOrderDayUseCase = sl<IsTodayValidOrderDayUC>();

class _StudentPageState extends State<StudentPage> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(width: double.infinity, height: 100),
          Image(
            image: AssetImage(Assets.images.fitb.path),
          ),
          Column(
            children: [
              Form(
                key: _numberForm,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    TextInputWidget(
                      textEditingController: _controllerPhone,
                      hintText: 'Phone',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        final phoneRegExp = RegExp(r'^\+?[1-9]\d{1,14}$');
                        if (!phoneRegExp.hasMatch(value)) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextInputWidget(
                      textEditingController: _controllerEmail,
                      hintText: "Email",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!EmailValidator.validate(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextInputWidget(
                        inputFormatter: FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z]')),
                        textEditingController: _controllerFirst,
                        hintText: 'First Name',
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Field can't be empty";
                          }

                          return null;
                        }),
                    const SizedBox(height: 15),
                    TextInputWidget(
                      textEditingController: _controllerLast,
                      inputFormatter:
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return "Field can't be empty";
                        }

                        return null;
                      },
                      hintText: 'Last Name',
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
                                value: snap.id,
                                child: Text(
                                  snap.id,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
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
                                      selectedSchoolOne = schoolValue;
                                      _controllerSchool.text = schoolValue;
                                    });
                                  },
                                  value: selectedSchoolOne,
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
                              CustomElevatedButton(
                                onPressed: () async {
                                  bool isFormEnabled =
                                      await isTodayValidOrderDayUseCase(
                                          selectedSchoolOne);

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
                                              const OrderPage(),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        isValidForm = false;
                                      });
                                    }
                                  } else {
                                    StudentUtils().showSnackBar(
                                      context,
                                      'Sorry, you cannot order from your school at this time',
                                      Colors.red,
                                    );
                                  }
                                },
                                text: 'Get Started',
                              )
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
}
