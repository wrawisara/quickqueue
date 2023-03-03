import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/pages/cusChooseResPage.dart';
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
  //ใช้กับ button bar
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  //  final List<Widget> _widgetOptions = [
  //    Column(
  //         children: [
  //           RestaurantInfo(),
  //           SizedBox(height: 20,),
  //           BookTableItem('A',2,10),
  //         ],
  //       ),
  //       Text('open/close'),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Main Page', style: TextStyle(color: Colors.white)),
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
                    child: Text("Table Reservation",style: TextStyle(color: Colors.black, fontSize: 22 , fontWeight: FontWeight.bold),),
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
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.cyan,
        onTap: _onItemTapped,
      ),
    );
  }
}

navigateToResConfigTablePage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ResConfigTablePage();
  }));
}
