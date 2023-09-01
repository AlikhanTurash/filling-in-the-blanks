import 'package:firebase_core/firebase_core.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:fitb_pantry_app/src/feature/app/app.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await initLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
