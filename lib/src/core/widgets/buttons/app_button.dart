import 'package:flutter/material.dart';

import '../../../ui_component/theme/app_colors.dart';
import '../../../ui_component/theme/app_text_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.onTap,
    required this.buttonText,
    super.key,
  });

  final Function()? onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 70,
        width: 390,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: AppColors.blueButton,
          ),
          child: Text(
            buttonText,
            style: AppTextStyles.buttonText.copyWith(
              color: Colors.white,
            ),
          ),
        ),
      );
}
