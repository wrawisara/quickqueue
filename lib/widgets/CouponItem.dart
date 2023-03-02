import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/coupon.dart';

class CouponItem extends StatefulWidget {
  final Coupon coupon;
  CouponItem(this.coupon);

  @override
  State<CouponItem> createState() => _CouponItemState();
}

class _CouponItemState extends State<CouponItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(5),
          width: 110,
          height: 110,
          child: Image.asset(widget.coupon.img, fit: BoxFit.fitHeight),
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.coupon.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 15,
              
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(widget.coupon.description == "-"
                ? "ส่วนลด " + widget.coupon.discount.toString() + " %"
                : "แลกรับเมนู " + widget.coupon.description),
            SizedBox(
              height: 5,
            ),
            Text(widget.coupon.required_point.toString()+" points",
            style: TextStyle(
              color: Colors.cyan
            ),)
          ]),
        ))
      ]),
    );
  }
}