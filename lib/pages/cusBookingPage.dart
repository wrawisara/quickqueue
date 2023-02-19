import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';

class CusBookingPage extends StatefulWidget {
  const CusBookingPage({super.key});

  @override
  State<CusBookingPage> createState() => _CusBookingPageState();
}

class _CusBookingPageState extends State<CusBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              width: double.maxFinite,)
          )
        ],
      ),
    );
  }
}