import 'dart:ffi';

import 'package:flutter/material.dart';

// ramdom string
//import 'dart:math';
// String generateRandomString(int len) {
//   var r = Random();
//   return String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
// }

class Coupon {
  String name;
  String img;
  String code;
  double discount;
  int required_point;
  String description;

  Coupon(this.name, this.img, this.code, this.discount, this.required_point,
      this.description);

  static List<Coupon> generateCoupon() {
    return [
      Coupon(
          'On the table', 'assets/img/onthetable.jpg', 'jhflsp', 10.0, 30, '-'),
      Coupon('MOMO-Paradise', 'assets/img/momo.jpg', 'mdulgw', 0.0, 60,
          'เนื้อ Wagyu Brisket'),
      Coupon('MOMO-Paradise', 'assets/img/momo.jpg', 'mdulgw', 0.0, 60,
          'เนื้อ Wagyu Brisket'),
      Coupon('MOMO-Paradise', 'assets/img/momo.jpg', 'mdulgw', 0.0, 60,
          'เนื้อ Wagyu Brisket'),
           Coupon('MOMO-Paradise', 'assets/img/momo.jpg', 'mdulgw', 0.0, 60,
          'เนื้อ Wagyu Brisket'),
           Coupon('MOMO-Paradise', 'assets/img/momo.jpg', 'mdulgw', 0.0, 60,
          'เนื้อ Wagyu Brisket'),
    ];
  }
}
