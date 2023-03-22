import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/widgets/resQueueTable.dart';

class ResManageQueue extends StatefulWidget {
  @override
  State<ResManageQueue> createState() => _ResManageQueueState();
}

class _ResManageQueueState extends State<ResManageQueue> {
  final RestaurantServices restaurantServices = RestaurantServices();
  final BookingServices bookingServices = BookingServices();
  final CustomerServices customerServices = CustomerServices();

  late Future<List<Map<String, dynamic>>> _bookingDataFuture;
  late String userId;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _bookingDataFuture =
          bookingServices.getBookingDataForRestaurant(currentUser.uid);
      userId = currentUser.uid;
      // selectedBookings = [];
    }
  }

  // ข้อมูลจาก Model ฺBooking
  // final bookingList = Booking.generateBookingList();
  // late List<Booking> selectedBookings;

  // ไว้ดึงข้อมูลจาก firebase
  late List<Map<String, dynamic>> _bookingData;

  // ไว้ดึงข้อมูลจาก firebase
  //  late List<Map<String, dynamic>> _bookingData;

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
              icon: Icon(Icons.refresh),
              onPressed: () {
                print('Refresh button pressed');
                setState(() {
                  _bookingDataFuture =
                      bookingServices.getBookingDataForRestaurant(userId);
                });
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                bookingServices.downloadBookingsCsv(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading csv file')));
                // method to show the search bar
                // showSearch(
                //   context: context,
                //   // delegate to customize the search bar
                //   // delegate: CustomSearchDelegate()
                // );
              },
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: () async {
          _bookingDataFuture =
              bookingServices.getBookingDataForRestaurant(userId);
          await _bookingDataFuture;
          setState(() {});
        },
        child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _bookingDataFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: 400,
                    // margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: new BoxDecoration(
                      color: Colors.cyan.withOpacity(0.1),
                      border: Border.all(color: Colors.white, width: 3),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: DataTable(
                      sortAscending: true,
                      // headingRowColor:
                      //     MaterialStateProperty.all<Color>(Colors.cyan.withOpacity(0.1)),
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
                        //       'Guest',
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
                                  DataCell(Text(booking['status']),
                                      showEditIcon: true, onTap: () async {
                                    final customer = await bookingServices
                                        .getCustomerById(booking['c_id']);
                                    final customerName = customer.isNotEmpty
                                        ? "${customer[0]['firstname']} ${customer[0]['lastname']}"
                                        : "Unknown";
                                    final message =
                                        'Name: $customerName\nGuest: ${booking['guest']}';
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
                                              bookingServices
                                                  .updateBookingStatus(
                                                      booking['bookingQueue'],
                                                      'confirmed');
                                              customerServices.updatePointsOnCheckIn(booking['c_id'], booking['bookingQueue']);
                                            },
                                            text: 'Confirm Queue',
                                            iconData:
                                                Icons.check_circle_outline,
                                            color: Colors.tealAccent[700],
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                          IconsButton(
                                            onPressed: () {
                                              //ใส่ action
                                              bookingServices
                                                  .updateBookingStatus(
                                                      booking['bookingQueue'],
                                                      'canceled');
                                              customerServices.subtractReputation(booking['c_id']);
                                            },
                                            text: 'Cancel',
                                            iconData: Icons.cancel_outlined,
                                            color: Colors.red[400],
                                            textStyle:
                                                TextStyle(color: Colors.white),
                                            iconColor: Colors.white,
                                          ),
                                        ]);
                                  }),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
