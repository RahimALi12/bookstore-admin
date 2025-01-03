import 'package:adminpanel/controller/productcontroller.dart';
import 'package:adminpanel/views/displaycatscreen.dart';
import 'package:adminpanel/views/displayproductscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

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
    final con = Get.put(ProductControlller());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductListPage(catname: catname),
    );
  }
}
