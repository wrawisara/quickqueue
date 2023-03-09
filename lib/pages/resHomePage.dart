import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/pages/resAddCouponPage.dart';
import 'package:quickqueue/pages/resMainpage.dart';
import 'package:quickqueue/pages/resManageQueue.dart';

import 'resConfigTable.dart';

class ResHomePage extends StatefulWidget {
  const ResHomePage({super.key});

  @override
  State<ResHomePage> createState() => _ResHomePageState();
}

class _ResHomePageState extends State<ResHomePage> {
  int _currentIndex = 0;
  late PageController _pageController;

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    GoResMainPage(),
    Page2(),
    GoResManageQueuePage(),
    GoAddCouponPage(),
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
              icon: Icon(Icons.power_settings_new_rounded),
              label: 'Open/Close',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_card_rounded),
              label: 'Add Coupon',
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

class GoResMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResMainPage();
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Page 2'),
    );
  }
}

class GoResManageQueuePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResManageQueue(),
    );
  }
}

class GoAddCouponPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResAddCouponPage();
  }
}

navigateToResConfigTablePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ResConfigTablePage();
  }));
}




// navigateToResMainPage(BuildContext context) {
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => ResMainPage()));
// }

// navigateToResManageQueue(BuildContext context) {
//   Navigator.of(context)
//       .push(MaterialPageRoute(builder: (context) => ResManageQueue()));
// }
