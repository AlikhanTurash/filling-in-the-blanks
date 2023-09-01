import 'package:firebase_core/firebase_core.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/core/widgets/buttons/app_button.dart';
import 'package:fitb_pantry_app/src/feature/app/app.dart';
import 'package:fitb_pantry_app/src/feature/app/route/app_router.dart';
import 'package:fitb_pantry_app/src/feature/onboarding/onboarding_screen_animation.dart';
import 'package:fitb_pantry_app/src/ui_component/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
    AppRouter _appRouter = AppRouter();            

  await initLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    App()
  );
}

