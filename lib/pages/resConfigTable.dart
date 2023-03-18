import 'package:flutter/material.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/model/tableInfo.dart';
import 'package:quickqueue/widgets/addTableItem.dart';
import 'package:quickqueue/widgets/customElevatedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/services/restaurantServices.dart';

class ResConfigTablePage extends StatefulWidget {
  var selected = 0;
  Map<String, dynamic> tableCapacities =
      {}; // map to store the capacities of each type of table
  Map<String, dynamic> e_capacities = {};
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

  //reload page
  void reloadPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => ResConfigTablePage(),
      ),
    );
  }

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
                        print("capa ${widget.tableCapacities}");
                        print("E : ${widget.e_capacities}");

                        bool allTableValuesAreNumbers = true;
                        bool allTableEValuesAreNumbers = true;
                        for (var entry in widget.tableCapacities.entries) {
                          print('${entry.key}: ${entry.value}');
                          if (int.tryParse(entry.value.toString()) == null) {
                            print(allTableValuesAreNumbers);
                            allTableValuesAreNumbers = false;
                            break;
                          }
                        }
                        for (var entry in widget.e_capacities.entries) {
                          print('${entry.key}: ${entry.value}');
                          if (int.tryParse(entry.value.toString()) == null) {
                            print(allTableEValuesAreNumbers);
                            allTableEValuesAreNumbers = false;
                            break;
                          }
                        }

                        print(allTableValuesAreNumbers);
                        print(allTableEValuesAreNumbers);

                        if (allTableValuesAreNumbers & allTableEValuesAreNumbers) {
                          print("allValue ${widget.tableCapacities}");
                          //แปลง type Map<String,dynamic> ==> Map<String,int>
                          Map<String, int> tableCapacities = widget
                              .tableCapacities
                              .map((key, value) => MapEntry(key, value as int));
                          Map<String, int> e_capacities = widget.e_capacities
                              .map((key, value) => MapEntry(key, (value as int?) ?? 0));
                          if (currentUser != null && currentUser.uid != null) {
                            if (eSeats == null ||
                                eSeats == 0 && eTableNum == null ||
                                eTableNum == 0) {
                              print("save ${widget.tableCapacities}");

                              restaurantServices.setTableInfo(
                                  currentUser.uid, tableCapacities);
                            } else {
                             print("save table E ${widget.tableCapacities}");
                                restaurantServices.setTableInfoForTableE(
                                    currentUser.uid,
                                    e_capacities,
                                    eTableNum,
                                    tableCapacities);
                              
                            }
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Sucess'),
                                content: const Text('Your Table Success'),
                              ),
                            );
                          }
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'All fields can only contain numeric values'),
                              // actions: <Widget>[
                              //   TextButton(
                              //     onPressed: () {
                              //       Navigator.of(context).pop();
                              //       reloadPage();
                              //     },
                              //     child: const Text('OK'),
                              //   ),
                              // ],
                            ),
                          );
                        }
                        // } catch (e) {
                        //   if (e.toString() ==
                        //       'Exception: All fields can only contain numeric values') {
                        //     showDialog<String>(
                        //       context: context,
                        //       builder: (BuildContext context) => AlertDialog(
                        //         title: const Text('Error'),
                        //         content: const Text(
                        //             'All fields can only contain numeric values'),
                        //       ),
                        //     );
                        //   }
                        // }
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
