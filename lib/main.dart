import 'package:adminpanel/views/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
// import 'views/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/admin',
      getPages: [
        // Define all the routes here
        // GetPage(
        //   name: '/login',
        //   page: () => AdminLoginScreen(),
        // ),
        GetPage(
          name: '/admin',
          page: () => MainScreen(),
        ),
      ],
    );
  }
}
