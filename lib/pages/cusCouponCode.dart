import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/pages/cusMyCoupon.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/services/customerServices.dart';

class CusCouponCodePage extends StatefulWidget {
  //final Map<String, dynamic> coupon;
  final String couponId;

  const CusCouponCodePage({Key? key, required this.couponId}) : super(key: key);

  @override
  State<CusCouponCodePage> createState() => _CusCouponCodePageState();
}

class _CusCouponCodePageState extends State<CusCouponCodePage> {
 //คำสั่งรับ datenow ยังไม่ได้ใช้
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  //เรียกข้อมูลมาใช้
  //final booking = Booking.generateBooking();
  //final customer = Customer.generateCustomer();
  //final coupon = Coupon.generateCoupon();
  final CustomerServices customerServices = CustomerServices();
  late Future<List<Map<String, dynamic>>> _couponDataFuture;
  late Future<List<Map<String, dynamic>>> currentUserInfoFuture;

  // String coupon_code = generateRandomString(10);

    @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _couponDataFuture =
          customerServices.getCouponById(currentUser.uid, widget.couponId);
      currentUserInfoFuture = customerServices.getCurrentUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final currentUser = FirebaseAuth.instance.currentUser;
    //Timestamp endDateTimestamp = widget.coupon['end_date'];

// Convert Timestamp to DateTime
    //DateTime endDate = endDateTimestamp.toDate();

// Format DateTime to display date and time as string
    //String formattedEndDate =
        //DateFormat("MMMM dd, yyyy hh:mm a 'UTC'Z").format(endDate);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Coupon Code',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.clear_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                navigateToCusMyCouponPage(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
             
             FutureBuilder<List<Map<String, dynamic>>>(
                future: _couponDataFuture,
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
                      child: Text('No coupon data found'),
                    );
                  }

                  List<Map<String, dynamic>> couponData = snapshot.data ?? [];

                  return Container(
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      children: <Widget>[
                        Column(
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
                                  couponData[0]['img'],
                                  scale: 1.5,
                                  fit: BoxFit.fill,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                elevation: 1, 
                                margin: EdgeInsets.all(5),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  couponData[0]['couponName'],
                                  style: TextStyle(
                                    fontSize: 25,
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
                              children: [
                                Text(
                                  "Expiration Date : \n" + formatDate(couponData[0]['end_date']),
                                      //formattedEndDate,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Coupon Code",
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
                                    width: 200.0,
                                    height: 70.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.7),
                                      border: Border.all(color: Colors.white, width: 3),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        couponData[0]['code'], // couponcode จากหน้าทก่อน
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Promo discount coupon code \nfor QuickQueue member only",
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
                            
                          ],
                        )
                      ],
                    ),
                  );
                }
              ),
            ],
          ),
        ));
  }
}



navigateToCusMyCouponPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusMyCouponPage();
  }));
}


String formatDate(Timestamp timestamp) {
  final date = timestamp.toDate();
  final formatter = DateFormat('yyyy-MM-dd h:mm a');
  return formatter.format(date);
}




