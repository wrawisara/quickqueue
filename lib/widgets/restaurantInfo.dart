import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/restaurantList.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/model/tableInfo.dart';

class RestaurantInfo extends StatefulWidget {
  //final Restaurant restaurant = Restaurant.generateRestaurant();
  //final TableInfo tableInfo = TableInfo.generateTableInfo();
  num capacity = 0;
  String resName = 'name';
  String branch = 'branch';
  String status = 'closed';
  String resLogo = 'default';

  RestaurantInfo(this.resName, this.capacity, this.branch, this.status, this.resLogo);

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
                    widget.resName,
                    //widget.restaurant.restaurantName,
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
                      widget.branch,
                      //widget.restaurant.branch,
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.capacity.toString() + " tables",
                        //widget.tableInfo.total_capacity.toString() + " tables",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            widget.status,
                            style: TextStyle(
                                color: Colors.cyan.shade800, fontSize: 12),
                          ))
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: ClipRect(
                      child: Image.network(
                        widget.resLogo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
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
