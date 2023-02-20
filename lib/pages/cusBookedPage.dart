import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CusBookedPage extends StatelessWidget {
  const CusBookedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white,
          ),
        title: Text("Booked", style: TextStyle(color: Colors.white),),
      ),
    );
  }
}