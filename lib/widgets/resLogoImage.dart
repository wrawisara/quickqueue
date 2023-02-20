import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/allRestaurant.dart';

class resLogoImage extends StatelessWidget {
  final AllRestaurant restaurant;
  resLogoImage(this.restaurant);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Restaurant Logo Image'),
    );
  }
}