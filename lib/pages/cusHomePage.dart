import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';
import 'package:quickqueue/pages/cusBookingPage.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
import 'package:quickqueue/pages/cusMyBookedPage.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/cusReDeemCouponPage.dart';
import 'package:quickqueue/pages/resAddCouponPage.dart';
import 'package:quickqueue/pages/resMainpage.dart';
import 'package:quickqueue/pages/resManageQueue.dart';
import 'package:quickqueue/pages/resConfigTable.dart';
import 'package:quickqueue/services/customerServices.dart';

class CusHomePage extends StatefulWidget {
  @override
  State<CusHomePage> createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  //เรียกข้อมูลมาใช้


  int _selectedIndex = 0;
  final List<Widget> _pages = [
    GoCusChooseResPage(),
    GoCusMyBookedPage(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              
              icon: Icon(Icons. bookmark_add_rounded),
              label: 'My Booked',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.cyan,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class GoCusChooseResPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CusChooseResPage();
  }
}

class GoCusMyBookedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CusMyBookedPage();
  }
}

// class GoCusRedeemPage extends StatefulWidget {


//   @override
//   State<GoCusRedeemPage> createState() => _GoCusRedeemPageState();
// }

// class _GoCusRedeemPageState extends State<GoCusRedeemPage> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:  Text(
//                       'booking page',
//                         style: TextStyle(
//                             fontSize: 30,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black),
//                       ),
//     );
        
//   }
// }

// class GoCusBookedPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return CusBookedPage();
//   }
// }

// navigateToResConfigTablePage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return ResConfigTablePage();
//   }));
// }




// navigateToResMainPage(BuildContext context) {
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => ResMainPage()));
// }

// navigateToResManageQueue(BuildContext context) {
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => ResManageQueue()));
// }
