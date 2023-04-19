import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/pages/resConfigTable.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/utils/horizontalLine.dart';
import 'package:quickqueue/widgets/bookTableItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';
import 'package:quickqueue/widgets/numberOfQueue.dart';
import 'package:quickqueue/widgets/restaurantInfo.dart';
import 'package:material_dialogs/material_dialogs.dart';

class ResMainPage extends StatefulWidget {
  const ResMainPage({Key? key}) : super(key: key);

  @override
  State<ResMainPage> createState() => _ResMainPageState();
}

class _ResMainPageState extends State<ResMainPage> {
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();
  final RestaurantServices restaurantServices = RestaurantServices();
  late Future<List<Map<String, dynamic>>> _tableDataFuture;
  late Future<List<Map<String, dynamic>>> _restaurantDataFuture;
  var selected = 0;
  late String userId;
  late Future<num> _totalCapacityFuture;
  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _tableDataFuture = restaurantServices.getAllTableInfo(currentUser.uid);
      _totalCapacityFuture =
          restaurantServices.getTotalCapacity(currentUser.uid);
      _restaurantDataFuture =
          restaurantServices.getCurrentRestaurants(currentUser.uid);
      userId = currentUser.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookingServices bookingServices = BookingServices();

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.cyan,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text('Main Page', style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: false, // Disable the back icon
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.redeem_outlined, color: Colors.white),
                  onPressed: () {
                    showRedeemAlert(context, userId, restaurantServices);
                  }),
              IconButton(
                icon: const Icon(Icons.power_settings_new_outlined,
                    color: Colors.white),
                onPressed: () {
                  //กดเปิดปิดคิว
                  Dialogs.materialDialog(
                      msg: 'Press on the button to open or close the queue',
                      title: "Open or Close the queue",
                      color: Colors.white,
                      context: context,
                      actions: [
                        IconsButton(
                          onPressed: () {
                            restaurantServices.updateRestaurantStatus(
                                userId, 'open');
                          },
                          text: 'Open Queue',
                          iconData: Icons.check_circle_outline,
                          color: Colors.tealAccent[700],
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                        IconsButton(
                          onPressed: () {
                            restaurantServices.updateRestaurantStatus(
                                userId, 'close');
                          },
                          text: 'Close Queue',
                          iconData: Icons.cancel_outlined,
                          color: Colors.red[400],
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                      ]);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  showLogoutAlertDialog(context);
                },
              ),
            ]),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Stack(children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 170,
                  width: 400,
                  child: RestaurantInfo(),
                ),
                NumberOfQueue(userId),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 170),
                  child: Text(
                    "Table Reservation",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 110),
                  child: Row(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan[400],
                          minimumSize: Size(180, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                        ),
                        child: const Text('Book',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () async {
                          DateTime now = DateTime.now();
                          String date = DateFormat('yyyy-MM-dd').format(now);
                          String time = DateFormat('hh:mm a').format(now);
                          String bookingQueue = await bookingServices
                              .getBookingQueue(userId, date, -1);
                          bookingServices.resBookTable(
                              userId, '', date, time, -1, bookingQueue);
                        },
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _restaurantDataFuture,
                  builder: (context, restaurantSnapshot) {
                    if (restaurantSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      // Show a loading spinner while waiting for the future to complete
                      return CircularProgressIndicator();
                    }

                    final List<Map<String, dynamic>> restaurantData =
                        restaurantSnapshot.data!;

                    if (restaurantData == null) {
                      // Show an error message if the data is null
                      return Text('Total restaurant data is null');
                    }

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _tableDataFuture,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            child: Text('No restaurants found'),
                          );
                        }

                        final tableInfoList = snapshot.data?.toList() ?? [];
                        return Column(
                          children: tableInfoList.map((tableInfo) {
                            String type = tableInfo['table_type'];
                            int capacity = tableInfo['capacity'];
                            return BookTableItem(
                              type,
                              capacity,
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ])));
  }
}

navigateToResConfigTablePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ResConfigTablePage();
  }));
}

navigateToLoginPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return LoginPage();
  }));
}

void showRedeemAlert(BuildContext context, String userId,
    RestaurantServices restaurantServices) {
  final TextEditingController _textFieldController = TextEditingController();
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Redeem Code'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Redeem Code'),
          ),
          actions: <Widget>[
            IconsButton(
              onPressed: () {
                String redeemCode = _textFieldController.text;
                Navigator.of(context).pop();
                try {
                  restaurantServices.redeemCustCoupon(userId, redeemCode);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Success'),
                      content: Text("Successfully redeemed the coupon"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  if (e.toString() == 'Failed to redeem coupon') {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Error'),
                        content: Text(e.toString()),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              text: 'Redeem',
              iconData: Icons.check_circle_outline,
              color: Colors.tealAccent[700],
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
            IconsButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Cancel',
              iconData: Icons.cancel_outlined,
              color: Colors.red[400],
              textStyle: TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      });
}

showLogoutAlertDialog(BuildContext context) {
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      // authenServices.;
      navigateToLoginPage(context);
    },
  );
  Widget cancelButton = TextButton(
    child: Text("No"),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Sign Out"),
    content: Text("Would you like to sign out ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
