import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ResMainPage extends StatefulWidget {
  const ResMainPage({super.key});

  @override
  State<ResMainPage> createState() => _ResMainPageState();
}

class _ResMainPageState extends State<ResMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Main Page', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [],
        ));
  }
}
