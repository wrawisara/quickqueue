import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/restaurantList.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/model/tableInfo.dart';

class RestaurantInfo extends StatefulWidget {
  final Restaurant restaurant = Restaurant.generateRestaurant();
  final TableInfo tableInfo = TableInfo.generateTableInfo();
  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 400,
      margin: EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: EdgeInsets.symmetric(horizontal: 35),
      decoration: new BoxDecoration(
        color: Colors.cyan.withOpacity(0.6),
        border: Border.all(color: Colors.white, width: 3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.restaurant.restaurantName,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    Text(
                      widget.restaurant.branch,
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                              widget.tableInfo.total_capacity.toString() +
                                  " tables" ,style:TextStyle(color: Colors.cyan.shade800) ,)
                                  )
                    ],
                  ),
                ],
              ),
              
              Padding(
                padding: const EdgeInsets.only(top:17.0),
                child: ClipRect(
                  child: Image.asset(
                    widget.restaurant.logo,
                    width: 80,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
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