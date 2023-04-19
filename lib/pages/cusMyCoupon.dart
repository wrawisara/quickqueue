import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/cusCouponCode.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/cusReDeemCouponPage.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:quickqueue/utils/color.dart';

class CusMyCouponPage extends StatefulWidget {
  const CusMyCouponPage({Key? key}) : super(key: key);

  @override
  State<CusMyCouponPage> createState() => _CusMyCouponPageState();
}

class _CusMyCouponPageState extends State<CusMyCouponPage> {
  //เรียกข้อมูล Coupon ของ Customer มาใช้
  final CustomerServices customerServices = CustomerServices();
  late Future<List<Map<String, dynamic>>> _couponDataFuture;
  late Future<List<Map<String, dynamic>>> currentUserInfoFuture;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _couponDataFuture =
          customerServices.getCurrentCustomerCoupon(currentUser.uid);
      currentUserInfoFuture = customerServices.getCurrentUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "My Coupon",
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      child: Text('No coupon found'),
                    );
                  }

                  List<Map<String, dynamic>> couponData = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: couponData.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> coupon = couponData[index];
                      return Padding(
                        padding: const EdgeInsets.only(top:20.0),
                        child: Container(
                          height: 100,
                          margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                          decoration: new BoxDecoration(
                            
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Card(
                            color: cyanPrimaryLight,
                            child: ListTile(
                              contentPadding: EdgeInsets.only(
                                              top: 10, left: 15, right: 20),
                              title: Text(
                                coupon['couponName'],
                                style: TextStyle(fontSize: 20),
                              ),
                              subtitle: Text(
                                //ใส่เป็น requied point
                                coupon['status'],
                                style: TextStyle(fontSize: 18),
                              ),
                              leading: SizedBox(
                                width: 50,
                                height: 60,
                                child: Image.network(
                                  coupon['img'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              onTap: () async {
                                // * ไปหน้า CouponCode
                                navigateToCusCouponCodePage(context, coupon);
                              },
                            ),
                          ),
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

navigateToCusProfilePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusProfilePage();
  }));
}

navigateToCusCouponCodePage(BuildContext context, Map<String, dynamic> coupon) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusCouponCodePage(couponId: coupon['coupon_id']);
  }));
}

