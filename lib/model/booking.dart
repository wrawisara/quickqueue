import 'package:flutter/material.dart';
import 'package:quickqueue/model/booking.dart';

class Booking {
  //ชื่อร้าน
  String name;
  String img;

  
  String c_name;
  //หมายเลขคิวลูกค้า
  String booking_queue;
  String previous_queue;
  String datetime;
  String guest;

  //จำนวนคิวทั้งหมดตอนนี้
  int num_queue;

  //status ลูกค้า
  String q_status;

  Booking(
      this.name,
      this.img,
      this.c_name,
      this.booking_queue,
      this.previous_queue,
      this.datetime,
      this.guest,
      this.num_queue,
      this.q_status);

  static Booking generateBooking() {
    return Booking(
        'On the table',
        'assets/img/onthetable.jpg',
        'Chanon Limvonrujirat',
        'B001',
        '3',
        '2023-02-21 12:00',
        '2',
        1,
        "Waiting for confirm the queue");
  }

  static List<Booking> generateBookingList() {
    return [
      Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Chanon Limvonrujirat',
          'B001',
          '3',
          '2023-02-21 12:00',
          '2',
          1,
          "Waiting for confirm the queue"),
      Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Rawisara Mawilerd',
          'A002',
          '1',
          '2023-02-21 13:00',
          '2',
          1,
          "Waiting for confirm the queue"),
      Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
          Booking(
          'On the table',
          'assets/img/onthetable.jpg',
          'Pla Whale',
          'A001',
          '0',
          '2023-02-21 13:00',
          '2',
          1,
          "Got the table"),
    ];
  }
}
