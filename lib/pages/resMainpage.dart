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
  var selected = 0;
  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid != null) {
      _tableDataFuture = restaurantServices.getAllTableInfo(currentUser.uid);
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
                //showLogoutAlertDialog(context);
              },
            ),
          ]),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: [
                RestaurantInfo(),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
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
                    future: _tableDataFuture,
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
                          child: Text('No restaurants found'),
                        );
                      }

                      final tableInfoList = snapshot.data?.toList() ?? [];
                      return Column(
                        children: tableInfoList.map((tableInfo) {
                          String type = tableInfo['table_type'];
                          int capacity = tableInfo['capacity'];
                          int available = tableInfo['available'];
                          return BookTableItem(type, capacity, available);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
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

showAlertDialog(BuildContext context) {
  Widget continueButton = TextButton(
    child: Text("Yes"),
    onPressed: () {
      authenServices.logout;
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
