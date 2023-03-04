import 'package:flutter/material.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/pages/resMainpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Quick Queue",
      theme: ThemeData(
        fontFamily: "Metropolis",
        primarySwatch: Colors.cyan),
        home: LoginPage(),
    );
  }
}