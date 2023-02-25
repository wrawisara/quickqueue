import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:intl/intl.dart';
import '../model/Customer.dart';
import '../model/allRestaurant.dart';

class CusBookedPage extends StatelessWidget {
  //คำสั่งรับ datenow ยังไม่ได้ใช้
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  //เรียกข้อมูลมาใช้
  final booking = Booking.generateBooking();
  final customer = Customer.generateCustomer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Booked",
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
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 250,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.asset(
                        booking.img,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        booking.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Booking Code",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Previous Queue",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                              booking.booking_queue,
                              style: new TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
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
                              booking.previous_queue,
                              style: new TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Guest : ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        booking.guest,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 75,
                        ),
                        child: Text(
                          customer.firstname + " " + customer.lastname,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 75,
                        ),
                        child: Text(
                          booking.datetime,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(160, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    child: const Text('OK',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CusChooseResPage()));
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}




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