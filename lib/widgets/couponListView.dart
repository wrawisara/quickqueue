import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/widgets/couponItem.dart';

import '../model/Customer.dart';


class CouponListView extends StatefulWidget {
  final int selected;
  final Function callback;

  final Customer customer;

  CouponListView(this.selected,this.callback,this.customer);

  @override
  State<CouponListView> createState() => _CouponListViewState();
}

class _CouponListViewState extends State<CouponListView> {
  @override
  Widget build(BuildContext context) {
    final allCoupon = widget.customer.coupon.keys.toList();
    return Container(
      child: PageView(
        onPageChanged: (index) => widget.callback(index),
        children: allCoupon
          .map((e) => ListView.separated(
              itemBuilder: (context, index) => CouponItem(
                widget.customer.coupon[allCoupon[widget.selected]]![index]
              ), 
              separatorBuilder: (_, index) => SizedBox(height: 15,), 
              itemCount: widget.customer.coupon[allCoupon[widget.selected]]!.length))
          .toList(),
    ),
      );
    
  }
}