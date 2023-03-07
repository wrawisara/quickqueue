import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ResManageQueue extends StatefulWidget {
  const ResManageQueue({super.key});

  @override
  State<ResManageQueue> createState() => _ResManageQueueState();
}

class _ResManageQueueState extends State<ResManageQueue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false, 
        iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Reservation",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
  }
}