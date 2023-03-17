import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';

import '../widgets/restaurantInfo.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class CusBookingPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const CusBookingPage({Key? key, required this.restaurant}) : super(key: key);

// final List<Map<String, dynamic>> allRestaurantModel;

  @override
  State<CusBookingPage> createState() => _CusBookingPageState();
}

class _CusBookingPageState extends State<CusBookingPage> {
  final CustomerServices customerServices = CustomerServices();
  final BookingServices bookingService = BookingServices();

  //เรียกข้อมูล booking มาใช้
    final BookingServices bookingServices = BookingServices();
  late Future<List<Map<String, dynamic>>> _bookingDataFuture;

  @override
  void initState() {
    super.initState();
    _bookingDataFuture = bookingServices.getBookingData();
  }

  //เอาค่า guest จาก number of person มาใช้
  int numberPerson = 0;

  void updateNumberOfPersons(int value) {
    setState(() {
      numberPerson = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Booking",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:  Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 250,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        widget.restaurant['res_logo'],
                        scale: 1.5,
                        fit: BoxFit.fitHeight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      elevation: 1,
                      margin: EdgeInsets.all(5),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            widget.restaurant['username'],
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            "Previous Queue : " +
                                //  "widget.allRestaurantModel.queueNum.toString()" +
                                " Queue",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Text(
                              "Number of persons",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      NumOfPersons(
                        onChanged: updateNumberOfPersons
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // primary: Colors.green,
                          // elevation: 3,
                          minimumSize: Size(160, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                        ),
                        child: const Text('Book',
                            style: TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          try {
                          if (currentUser != null && currentUser.uid != null) {
                            print(numberPerson);
                            DateTime now = DateTime.now();
                            String date = DateFormat('yyyy-MM-dd').format(now);
                            String time = DateFormat('hh:mm a').format(now);
                            bookingService.bookTable(
                                widget.restaurant['r_id'],
                                currentUser.uid,
                                date,
                                time,
                                numberPerson);
                          }
                          } catch (e){
                            print('Something error: $e');
                          }
        
                          //save data ลง db 
                          //widget.restaurant['username'];
                          //widget.allRestaurantModel.queueNum;
                          //NumOfPersons();
                          
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CusBookedPage(restaurant: widget.restaurant,numberPerson: numberPerson,)));
        
                          // alert แจ้งเตือนว่าจองสำเร็จใช้ได้ค่อยเปิด
                          // showDialog<String>(
                          //   context: context,
                          //   builder: (BuildContext context) => AlertDialog(
                          //     title: const Text('Sucess'),
                          //     content: const Text('Your queue has been booked.'),
                          //   ),
                          // );
                        },
                      )
                    ],
                  )
                ],
              ),
            )
        );
  }
}

//เพิ่มลดจำนวนคนที่จอง
class NumOfPersons extends StatefulWidget {
 
  // @override
  // State<NumOfPersons> createState() => _NumOfPersonsState();

   final void Function(int) onChanged;
  const NumOfPersons({Key? key, required this.onChanged}) : super(key: key);
  @override
  _NumOfPersonsState createState() => _NumOfPersonsState();
}

class _NumOfPersonsState extends State<NumOfPersons> {
  int numberPerson = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                numberPerson = numberPerson > 0 ? numberPerson - 1 : 0;
                widget.onChanged(numberPerson);
                
              });

              // numberPerson > 0
              //     ? setState(() {
              //         numberPerson--;
              //       })
              //     : setState(() {
              //          numberPerson = 0;
              //       });



              // widget.onChanged(numberPerson -1);
              // numberPerson > 0
              //   ? setState(() {
              //       numberPerson = numberPerson - 1;
              //     })
              //   : setState(() {
              //       numberPerson = 0;
              //     });
            },
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 30,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: 100.0,
              height: 70.0,
              decoration: new BoxDecoration(
                color: Colors.cyan.withOpacity(0.7),
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  "$numberPerson",
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
               setState(() {
                numberPerson++;
                widget.onChanged(numberPerson);
              });


              // setState(() {
              //    numberPerson++;
              // });

              //  widget.onChanged(numberPerson+1);
              // setState(() {
              //   numberPerson = numberPerson + 1;
              // });
            },
            icon: Icon(Icons.add),
            color: Colors.black,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}

//เพิ่มลดจำนวนคนที่จอง
// class NumOfPersons extends StatefulWidget {
//   int numberPerson = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           IconButton(
//             onPressed: () {
//               numberPerson--;
//             },
//             icon: Icon(Icons.remove),
//             color: Colors.black,
//             iconSize: 30,
//           ),
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
//               numberPerson++;
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

//  Column(children: [Image.asset(allRestaurantModel.img), Text(allRestaurantModel.name),Text(allRestaurantModel.queueNum.toString())]),

// class CusBookingPage extends StatefulWidget {
//   const CusBookingPage({super.key});

//   @override
//   State<CusBookingPage> createState() => _CusBookingPageState();
// }

// class _CusBookingPageState extends State<CusBookingPage> {

//   final AllRestaurant restaurant;
//   AllRestaurant(this.restaurant);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Booking', style: TextStyle(color: Colors.white)),
//       ),
//       body: Column(children: [
//         resLogoImage(),
//       ],)
//     );
//   }
// }

// Stack(
//         children: [
//           Positioned(
//               left: 0,
//               right: 0,
//               child: Container(
//                 width: double.maxFinite,
//                 height: 350,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage("assets/img/onthetable.jpg"))),
//               )),
//         ],
//       ),
