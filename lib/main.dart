import 'package:firebase_core/firebase_core.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/core/widgets/buttons/app_button.dart';
import 'package:fitb_pantry_app/src/feature/exapmle/presentation/screens/onboarding_screen_animation.dart';
import 'package:fitb_pantry_app/src/ui_component/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await initLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyApp(),
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          const Image(
            image: AssetImage('assets/images/fitb.png'),
          ),
          const SizedBox(height: 30),
          const Text(
            "Food Pantry App",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          Image.asset(
            "assets/images/third_onboarding.png",
            width: 250,
          ),
          const Spacer(flex: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreenAnimation()),
                );
              },
              buttonText: "Get Started",
            ),
          ),
          const SizedBox(
            height: 46,
          ),
        ],
      ),
    );
  }
}
