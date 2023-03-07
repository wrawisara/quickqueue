import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/pages/resConfigTable.dart';
import 'package:quickqueue/widgets/addTableItem.dart';
import 'package:quickqueue/widgets/bookTableItem.dart';
import 'package:quickqueue/widgets/couponListView.dart';
import 'package:quickqueue/widgets/numberOfQueue.dart';
import 'package:quickqueue/widgets/restaurantInfo.dart';

class ResMainPage extends StatefulWidget {
  const ResMainPage({super.key});

  @override
  State<ResMainPage> createState() => _ResMainPageState();
}

class _ResMainPageState extends State<ResMainPage> {
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  var selected = 0;
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
                  BookTableItem('A', 2, 10),
                  BookTableItem('B', 4, 10),
                  BookTableItem('C', 6, 10),
                  BookTableItem('D', 8, 10),
                  BookTableItem('E', 10, 10),
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

