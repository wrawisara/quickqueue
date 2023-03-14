import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/pages/resConfigTable.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:quickqueue/widgets/bookTableItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickqueue/widgets/numberOfQueue.dart';
import 'package:quickqueue/widgets/restaurantInfo.dart';

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
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                navigateToResConfigTablePage(context);
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                showAlertDialog(context);
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
