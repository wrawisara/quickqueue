import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HorizontalLine extends StatelessWidget {
  // const HorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Container(
          height: 1.0,
          width: 370.0,
          color: Colors.cyan,
        ),
      ),
    );
  }
}
