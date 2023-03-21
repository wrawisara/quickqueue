import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/pages/resConfigTable.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/widgets/bookTableItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    }
  }

  @override
  Widget build(BuildContext context) {
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
                            //ใส่ action
                          },
                          text: 'Open Queue',
                          iconData: Icons.check_circle_outline,
                          color: Colors.tealAccent[700],
                          textStyle: TextStyle(color: Colors.white),
                          iconColor: Colors.white,
                        ),
                        IconsButton(
                          onPressed: () {
                            //ใส่ action
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
                NumberOfQueue(),
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
                            int available = tableInfo['available'];
                            return BookTableItem(
                                type, capacity, available, restaurantData);
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ]))

        //  Container(
        //   // width: MediaQuery.of(context).size.width,
        //   height: 800,
        //   child: Column(
        //     children: <Widget>[

        //               RestaurantInfo(),

        // FutureBuilder<num>(
        //   future: _totalCapacityFuture,
        //   builder: (context, totalCapacitySnapshot) {
        //     if (totalCapacitySnapshot.connectionState ==
        //         ConnectionState.waiting) {
        //       // Show a loading spinner while waiting for the future to complete
        //       return CircularProgressIndicator();
        //     }

        //     final num? totalCapacity = totalCapacitySnapshot.data!;

        //     if (totalCapacity == null) {
        //       // Show an error message if the data is null
        //       return Text('Total capacity data is null');
        //     }

        //     return FutureBuilder<List<Map<String, dynamic>>>(
        //       future: _restaurantDataFuture,
        //       builder: (context, restaurantDataSnapshot) {
        //         if (restaurantDataSnapshot.connectionState ==
        //             ConnectionState.waiting) {
        //           // Show a loading spinner while waiting for the future to complete
        //           return CircularProgressIndicator();
        //         }

        //         final List<Map<String, dynamic>> restaurantData =
        //             restaurantDataSnapshot.data!;

        //         print(restaurantData[0]['username']);
        //         print(totalCapacity);
        //         print(restaurantData[0]['branch']);
        //         print(restaurantData[0]['status']);
        //         print(restaurantData[0]['res_logo']);

        //         return RestaurantInfo(
        //           restaurantData[0]['name'] ?? "",
        //           totalCapacity,
        //           restaurantData[0]['branch'] ?? "",
        //           restaurantData[0]['status'] ?? "",
        //           restaurantData[0]['res_logo'] ?? "",
        //         );
        //       },
        //     );
        //   },
        // ),

        // SingleChildScrollView(
        //   child: Container(
        // child: Column(
        //   children: <Widget>[
        //     NumberOfQueue(),
        //     SizedBox(
        //       height: 40,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(right: 170),
        //       child: Text(
        //         "Table Reservation",
        //         style: TextStyle(
        //             color: Colors.black,
        //             fontSize: 22,
        //             fontWeight: FontWeight.bold),
        //       ),
        //     ),
        //     FutureBuilder<List<Map<String, dynamic>>>(
        //     future: _restaurantDataFuture,
        //     builder: (context, restaurantSnapshot) {
        //       if (restaurantSnapshot.connectionState ==
        //           ConnectionState.waiting) {
        //         // Show a loading spinner while waiting for the future to complete
        //         return CircularProgressIndicator();
        //       }

        //       final List<Map<String, dynamic>> restaurantData = restaurantSnapshot.data!;

        //       if (restaurantData == null) {
        //         // Show an error message if the data is null
        //         return Text('Total restaurant data is null');
        //       }

        //     return FutureBuilder<List<Map<String, dynamic>>>(
        //       future: _tableDataFuture,
        //       builder: (BuildContext context, snapshot) {
        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return Center(
        //             child: CircularProgressIndicator(),
        //           );
        //         }
        //         if (snapshot.hasError) {
        //           return Center(
        //             child: Text('Error fetching data'),
        //           );
        //         }

        //         if (snapshot.data?.isEmpty ?? true) {
        //           return Center(
        //             child: Text('No restaurants found'),
        //           );
        //         }

        //         final tableInfoList = snapshot.data?.toList() ?? [];
        //         return Column(
        //           children: tableInfoList.map((tableInfo) {
        //             String type = tableInfo['table_type'];
        //             int capacity = tableInfo['capacity'];
        //             int available = tableInfo['available'];
        //             return BookTableItem(type, capacity, available, restaurantData);
        //           }).toList(),
        //         );
        //       },
        //     );
        //     },
        //     ),
        //   ],
        // ),
        //   ),
        // ),
        //     ],
        // ),
        // ),
        );
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
