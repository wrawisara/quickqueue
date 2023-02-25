import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/allRestaurant.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';

import '../widgets/resLogoImage.dart';

import 'package:flutter/material.dart';

class CusBookingPage extends StatelessWidget {
  final AllRestaurant allRestaurantModel;
  const CusBookingPage({Key? key, required this.allRestaurantModel})
      : super(key: key);

  //อยากดึงข้อมูล Branch จาก Restaurant ?
  // final Restaurant restaurantDetail;

  @override
  Widget build(BuildContext context) {
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
        body: Container(
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
                  child: Image.asset(
                    allRestaurantModel.img,
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
                        allRestaurantModel.name,
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
                            allRestaurantModel.queueNum.toString() +
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
                  NumOfPersons(),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CusBookedPage()));

                    
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
        ));
  }
}

//เพิ่มลดจำนวนคนที่จอง
class NumOfPersons extends StatefulWidget {
  const NumOfPersons({super.key});

  @override
  State<NumOfPersons> createState() => _NumOfPersonsState();
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
              numberPerson > 0
                  ? setState(() {
                      numberPerson--;
                    })
                  : setState(() {
                      numberPerson = 0;
                    });
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
              });
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
