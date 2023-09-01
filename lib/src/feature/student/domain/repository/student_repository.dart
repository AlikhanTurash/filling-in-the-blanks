import 'package:fitb_pantry_app/order.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/feature/student/domain/usecases/is_valid_to_day_order.dart';
import 'package:fitb_pantry_app/src/feature/student/domain/usecases/proces_and_navigate_uc.dart';
import 'package:fitb_pantry_app/src/feature/student/presentation/utils/snack_bar.dart';
import 'package:flutter/material.dart';

abstract class StudentRepository {
  Future<void> handleStartOrder(
      GlobalKey<FormState> numberForm,
      TextEditingController controllerPhone,
      TextEditingController controllerEmail,
      TextEditingController controllerFirst,
      TextEditingController controllerLast,
      TextEditingController controllerSchool,
      BuildContext context,
      String selectedSchool,
      Function setState,
      Function showSnackBar);
}

class StudentRemoteRepositoryImpl extends StudentRepository {
  @override
  Future<void> handleStartOrder(
      GlobalKey<FormState> numberForm,
      TextEditingController controllerPhone,
      TextEditingController controllerEmail,
      TextEditingController controllerFirst,
      TextEditingController controllerLast,
      TextEditingController controllerSchool,
      BuildContext context,
      String selectedSchool,
      Function setState,
      Function showSnackBar) async {
    final addStudentUseCase = sl<AddStudentUC>();
    final isTodayValidOrderDayUseCase = sl<IsTodayValidOrderDayUC>();
    bool isFormEnabled = await isTodayValidOrderDayUseCase.call(selectedSchool);

    if (isFormEnabled) {
      if (numberForm.currentState!.validate()) {
        // Create the data map to pass
        Map<String, dynamic> dataToSave = {
          'phone number': controllerPhone.text,
          'email': controllerEmail.text,
          'first name': controllerFirst.text,
          'last name': controllerLast.text,
          'school': controllerSchool.text,
          'isValidStudent': 0,
        };

        try {
          // Replace the following with your UseCase or ViewModel method.
          await isTodayValidOrderDayUseCase.call(dataToSave.toString());
        } catch (e) {
          // Handle the exception by showing a snackbar or something similar.
          showSnackBar(context, 'An error occurred: $e', Colors.red);
          return;
        }

        // Navigate to the next page, if necessary.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPage(),
          ),
        );

        // Update any state, if necessary
        setState(() {
          // Your state changes go here
        });
      } else {
        // If the form is not valid, show a snackbar.
        showSnackBar(
            context, 'Please complete the form correctly.', Colors.red);
      }
    } else {
      // If the school is not valid for ordering, show a snackbar.
      showSnackBar(context,
          'Sorry, you cannot order from your school at this time', Colors.red);
    }
  }
}
