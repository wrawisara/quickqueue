import 'package:flutter/material.dart';

class Booking {
  String name;
  String img;
  String booking_queue;
  String previous_queue;
  String datetime;
  String guest;

  //จำนวนคิวทั้งหมดตอนนี้
  int num_queue;

  Booking(this.name, this.img, this.booking_queue,
      this.previous_queue, this.datetime, this.guest,this.num_queue);

  static Booking generateBooking() {
    return Booking('On the table', 'assets/img/onthetable.jpg', 'B001', '3'
        , '2023-02-21 12:00', '2',1);
  }
}
