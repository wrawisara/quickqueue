import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/model/coupon.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/widgets/couponListView.dart';
import 'package:quickqueue/widgets/tapList.dart';
import '../model/Customer.dart';
import '../model/allRestaurant.dart';

class CusProfilePage extends StatefulWidget {
  @override
  State<CusProfilePage> createState() => _CusProfilePageState();
}

class _CusProfilePageState extends State<CusProfilePage> {
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;

  @override
  Widget build(BuildContext context) {
    String cusName = customer.firstname + " " + customer.lastname;
    double nameWidth = cusName.length.toDouble() + 250;
    print(nameWidth);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(children: <Widget>[
          Container(
            // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: <Widget>[
                Container(
                    height: 230,
                    color: Colors.white,
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/img/profile2.png',
                            scale: 3.5,
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
                                  scale: 22,
                                ),
                                Text(
                                  customer.tier,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  customer.point.toString() + " " + "point",
                                  style: TextStyle(
                                    color: Color.fromRGBO(72, 191, 145, 1.0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ]),
                          Text(
                            customer.phone,
                            style: TextStyle(
                              fontSize: 20,
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
                              height: 40,
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
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))
              ],
            ),
          ),
          Expanded(
            child: CouponListView(
              selected,
              (int index) {
                setState(() {
                  selected = index;
                });
              },
              customer,
            ),
          )
        ]));
  }
}

//widget ทำ แถบเลือกด้านบน tapList ใส่ใน containner
// padding: EdgeInsets.all(20.0),
//               child: Column(
//                 children: <Widget>[
//                     CouponList(selected,
//                     (int index){
//                       setState((){
//                         selected = index;
//                       });
//                     }, customer)



// class DetailBox extends StatefulWidget {
//   const DetailBox({super.key});

//   @override
//   State<DetailBox> createState() => _DetailBoxState();
// }

// class _DetailBoxState extends State<DetailBox> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
          
//           InkWell(
//             onTap: () {},
//             child: Container(
//               width: 100.0,
//               height: 70.0,
//               decoration: new BoxDecoration(
//                 color: Colors.cyan.withOpacity(0.7),
//                 border: Border.all(color: Colors.white, width: 3),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Center(
//                 child: Text(
//                   "$numberPerson",
//                   style: new TextStyle(
//                       fontSize: 30,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400),
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 numberPerson++;
//               });
//             },
//             icon: Icon(Icons.add),
//             color: Colors.black,
//             iconSize: 30,
//           ),
//         ],
//       ),
//     );
//   }
// }



// set back กลับไปหน้าหลัก (มีปห ไปหน้าหลักละวนลูป)
// AppBar(
//         title: Text('Booked',style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.cyan,
//         leading: GestureDetector(
//           child: Icon( Icons.arrow_back_ios, color: Colors.white,  ),
//           onTap: () {
//            Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => CusChooseResPage()));
//           } ,
//         ) ,
//       ),