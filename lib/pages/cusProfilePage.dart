import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/model/coupon.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/pages/cusReDeemCouponPage.dart';
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
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();
  final coupon = Coupon.generateCoupon();
}
String generateRandomString(int lenght) {
  //สร้าง code ให้ลูกค้ากด
  var coupon_code = Random();
  return String.fromCharCodes(List.generate(lenght, (index) => coupon_code.nextInt(33) + 89));
}



class _CusProfilePageState extends State<CusProfilePage> {
  // Get data from Firebase
  final CustomerServices customerServices = CustomerServices();

  late Future<List<Map<String, dynamic>>> _restaurantDataFuture =
      Future.value([]);

  @override
  void initState() {
    super.initState();
    _restaurantDataFuture = customerServices.getAllRestaurants();
  }


  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;

  @override
  Widget build(BuildContext context) {
    String cusName = widget.customer.firstname + " " + widget.customer.lastname;
    double nameWidth = cusName.length.toDouble() + 220;
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
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                CustomerInfo(),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _restaurantDataFuture,
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error fetching data'),
                    );
                  }

                  if (snapshot.data?.isEmpty ?? true) {
                    return Center(
                      child: Text('No restaurants found'),
                    );
                  }

                  List<Map<String, dynamic>> restaurantData =
                      snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: restaurantData.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> restaurant = restaurantData[index];
                      print("Hello" + restaurant['username']);
                      return Card(
                        child: ListTile(
                          title: Text(
                            // ใส่ CouponName
                            restaurant['username'],
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            //ใส่เป็น requied point
                            restaurant['address'] + " point",
                            style: TextStyle(fontSize: 18),
                          ),
                          leading: SizedBox(
                            width: 50,
                            height: 60,
                            child: Image.network(
                              restaurant['res_logo'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          onTap: () {
                            print('Tapped');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Row(children: [
                                    Image.network(
                                      restaurant['res_logo'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.contain,
                                    ),
                                    // ใส่ CouponName
                                    Text(restaurant['username'])
                                  ]),
                                  content: Text(
                                      "Are You Sure Want To Redeem Coupon?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("YES"),
                                      onPressed: () {
                                        generateRandomString(10);
                                        navigateToCusRedeemCouponPage(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("CANCEL"),
                                      onPressed: () {},
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}


navigateToCusRedeemCouponPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusRedeemCouponPage();
  }));
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