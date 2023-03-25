import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/restaurantList.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/model/tableInfo.dart';
import 'package:quickqueue/services/restaurantServices.dart';

class RestaurantInfo extends StatefulWidget {
  final Restaurant restaurant = Restaurant.generateRestaurant();
  final TableInfo tableInfo = TableInfo.generateTableInfo();

  // num capacity = 0;
  // String resName = 'name';
  // String branch = 'branch';
  // String status = 'closed';
  // String resLogo = 'default';
  // RestaurantInfo(this.resName, this.capacity, this.branch, this.status, this.resLogo);

  @override
  State<RestaurantInfo> createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  //เรียกข้อมูลมาใช้
  final RestaurantServices restaurantServices = RestaurantServices();
  late Future<List<Map<String, dynamic>>> _tableDataFuture;
  late Future<List<Map<String, dynamic>>> _restaurantDataFuture;
  var selected = 0;
  late Future<num> _totalCapacityFuture;
  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _tableDataFuture = restaurantServices.getAllTableInfo(currentUser.uid);
      _totalCapacityFuture =
          restaurantServices.getTotalCapacity(currentUser.uid);
      _restaurantDataFuture =
          restaurantServices.getCurrentRestaurants(currentUser.uid);
    }
  }

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
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _restaurantDataFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>>
                    restaurantDataSnapshot) {
              if (restaurantDataSnapshot.hasError) {
                return Center(
                  child: Text('Error fetching data'),
                );
              }

              if (restaurantDataSnapshot.data?.isEmpty ?? true) {
                return Center(
                  child: Text('No restaurants found'),
                );
              }

              if (restaurantDataSnapshot.connectionState ==
                  ConnectionState.waiting) {
                // Show a loading spinner while waiting for the future to complete
                return CircularProgressIndicator();
              }

              List<Map<String, dynamic>> restaurantData =
                  restaurantDataSnapshot.data!;
              return Stack(
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
                            restaurantData[0]['username'],
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
                              restaurantData[0]['branch'],
                              //widget.restaurant.branch,
                              style: TextStyle(color: Colors.white),
                            ),
                          ]),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder<num>(
                              future: _totalCapacityFuture,
                              builder: (context, totalCapacitySnapshot) {
                                if (totalCapacitySnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Show a loading spinner while waiting for the future to complete
                                  return CircularProgressIndicator();
                                }

                                final num? totalCapacity =
                                    totalCapacitySnapshot.data!;

                                if (totalCapacity == null) {
                                  // Show an error message if the data is null
                                  return Text('Total capacity data is null');
                                }
                                return Row(
                                  children: [
                                    Text(
                                      // totalCapacity.toString() + " tables",
                                      totalCapacity.toString() + " tables",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                );
                              }),
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
                                    restaurantData[0]['status'],
                                    style: TextStyle(
                                        color: Colors.cyan.shade800,
                                        fontSize: 12),
                                  ))
                            ],
                          ),
                        ],
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: ClipRect(
                              child: Container(
                                width: 95,
                                height: 100,
                                child: Image.network(
                                  restaurantData[0]['res_logo'],
                                  fit: BoxFit.fill,
                                ),
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
              );
            }));
  }
}
