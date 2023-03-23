import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/cusReDeemCouponPage.dart';
import 'package:quickqueue/services/customerServices.dart';

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
  void initState(){
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if(currentUser != null && currentUser.uid != null){
      _couponDataFuture  =
        customerServices.getCurrentCustomerCoupon(currentUser.uid);
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
                      child: Text('No restaurants found'),
                    );
                  }

                  List<Map<String, dynamic>> couponData = snapshot.data ?? [];

                  return ListView.builder(
                    itemCount: couponData.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> coupon = couponData[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            // ใส่ CouponName
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
                            // * ไปหน้า redeemCoupon
                            //  navig
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

navigateToCusProfilePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusProfilePage();
  }));
}

navigateToCusRedeemCouponPage(
    BuildContext context, Map<String, dynamic> coupon) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusRedeemCouponPage(coupon: coupon);
  }));
}

// navigateToCusPage(
//     BuildContext context, Map<String, dynamic> coupon) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return CusRedeemCouponPage(coupon: coupon);
//   }));
// }