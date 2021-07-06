import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/HomePage.dart';
import 'Screens/ImageCaptureScreen.dart';
import 'Screens/Inventory.dart';
import 'Screens/editProduct.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static final String title = 'Google SignIn';

  @override
  Widget build(BuildContext context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: title,
          theme: ThemeData(primarySwatch: Colors.deepOrange),
          home: HomePage(),
          routes: {
            ImageCaptureForShop.routeName: (context) => ImageCaptureForShop(),
            Inventory.routeName: (context) => Inventory(),
            AddProductNormally.routeName: (context) => AddProductNormally()
          });
}
