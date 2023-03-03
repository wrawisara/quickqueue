import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/utils/color.dart';


class NumberOfQueue extends StatefulWidget {
  NumberOfQueue({super.key});

  Booking booking = Booking.generateBooking();

  @override
  State<NumberOfQueue> createState() => _NumberOfQueueState();
}

class _NumberOfQueueState extends State<NumberOfQueue> {
  int num_queue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Number Of Queue",
            style: TextStyle(fontSize: 22, color: Colors.cyan.shade800,fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: 80.0,
              height: 80.0,
              decoration: new BoxDecoration(
                color: cyanPrimary,
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Text(
                  widget.booking.num_queue.toString(),
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
