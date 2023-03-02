import 'package:flutter/material.dart';

class Restaurant{
  String restaurantName = '';
  String email = '';
  String password = '';
  String phone = '';
  String address = '';
  String latitude = '';
  String longitude = '';
  String branch = '';
  String logo = '';

  Restaurant(this.restaurantName,this.email,this.password,
  this.phone,this.address,this.latitude,this.longitude,this.branch,this.logo);

  static Restaurant generateRestaurant(){
    return   Restaurant(
      'MO-MO-Paradise','momo@gmail.com','1234','0841564789','3522 Lat Phrao Rd, Khlong Chan, Bang Kapi District, Bangkok 10240','13.7502','100.5395'
    ,'The Mall Bang Kapi','assets/img/momo.jpg');
  }
}
