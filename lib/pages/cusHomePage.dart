import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';
import 'package:quickqueue/pages/cusReDeemCouponPage.dart';
import 'package:quickqueue/pages/resAddCouponPage.dart';
import 'package:quickqueue/pages/resMainpage.dart';
import 'package:quickqueue/pages/resManageQueue.dart';
import 'package:quickqueue/pages/resConfigTable.dart';



class CusHomePage extends StatefulWidget {
  const CusHomePage({super.key});

  @override
  State<CusHomePage> createState() => _CusHomePageState();
}

class _CusHomePageState extends State<CusHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    GoCusChooseResPage(),
    GoPage1(),
    
    
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
              icon: Icon(Icons.bookmark_add_rounded),
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
    return GoCusChooseResPage();
  }
}

class GoPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("page1"),
    );
  }
}

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
