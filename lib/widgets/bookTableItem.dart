import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/utils/horizontalLine.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';

class BookTableItem extends StatefulWidget {
  String type;
  int capacity;
  int available;
  List<Map<String, dynamic>> restaurant;

  BookTableItem(this.type, this.capacity, this.available, this.restaurant,);

  @override
  State<BookTableItem> createState() => _BookTableItemState();
}

class _BookTableItemState extends State<BookTableItem> {
  final BookingServices bookingServices = BookingServices();
  late Future<List<Map<String, dynamic>>> _bookingDataFuture;

  @override
  void initState() {
    super.initState();
    _bookingDataFuture = bookingServices.getBookingData();
  }

  //final TableInfo tableInfo = TableInfo.generateTableInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 380,
          height: 130,
          // decoration: new BoxDecoration(
          //   // color: Colors.cyan.withOpacity(0.2),
          //   border: Border.all(color: Colors.cyan.withOpacity(0.4), width: 1),
          //   borderRadius: BorderRadius.circular(40.0),
          // ),
          margin: EdgeInsets.only(top: 5),
          // padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      ClipRect(
                        child: Icon(
                          Icons.table_restaurant,
                          size: 60,
                        ),
                      ),
                      Text(
                        "Table " + widget.type,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "(" + widget.capacity.toString() + " Seats)",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Available ",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            widget.available.toString(),
                            style: TextStyle(
                                // backgroundColor:Color.fromRGBO(72, 191, 145, 0.5),
                                fontSize: 20,
                                fontWeight: FontWeight.w400),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Max " + widget.capacity.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              height: 35,
                              child: CustomElevatedButton(
                                width: double.infinity,
                                onPressed: () async {
                                  DateTime now = DateTime.now();
                                  String date =
                                      DateFormat('yyyy-MM-dd').format(now);
                                  String time =
                                      DateFormat('hh:mm a').format(now);
                                  String bookingQueue =
                                      await bookingServices.getBookingQueue(
                                          widget.restaurant[0]['r_id'],
                                          date,
                                          2);

                                  String previousQueue = await bookingServices.getPreviousBookingQueue(widget.restaurant[0]['r_id'],
                                          date,
                                          2);
                                  bookingServices.bookTable(
                                      widget.restaurant[0]['r_id'],
                                      '',
                                      date,
                                      time,
                                      2,
                                      bookingQueue);
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Text(
                                  'Book',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              )

                              // child: ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     // primary: Colors.green,
                              //     // elevation: 3,
                              //     minimumSize: Size(280, 50),
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius:
                              //             BorderRadius.circular(32.0)),
                              //   ),
                              //   child: const Text('Book',
                              //       style: TextStyle(
                              //           fontSize: 20, color: Colors.white)),
                              //   onPressed: () {
                              //     //** ใส่ที่จะบันทึกข้อมูล */
                              //     // alert แจ้งเตือนบันทึกสำเร็จ ใช้ได้ค่อยเปิด
                              //     // showDialog<String>(
                              //     //   context: context,
                              //     //   builder: (BuildContext context) => AlertDialog(
                              //     //     title: const Text('Sucess'),
                              //     //     content: const Text('Your Table Success'),
                              //     //   ),
                              //     // );
                              //   },
                              // ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
        HorizontalLine(),
      ],
    );
  }
}
