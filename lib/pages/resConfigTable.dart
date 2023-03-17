import 'package:flutter/material.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/model/tableInfo.dart';
import 'package:quickqueue/widgets/addTableItem.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/services/restaurantServices.dart';

class ResConfigTablePage extends StatefulWidget {
  var selected = 0;
  Map<String, int> tableCapacities =
      {}; // map to store the capacities of each type of table
  Map<String, int> e_capacities = {};
  @override
  State<ResConfigTablePage> createState() => _ResConfigTablePageState();
}

class _ResConfigTablePageState extends State<ResConfigTablePage> {
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();
  final RestaurantServices restaurantServices = RestaurantServices();

  //เรียกไว้รอทำ alert
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // static const String _title = 'Tooltip Sample';

  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;
  var eSeats = null;
  var eTableNum = null;

  // เรียกข้อมูล tableinfo มาใช้
  final TableInfo tableInfo = TableInfo.generateTableInfo();

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Configuration', style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: false, // Disable the back icon
        ),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      'Table Type(Max seat)',
                      style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  // TooltipSample(),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 15),
                    child: Text(
                      'Enter a number to indicate the number of tables for each table format.',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 11, right: 10, top: 10),
                      child: Row(
                        children: [
                          AddTableItem(
                            'A',
                            2,
                            onTableCapacityChanged: (tableCapacity) {
                              setState(() {
                                widget.tableCapacities['A'] = tableCapacity;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AddTableItem(
                            'B',
                            4,
                            onTableCapacityChanged: (capacity) {
                              setState(() {
                                widget.tableCapacities['B'] = capacity;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 11, right: 10, top: 10),
                      child: Row(
                        children: [
                          AddTableItem(
                            'C',
                            6,
                            onTableCapacityChanged: (capacity) {
                              setState(() {
                                widget.tableCapacities['C'] = capacity;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AddTableItem(
                            'D',
                            8,
                            onTableCapacityChanged: (capacity) {
                              setState(() {
                                widget.tableCapacities['D'] = capacity;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 11, right: 10, top: 10),
                      child: Row(
                        children: [
                          AddTableItem(
                            'E',
                            10,
                            onTableCapacityChanged: (tablecapacity) {
                              setState(() {
                                eTableNum = tablecapacity;
                              });
                            },
                            onCapacityChanged: (capacity) {
                              setState(() {
                                widget.e_capacities['E'] = capacity;
                                eSeats = capacity;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                      width: 230,
                      height: 50,
                      borderRadius: BorderRadius.circular(32),
                      child: const Text('Save',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        print(widget.tableCapacities);
                        print(widget.e_capacities);

                        if (currentUser != null && currentUser.uid != null) {
                          if (eSeats == null ||
                              eSeats == 0 && eTableNum == null ||
                              eTableNum == 0) {
                            restaurantServices.setTableInfo(
                                currentUser.uid, widget.tableCapacities);
                          } else {
                            restaurantServices.setTableInfoForTableE(
                                currentUser.uid,
                                widget.e_capacities,
                                eTableNum,
                                widget.tableCapacities);
                          }
                        } else {
                          // final snackBar = SnackBar(
                          //   content: Text(
                          //       'All fields can only contain numeric values'),
                          //   duration: Duration(seconds: 2),
                          // );
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        // if (int.tryParse(table_capacity) == null) {
                        //   showDialog<String>(
                        //     context: context,
                        //     builder: (BuildContext context) => AlertDialog(
                        //       title: const Text('Sucess'),
                        //       content: const Text('Your Table Success'),
                        //     ),
                        //   );
                        // } else {
                        //   showDialog<String>(
                        //     context: context,
                        //     builder: (BuildContext context) => AlertDialog(
                        //       title: const Text('Error'),
                        //       content: const Text(
                        //           'All fields can only contain numeric values'),
                        //     ),
                        //   );
                        // }

                        //** ใส่ที่จะบันทึกข้อมูล */
                        // alert แจ้งเตือนบันทึกสำเร็จ ใช้ได้ค่อยเปิด
                        // showDialog<String>(
                        //   context: context,
                        //   builder: (BuildContext context) => AlertDialog(
                        //     title: const Text('Sucess'),
                        //     content: const Text('Your Table Success'),
                        //   ),
                        // );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ));
  }
}
