import 'package:flutter/material.dart';
import 'package:quickqueue/model/coupon.dart';
import '../model/Customer.dart';

//widget ทำ แถบเลือกด้านบน //ยังไม่ได้ใช้
class TapList extends StatelessWidget {
  final int selected;
  final Function callback;
  final Customer customer;
  TapList(this.selected,this.callback,this.customer);

  @override
  Widget build(BuildContext context) {
    final allCoupon = customer.coupon.keys.toList();
    return Container(
      height: 100,
      width: 200,
      padding: EdgeInsets.all(20),
      child: ListView.separated(
        itemBuilder: (context, index) => GestureDetector(
          onTap: ()=> callback(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: selected == index ? Colors.cyan : Colors.white,
            ),
            child: Text(
              allCoupon[index],
            ),
          ),
        ), 
        separatorBuilder: (_, index) => SizedBox(width: 20,), 
        itemCount: allCoupon.length)
    );
  }
}