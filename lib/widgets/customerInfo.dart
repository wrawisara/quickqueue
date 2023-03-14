import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/Customer.dart';

class CustomerInfo extends StatefulWidget {
  const CustomerInfo({super.key});

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {


  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  @override
  Widget build(BuildContext context) {
    
    String cusName = customer.firstname + " " + customer.lastname;
    double nameWidth = cusName.length.toDouble() + 220;
    print(nameWidth);
    return Container(
            // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    color: Colors.white,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/img/profile2.png',
                            scale: 4,
                            fit: BoxFit.fitHeight,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/img/crown.png',
                                  scale: 23,
                                ),
                                Text(
                                  customer.tier,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  customer.point.toString() + " " + "points",
                                  style: TextStyle(
                                    color: Color.fromRGBO(72, 191, 145, 1.0),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                          Text(
                            customer.phone,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: nameWidth,
                              height: 35,
                              decoration: new BoxDecoration(
                                color: Colors.cyan.withOpacity(0.2),
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  cusName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ])),
              ],
            ),
          );
  }
}