import 'package:flutter/material.dart';

class TooltipSample extends StatelessWidget {
  const TooltipSample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Tooltip(
      richMessage: TextSpan(
        text:
            'Enter a number to indicate the number of tables for each table format.',
        style: TextStyle(color: Colors.red),
      ),
      child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    'Table Type(Max seat)',
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                ),
    );
  }
}
