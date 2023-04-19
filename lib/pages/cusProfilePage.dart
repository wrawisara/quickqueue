import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:quickqueue/pages/cusHomePage.dart';
import 'package:quickqueue/pages/cusMyCoupon.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:quickqueue/utils/color.dart';
import '../model/Customer.dart';


import 'cusReDeemCouponPage.dart';

class CusProfilePage extends StatefulWidget {
  @override
  State<CusProfilePage> createState() => _CusProfilePageState();
}

class _CusProfilePageState extends State<CusProfilePage> {
  // Firebase get Customer
  CustomerServices customerServices = CustomerServices();
  late Future<List<Map<String, dynamic>>> _couponDataFuture;
  late Future<List<Map<String, dynamic>>> currentUserInfoFuture;

  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _couponDataFuture =
          customerServices.getAllCurrentTierCoupon(currentUser.uid);
      currentUserInfoFuture = customerServices.getCurrentUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // String cusName = widget.customer.firstname + " " + widget.customer.lastname;
    // double nameWidth = cusName.length.toDouble() + 220;
    // print(nameWidth);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            navigateToCusHomePage(context);
          },
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: false, // Disable the back icon
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.redeem_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Want to go Booking History')));
              navigateToCusMyCouponPage(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: currentUserInfoFuture,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> userData = snapshot.data!;
                        String cusName = (userData[0]['firstname'] ?? '') +
                            " " +
                            (userData[0]['lastname'] ?? '');
                        double nameWidth = cusName.length.toDouble() + 250;
                        print(userData);
                        return Column(children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    height: 230,
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image.asset(
                                            'assets/img/profile4.jpeg',
                                            scale: 14,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                  (userData[0]['point_c']
                                                          .toString()) +
                                                      (" ") +
                                                      "points",
                                                  style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        72, 191, 145, 1.0),
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
                                                color: Colors.cyan
                                                    .withOpacity(0.2),
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 3),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  (userData[0]['firstname'] ??
                                                          '') +
                                                      (" ") +
                                                      userData[0]['lastname'],
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
                        ]);
                      } else if (snapshot.hasError) {
                        print("error snaphot : ${snapshot.error}");
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    }),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _couponDataFuture,
                      builder: (BuildContext context, snapshot) {
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
                            child: Text('Currently no coupon available.'),
                          );
                        }

                        List<Map<String, dynamic>> couponData =
                            snapshot.data ?? [];

                        return ListView.builder(
                          itemCount: couponData.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> coupon = couponData[index];
                            return Container(
                              height: 100,
                              margin: EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
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
                              child: Container(
                                child: Card(
                                  color: cyanPrimaryLight,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 10),
                                    child: ListTile(
                                      title: Text(
                                        // ใส่ CouponName
                                        coupon['couponName'],
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      subtitle: Text(
                                        //ใส่เป็น requied point
                                        coupon['requiredPoint'].toString() +
                                            " point",
                                        style: TextStyle(fontSize: 16,color:
                                                  Color.fromRGBO(22, 197, 130, 1).withOpacity(0.8),),
                                      ),
                                      leading: SizedBox(
                                        width: 60,
                                        height: 70,
                                        child: Image.network(
                                          coupon['img'],
                                          fit: BoxFit.fill,
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
                                              coupon['img'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                            SizedBox(width: 15,),
                                            // ใส่ CouponName
                                             Flexible(child: Text(coupon['couponName'],overflow: TextOverflow.ellipsis,))
                                          ]),
                                          content: Text(
                                              "Are you sure you want to redeem coupon?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("YES"),
                                              onPressed: () async {
                                                try {
                                                  final currentUser =
                                                      FirebaseAuth.instance.currentUser;
                                                  if (currentUser != null &&
                                                      currentUser.uid != null) {
                                                    await customerServices.useCoupon(
                                                        currentUser.uid,
                                                        coupon['requiredPoint'], coupon['coupon_id']);
                                                    navigateToCusRedeemCouponPage(
                                                        context, coupon);
                                                  }
                                                } catch (e) {
                                                  if (e.toString() ==
                                                      'Exception: Insufficient points to use this coupon') {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          title: Text("Error"),
                                                          content: Text('Insufficient points to use this coupon'),
                                                          actions: [
                                                            TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  } else if(e.toString() == 'Exception: You already collected this coupon'){
                                                    
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          content: Text('You already collected this coupon'),
                                                          actions: [],
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return AlertDialog(
                                                          content: Text('$e'),
                                                          actions: [],
                                                        );
                                                      },
                                                    );
                                                  }
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text("CANCEL"),
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                            ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
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
          ),
        ],
      ),
    );
  }
}

navigateToCusRedeemCouponPage(
    BuildContext context, Map<String, dynamic> coupon) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusRedeemCouponPage(couponId: coupon['coupon_id']);
  }));
}

navigateToCusMyCouponPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusMyCouponPage();
  }));
}

navigateToCusChooseResPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusChooseResPage();
  }));
}

navigateToCusHomePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusHomePage();
  }));
}




