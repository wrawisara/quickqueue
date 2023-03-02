import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/allRestaurant.dart';
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
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.restaurant.restaurantName,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [Text(widget.restaurant.branch),]
                    
                  ),
                  Row(
                    children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(widget.tableInfo.total_capacity.toString()+" tables"))],
                  ),
                ],
              ),
              ClipRect(
                child: Image.asset(widget.restaurant.logo,width: 80,),
              )
            ],
          ),
          
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