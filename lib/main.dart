import 'package:flutter/material.dart';

import './pages/cusChooseResPage.dart';
import './pages/loginPage.dart';

void main() {
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