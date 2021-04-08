import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cabdriver/globalvarialbes.dart';
import 'package:cabdriver/screens/login.dart';
import 'package:cabdriver/screens/mainpage.dart';
import 'package:cabdriver/screens/registration.dart';
import 'package:cabdriver/screens/vehicleinfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:962092805796:ios:8e23bfcea97f32bf664031',
      apiKey: 'AIzaSyB6eA2cBITsObg35WaCdlvrxPM0RiBUtM0',
      projectId: 'gtaxi-b9a54',
      messagingSenderId: '962092805796',
      databaseURL: 'https://gtaxi-b9a54-default-rtdb.firebaseio.com',
    )
        : FirebaseOptions(
      appId: '1:962092805796:android:d7efee17fd6e1c77664031',
      apiKey: 'AIzaSyBriaQcD5BVaIoZGg3-sdqZr58MjCsTNhg',
      projectId: 'gtaxi-b9a54',
      messagingSenderId: '962092805796',
      databaseURL: 'https://gtaxi-b9a54-default-rtdb.firebaseio.com',
    ),
  );

  currentFirebaseUser = FirebaseAuth.instance.currentUser;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,
      ),
      initialRoute: (currentFirebaseUser == null) ? LoginPage.id : MainPage.id,
      routes: {
        MainPage.id: (context) => MainPage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        VehicleInfoPage.id: (context) => VehicleInfoPage(),
      }
    );
  }
}
