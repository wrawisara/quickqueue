import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/utils/horizontalLine.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';

class BookTableItem extends StatefulWidget {
  String type;
  int capacity;
  // List<Map<String, dynamic>> restaurant;

  BookTableItem(this.type, this.capacity,);

  @override
  State<BookTableItem> createState() => _BookTableItemState();
}

class _BookTableItemState extends State<BookTableItem> {
  final BookingServices bookingServices = BookingServices();
  // late Future<List<Map<String, dynamic>>> _bookingDataFuture;

  // @override
  // void initState() {
  //   super.initState();
  //   _bookingDataFuture = bookingServices.getBookingData();
  // }

  //final TableInfo tableInfo = TableInfo.generateTableInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 380,
          height: 70,
        
          child: Column(
            children: [
              
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ClipRect(
                        child: Icon(
                          Icons.table_restaurant,
                          size: 40,
                        ),
                      ),
                      Text(
                        "Table " + widget.type,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      // Text(
                      //   "(" + widget.capacity.toString() + " Seats)",
                      //   style: TextStyle(
                      //       fontSize: 15, fontWeight: FontWeight.w400),
                      // ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Total of table " ,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                            widget.capacity.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                      // Row(
                      //   children: [
                      //     Container(
                      //         width: 100,
                      //         height: 35,
                      //         child: CustomElevatedButton(
                      //           width: double.infinity,
                      //           onPressed: () async {
                      //             DateTime now = DateTime.now();
                      //             String date =
                      //                 DateFormat('yyyy-MM-dd').format(now);
                      //             String time =
                      //                 DateFormat('hh:mm a').format(now);
                      //             String bookingQueue =
                      //                 await bookingServices.getBookingQueue(
                      //                     widget.restaurant[0]['r_id'],
                      //                     date,
                      //                     -1);
                      //             bookingServices.resBookTable(
                      //                 widget.restaurant[0]['r_id'],
                      //                 '',
                      //                 date,
                      //                 time,
                      //                 -1,
                      //                 bookingQueue);
                      //           },
                      //           borderRadius: BorderRadius.circular(10),
                      //           child: Text(
                      //             'Book',
                      //             style: TextStyle(
                      //                 color: Colors.white, fontSize: 15),
                      //           ),
                      //         )

                              
                              
                      //         ),
                      //   ],
                      // ),
                    ],
                  ),
                ],
              ),
             
              
            ],
          ),
        ),
      ],
    );
  }
}
