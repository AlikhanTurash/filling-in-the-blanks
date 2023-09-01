import 'package:concentric_transition/page_view.dart';
import 'package:fitb_pantry_app/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../ui_component/theme/app_colors.dart';

class OnboardingScreenAnimation extends StatefulWidget {
  const OnboardingScreenAnimation({super.key});

  @override
  State<OnboardingScreenAnimation> createState() =>
      _OnboardingScreenAnimationState();
}

class _OnboardingScreenAnimationState extends State<OnboardingScreenAnimation> {
  final List<String> _instructonImages = [
    "first_onboarding",
    "second_onboarding",
    "third_onboarding",
    "fourth_onboarding",
    "fifth_onboarding",
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> instructionTexts = [
      "Welcome to the\nFilling in the blanks app!\n\nWith this app you can provide\nyour child a weekend meal.",
      "You should register in the\napp with your phone number\nor email to get started.",
      "After the registration you can\nchoose what food fill be\nin your order.",
      "Then just save the cart\nand enjoy!",
      "Let's start!",
    ];
    return Stack(
      alignment: Alignment.center,
      children: [
        Scaffold(
          body: ConcentricPageView(
            nextButtonBuilder: (BuildContext context) {
              return const Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(
                  CupertinoIcons.arrow_right,
                  weight: 30,
                ),
              );
            },
            radius: 30,
            verticalPosition: 0.85,
            itemCount: _instructonImages.length,
            colors: const [
              AppColors.backgroundColor,
              AppColors.blueButton,
              AppColors.backgroundColor,
              AppColors.blueButton,
              Color.fromARGB(255, 192, 238, 139),
            ],
            itemBuilder: (index) {
              int pageIndex = (index % _instructonImages.length);
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      "assets/images/${_instructonImages[pageIndex]}.png",
                      width: 300,
                      height: 250,
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(
                      instructionTexts[pageIndex].toUpperCase(),
                      style: TextStyle(
                        color: pageIndex % 2 == 0 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    Text(
                      '${pageIndex + 1}/5',
                      style: TextStyle(
                        color: pageIndex % 2 == 0 ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 30,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            },
            onFinish: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Student(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
