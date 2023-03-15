import 'package:flutter/material.dart';
import 'package:quickqueue/model/coupon.dart';

class Customer{
  String firstname = '';
  String lastname = '';
  String phone = '';
  String email = '';
  String password = '';
  String tier = '';
  int point;
  Map<String, List<Coupon>> coupon;


  Customer(this.firstname,this.lastname,this.phone,this.email,this.password,this.tier,this.point,this.coupon);


  static Customer generateCustomer(){
    return Customer(
      'Chanon', 'Limvongrujirat', '0812345678', 'kaiza@gmail.com', '1234','Gold',80,
    
      {
        'Coupon' : Coupon.generateCouponList()
      },
    );
  }
}


