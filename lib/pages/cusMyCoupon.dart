import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';

class CusRedeemCouponPage extends StatefulWidget {
  const CusRedeemCouponPage({Key? key}) : super(key: key);

  @override
  State<CusRedeemCouponPage> createState() => _CusRedeemCouponPageState();
}

class _CusRedeemCouponPageState extends State<CusRedeemCouponPage> {
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
      
    );
  }
}


navigateToCusProfilePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return CusProfilePage();
  }));
}