import 'package:flutter/material.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickqueue/services/customerServices.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  Timer.periodic(Duration(hours: 24), (timer){
    final customerService = CustomerServices();
    customerService.updateExpiredCoupons();
  });
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
