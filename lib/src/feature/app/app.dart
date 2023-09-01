import 'package:fitb_pantry_app/src/feature/app/route/app_router.dart';
import 'package:fitb_pantry_app/src/ui_component/theme/app_colors.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final routerConfig = AppRouter();
    return MaterialApp.router(
      routerConfig: routerConfig.config(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
    );
  }
}
