import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/booking.dart';

class ResQueueTable extends StatefulWidget {
  const ResQueueTable({super.key});

  @override
  State<ResQueueTable> createState() => _ResQueueTableState();
}

class _ResQueueTableState extends State<ResQueueTable> {
  // ข้อมูลจาก Model ฺBooking
  final bookingList = Booking.generateBookingList();
  late List<Booking> selectedBookings;

  //ใช้ select data ใน table
  List<DataRow> selectedRows = [];

  @override
  void initState() {
    super.initState();
    selectedBookings = [];
  }

  @override
  Widget build(BuildContext context) {
    //SingleChildScrollView ใช้เลื่อนลง
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        sortAscending: true,
        headingRowColor: MaterialStateProperty.all<Color>(Colors.cyan[50]!),
        columns: const <DataColumn>[
          DataColumn(
            label: Expanded(
              child: Text(
                'Booking',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
          ),

          DataColumn(
            label: Expanded(
              child: Text(
                'DateTime',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
          ),

          DataColumn(
            label: Expanded(
              child: Text(
                'Status',
                style: TextStyle(fontStyle: FontStyle.normal),
              ),
            ),
          ),
          //  DataColumn(
          //   label: Expanded(
          //     child: Text(
          //       'Confirm',
          //       style: TextStyle(fontStyle: FontStyle.normal),
          //     ),

          //   ),
          // ),
        ],
        rows: bookingList
            .map((booking) => DataRow(
                  cells: [
                    DataCell(Text(booking.booking_queue)),
                    DataCell(Text(booking.datetime)),
                    DataCell(Text(booking.q_status), showEditIcon: true,
                        onTap: () {
                      Dialogs.materialDialog(
                          msg:'Name: '+booking.c_name+'\nGuest: '+booking.guest,
                          // msgStyle: TextStyle(color: Colors.cyan,),
                          title: 'Customer confirmed the queue?',
                          color: Colors.white,
                          context: context,
                          actions: [
                            IconsButton(
                              onPressed: () {
                                //ใส่ action
                              },
                              text: 'Confirm Queue',
                              iconData: Icons.check_circle_outline,
                              color: Colors.tealAccent[700],
                              textStyle: TextStyle(color: Colors.white),
                              iconColor: Colors.white,
                            ),
                          ]);
                    }),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
