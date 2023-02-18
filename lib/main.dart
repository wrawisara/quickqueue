import 'package:flutter/material.dart';

import './pages/cusChooseResPage.dart';
import './pages/loginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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