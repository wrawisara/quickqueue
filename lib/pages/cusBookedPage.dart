import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/customerServices.dart';
import '../model/Customer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CusBookedPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;

  //เอา guest มาจากหน้า booking
  final int numberPerson;

  // Pass the current User
  const CusBookedPage(
      {Key? key, required this.restaurant, required this.numberPerson})
      : super(key: key);
  @override
  State<CusBookedPage> createState() => _CusBookedPageState();
}

class _CusBookedPageState extends State<CusBookedPage> {
  //คำสั่งรับ datenow ยังไม่ได้ใช้
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  //เรียกข้อมูลมาใช้
  final booking = Booking.generateBooking();
  final customer = Customer.generateCustomer();
  final BookingServices bookingServices = BookingServices();
  final CustomerServices customerServices = CustomerServices();
  late Future<List<Map<String, dynamic>>> _bookingDataFuture;
  late Future<List<Map<String, dynamic>>> currentUserInfoFuture;
  late Future<List<String>> customerNameFuture;
  // List<String> customerName = await customerNameFuture;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null && currentUser.uid != null) {
      _bookingDataFuture =
          bookingServices.getBookingDataForCustomer(currentUser.uid);
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
          automaticallyImplyLeading: false, // Disable the back icon
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
                    height: 300,
                    width: 300,
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    // padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: new BoxDecoration(
                      color: Colors.cyan.withOpacity(0.6),
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Container(
                            height: 260,
                            child: Image.network(
                              widget.restaurant['res_logo'],
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Row(
                          
                          children: [
                            Text(
                              widget.restaurant['username'],
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Booking Code ",
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
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _bookingDataFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error fetching data booking data'),
                          );
                        }

                        if (snapshot.data?.isEmpty ?? true) {
                          return Center(
                            child: Text('No booking found'),
                          );
                        }

                        List<Map<String, dynamic>> bookingData =
                            snapshot.data ?? [];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 100.0,
                                height: 70.0,
                                decoration: new BoxDecoration(
                                  color: Colors.cyan.withOpacity(0.7),
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    bookingData[0]['bookingQueue'] ?? '',
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
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Center(
                                  child: Text(
                                    bookingData[0]['bookingQueue'] ?? '',
                                    style: new TextStyle(
                                        fontSize: 30,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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
                        widget.numberPerson.toString(),
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
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: currentUserInfoFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error fetching data userdata'),
                          );
                        }

                        if (snapshot.data?.isEmpty ?? true) {
                          return Center(
                            child: Text('No user found'),
                          );
                        }

                        List<Map<String, dynamic>> userData = snapshot.data!;
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 75,
                              ),
                              child: Text(
                                (userData[0]['firstname'] ?? '') +
                                    " " +
                                    (userData[0]['lastname'] ?? ''),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _bookingDataFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            child: Text('No date time found'),
                          );
                        }

                        List<Map<String, dynamic>> bookingData = snapshot.data!;
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 75,
                              ),
                              child: Text(
                                bookingData[0]['time'],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
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