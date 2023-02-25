import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/widgets/CouponItem.dart';

import '../model/Customer.dart';


class CouponListView extends StatelessWidget {
  final int selected;
  final Function callback;

  final Customer customer;

  CouponListView(this.selected,this.callback,this.customer);
  
  @override
  Widget build(BuildContext context) {
    final allCoupon = customer.coupon.keys.toList();
    return Container(
      child: PageView(
        onPageChanged: (index) => callback(index),
        children: allCoupon
          .map((e) => ListView.separated(
              itemBuilder: (context, index) => CouponItem(
                customer.coupon[allCoupon[selected]]![index]
              ), 
              separatorBuilder: (_, index) => SizedBox(height: 15,), 
              itemCount: customer.coupon[allCoupon[selected]]!.length))
          .toList(),
    ),
      );
    
  }
}