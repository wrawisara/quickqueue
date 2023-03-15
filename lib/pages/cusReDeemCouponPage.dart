import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/model/coupon.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';

class CusRedeemCouponPage extends StatefulWidget {
  const CusRedeemCouponPage({Key? key}) : super(key: key);

  @override
  State<CusRedeemCouponPage> createState() => _CusRedeemCouponPageState();
}

class _CusRedeemCouponPageState extends State<CusRedeemCouponPage> {
 //คำสั่งรับ datenow ยังไม่ได้ใช้
  String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String tdata = DateFormat("HH:mm:ss").format(DateTime.now());

  //เรียกข้อมูลมาใช้
  final booking = Booking.generateBooking();
  final customer = Customer.generateCustomer();
  final coupon = Coupon.generateCoupon();

  // String coupon_code = generateRandomString(10);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          title: Text(
            "Redeem Coupon",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
            icon: const Icon(
              Icons.clear_rounded,
              color: Colors.white,
            ),
            onPressed: () {
             navigateToCusProfilePage(context);
            },
          ),
          ],
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
                        coupon.img,
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
                        coupon.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Text(
                        "Expiration Date : 13/04/2023",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],),
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
                              'kjfgjdjfk',// couponcode จากหน้าทก่อน
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
                  ],),
                 
                 
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
                     
                    },
                  )
                ],
              )
            ],
          ),
        ));
  }
}
navigateToCusProfilePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusProfilePage();
  }));
}

