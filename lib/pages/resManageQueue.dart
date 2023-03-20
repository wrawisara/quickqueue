import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/widgets/resQueueTable.dart';

class ResManageQueue extends StatefulWidget {
  @override
  State<ResManageQueue> createState() => _ResManageQueueState();
}

class _ResManageQueueState extends State<ResManageQueue> {
  final RestaurantServices restaurantServices = RestaurantServices();
  final BookingServices bookingServices = BookingServices();
  late Future<List<Map<String, dynamic>>> _bookingDataFuture;
  late Future<List<Map<String, dynamic>>> _customerDataFuture;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _bookingDataFuture = bookingServices.getBookingDataForRestaurant(currentUser.uid);
      selectedBookings = [];
    }
  }

  // ข้อมูลจาก Model ฺBooking
  final bookingList = Booking.generateBookingList();
  late List<Booking> selectedBookings;

   // ไว้ดึงข้อมูลจาก firebase
   late List<Map<String, dynamic>> _bookingData;

  //ใช้ select data ใน table
  List<DataRow> selectedRows = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.cyan,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Reservation",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search Restaurant')));
                // method to show the search bar
                // showSearch(
                //   context: context,
                //   // delegate to customize the search bar
                //   // delegate: CustomSearchDelegate()
                // );
              },
            ),
          ]),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _bookingDataFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'),
              );
            }

            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                child: Text('No bookings found'),
              );
            }

              _bookingData = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                sortAscending: true,
                headingRowColor:
                    MaterialStateProperty.all<Color>(Colors.cyan[50]!),
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
                rows: _bookingData
                    .map((booking) => DataRow(
                          cells: [
                            DataCell(Text(booking['bookingQueue'])),
                            DataCell(Text(booking['time'])),
                            DataCell(Text(booking['status']), showEditIcon: true,
                                onTap: () async {
                                  final customer = await bookingServices.getCustomerById(booking['c_id']);
                                  final customerName = customer.isNotEmpty ? "${customer[0]['firstname']} ${customer[0]['lastname']}" : "Unknown";
                                  final message = 'Name: $customerName\nGuest: ${booking['guest']}';
                              Dialogs.materialDialog(
                                  msg: message,
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
          }),
    );
  }
}