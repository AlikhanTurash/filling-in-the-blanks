import 'package:auto_route/auto_route.dart';
import 'package:fitb_pantry_app/src/core/widgets/buttons/app_button.dart';
import 'package:fitb_pantry_app/src/feature/student/presentation/student_page.dart';
import 'package:fitb_pantry_app/student.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentPage(),
                  ),
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
