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

//เกือบเป็นรูปร่าง
// Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         height: 200,
//                         width: 380,
//                         child: Card(
//                           semanticContainer: true,
//                           clipBehavior: Clip.antiAliasWithSaveLayer,
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 children: [
//                                   Image.asset(
//                                     booking.img,
//                                     scale: 2.7,
//                                     fit: BoxFit.fitHeight,
//                                   ),
                                  
//                                 ],
//                               ),
                              
//                             ],
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(3.0),
//                           ),
//                           elevation: 1,
//                           margin: EdgeInsets.all(5),
//                         ),
//                       ),
//                     ],
//                   ),