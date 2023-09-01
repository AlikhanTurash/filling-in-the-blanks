import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef String? ValidatorFunc(String);

class TextInputWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final ValidatorFunc validator;
  final TextInputFormatter? inputFormatter;
  const TextInputWidget({
    Key? key,
    this.inputFormatter,
    required this.textEditingController,
    required this.hintText,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 20,
        ),
        constraints:const BoxConstraints(maxWidth: 300, minWidth: 300),
      ),
      validator: validator,
    );
  }
}
