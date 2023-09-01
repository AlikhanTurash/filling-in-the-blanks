  import 'package:fitb_pantry_app/orderSummary.dart';
import 'package:fitb_pantry_app/order.dart';
import 'package:fitb_pantry_app/src/core/services/di.dart';
import 'package:flutter/material.dart';
import 'student.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async{
  await initLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    home: MyApp()));
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: double.infinity, height: 100),
                 const Image(
                    image: AssetImage('assets/images/fitb.png'),
                  ),
                const SizedBox(height: 460),
                   ElevatedButton(
                     onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context) => Student()));
                       },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.white,
                       shadowColor: Colors.transparent,
                       elevation: 0.0,
                     ).copyWith(elevation:ButtonStyleButton.allOrNull(0.0)),
                     child:Container(
                     height: 80,
                     width: 400,
                     alignment: Alignment.center,
                     decoration: BoxDecoration(
                       color: Colors.blue,
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: const Text(
                       'Get Started',
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 30,
                       ),
                     ),
                   ), ),

              ],
            ),
          ),
    );
  }
}