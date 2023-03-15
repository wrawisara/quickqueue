import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:quickqueue/widgets/couponListView.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';
import 'package:quickqueue/widgets/customerInfo.dart';
import 'package:quickqueue/widgets/tapList.dart';
import '../model/Customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CusProfilePage extends StatefulWidget {
  @override
  State<CusProfilePage> createState() => _CusProfilePageState();
}

class _CusProfilePageState extends State<CusProfilePage>{
  // Firebase get Customer
  CustomerServices customerServices = CustomerServices();
  late Future<List<Map<String, dynamic>>> _couponDataFuture;
  late Future<List<Map<String, dynamic>>> currentUserInfoFuture;
  //late DocumentSnapshot<Map<String, dynamic>> customerInfo = await customerServices.getCurrentUserData();
  
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();


  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
    _couponDataFuture = customerServices.getAllCurrentTierCoupon(currentUser.uid);
    currentUserInfoFuture = customerServices.getCurrentUserData();
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        "Profile",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.bookmark_add_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Want to go Booking History')));
          },
        ),
      ],
    ),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: currentUserInfoFuture,
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> userData = snapshot.data!;
          String cusName = (userData[0]['firstname'] ?? '') + " " + (userData[0]['lastname'] ?? '');
          double nameWidth = cusName.length.toDouble() + 250;

          return Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 230,
                        color: Colors.white,
                        alignment: Alignment.center,
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
                                      userData[0]['tier'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      (userData[0]['points_c'] ?? '') + (" ") + "points",
                                      style: TextStyle(
                                        color: Color.fromRGBO(72, 191, 145, 1.0),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                              Text(
                                userData[0]['phone'],
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
                                    border: Border.all(color: Colors.white, width: 3),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Text( 
                                      (userData[0]['firstname'] ?? '') + (" ") + userData[0]['lastname'],
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ])),
                  ],
                ),
              ),
            ]
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    ),
  );
}
}

class CouponText extends StatelessWidget {
  const CouponText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(children: <Widget>[
          Container(
            color: Colors.white,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              'Coupon',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan),
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





//แบบใช้ widget
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:quickqueue/model/booking.dart';
// import 'package:quickqueue/model/coupon.dart';
// import 'package:quickqueue/pages/cusChooseResPage.dart';
// import 'package:intl/intl.dart';
// import 'package:quickqueue/services/customerServices.dart';
// import 'package:quickqueue/widgets/couponListView.dart';
// import 'package:quickqueue/widgets/tapList.dart';
// import '../model/Customer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CusProfilePage extends StatefulWidget {
//   @override
//   State<CusProfilePage> createState() => _CusProfilePageState();
// }

// class _CusProfilePageState extends State<CusProfilePage>{
//   // Firebase get Customer
//   CustomerServices customerServices = CustomerServices();
//   //late DocumentSnapshot<Map<String, dynamic>> customerInfo = await customerServices.getCurrentUserData();
  
//   //เรียกข้อมูลมาใช้
//   final customer = Customer.generateCustomer();

//   //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
//   var selected = 0;

//   @override
//   Widget build(BuildContext context) {
    
//     String cusName = customer.firstname + " " + customer.lastname;
//     double nameWidth = cusName.length.toDouble() + 220;
//     print(nameWidth);
//     return Scaffold(
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white,
//           ),
//           title: Text(
//             "Profile",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: Column(children: <Widget>[
//           Container(
//             // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//             child: Column(
//               children: <Widget>[
//                 Container(
//                     height: 200,
//                     color: Colors.white,
//                     alignment: Alignment.center,
//                     // padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//                     child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Image.asset(
//                             'assets/img/profile2.png',
//                             scale: 4,
//                             fit: BoxFit.fitHeight,
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                           Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 Image.asset(
//                                   'assets/img/crown.png',
//                                   scale: 23,
//                                 ),
//                                 Text(
//                                   customer.tier,
//                                   style: TextStyle(
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 15,
//                                 ),
//                                 Text(
//                                   customer.point.toString() + " " + "points",
//                                   style: TextStyle(
//                                     color: Color.fromRGBO(72, 191, 145, 1.0),
//                                     fontSize: 17,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ]),
//                           Text(
//                             customer.phone,
//                             style: TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w400,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 5,
//                           ),
//                           InkWell(
//                             onTap: () {},
//                             child: Container(
//                               width: nameWidth,
//                               height: 35,
//                               decoration: new BoxDecoration(
//                                 color: Colors.cyan.withOpacity(0.2),
//                                 border:
//                                     Border.all(color: Colors.white, width: 3),
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   cusName,
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ])),
//               ],
//             ),
//           ),
//           Expanded(

//             child: CouponListView(
//               selected,
//               (int index) {
//                 setState(() {
//                   selected = index;
//                 });
//               },
//               customer,
//             ),


//           )
//         ]));
//   }
// }





// class CouponText extends StatelessWidget {
//   const CouponText({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 40,
//         // padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
//         child: Column(children: <Widget>[
//           Container(
//             color: Colors.white,
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//             child: Text(
//               'Coupon',
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.cyan),
//             ),
//           )
//         ]));
//   }
// }



// //widget ทำ แถบเลือกด้านบน tapList ใส่ใน containner
// // padding: EdgeInsets.all(20.0),
// //               child: Column(
// //                 children: <Widget>[
// //                     CouponList(selected,
// //                     (int index){
// //                       setState((){
// //                         selected = index;
// //                       });
// //                     }, customer)



// // class DetailBox extends StatefulWidget {
// //   const DetailBox({super.key});

// //   @override
// //   State<DetailBox> createState() => _DetailBoxState();
// // }

// // class _DetailBoxState extends State<DetailBox> {
  
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Row(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: <Widget>[
          
// //           InkWell(
// //             onTap: () {},
// //             child: Container(
// //               width: 100.0,
// //               height: 70.0,
// //               decoration: new BoxDecoration(
// //                 color: Colors.cyan.withOpacity(0.7),
// //                 border: Border.all(color: Colors.white, width: 3),
// //                 borderRadius: BorderRadius.circular(10.0),
// //               ),
// //               child: Center(
// //                 child: Text(
// //                   "$numberPerson",
// //                   style: new TextStyle(
// //                       fontSize: 30,
// //                       color: Colors.white,
// //                       fontWeight: FontWeight.w400),
// //                 ),
// //               ),
// //             ),
// //           ),
// //           IconButton(
// //             onPressed: () {
// //               setState(() {
// //                 numberPerson++;
// //               });
// //             },
// //             icon: Icon(Icons.add),
// //             color: Colors.black,
// //             iconSize: 30,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }



// // set back กลับไปหน้าหลัก (มีปห ไปหน้าหลักละวนลูป)
// // AppBar(
// //         title: Text('Booked',style: TextStyle(color: Colors.white),),
// //         backgroundColor: Colors.cyan,
// //         leading: GestureDetector(
// //           child: Icon( Icons.arrow_back_ios, color: Colors.white,  ),
// //           onTap: () {
// //            Navigator.of(context).push(MaterialPageRoute(
// //                           builder: (context) => CusChooseResPage()));
// //           } ,
// //         ) ,
// //       ),