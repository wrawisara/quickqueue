import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quickqueue/model/Customer.dart';
import 'package:quickqueue/model/tableInfo.dart';
import 'package:quickqueue/widgets/addTableItem.dart';
import 'package:quickqueue/widgets/couponListView.dart';
import 'package:quickqueue/widgets/restaurantInfo.dart';
import 'package:quickqueue/widgets/tooltipButton.dart';

class ResConfigTablePage extends StatefulWidget {
  ResConfigTablePage({super.key});

  @override
  State<ResConfigTablePage> createState() => _ResConfigTablePageState();
}

class _ResConfigTablePageState extends State<ResConfigTablePage> {
  //เรียกข้อมูลมาใช้
  final customer = Customer.generateCustomer();

  // static const String _title = 'Tooltip Sample';

  //เรียก List คูปองทั้งหมดมาใช้ selected ไล่ index
  var selected = 0;

  //เรียกใช้ value จาก textfield ของหน้า AddItem
  String capacity = '';
  String table_capacity = '';

  // เรียกข้อมูล tableinfo มาใช้
  final TableInfo tableInfo = TableInfo.generateTableInfo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Configuration', style: TextStyle(color: Colors.white)),
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
                            // onTextTbCpChanged: (String) {
                            //   table_capacity;
                            // },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AddTableItem(
                            'B',
                            4,
                            // onTextTbCpChanged: (String) {
                            //   table_capacity;
                            // },
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
                            // onTextTbCpChanged: (String) {
                            //   table_capacity;
                            // },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AddTableItem(
                            'D',
                            8,
                            // onTextTbCpChanged: (String) {
                            //   table_capacity;
                            // },
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
                            // onTextTbCpChanged: (String) {
                            //   table_capacity;
                            // },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // primary: Colors.green,
                        // elevation: 3,
                        minimumSize: Size(280, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                      child: const Text('Save',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () {
                        if (int.tryParse(table_capacity) == null) {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Sucess'),
                              content: const Text('Your Table Success'),
                            ),
                          );
                        } else {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'All fields can only contain numeric values'),
                            ),
                          );
                        }

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


//ใช้ได้แต่เลื่อนจอไม่ได้
// Widget build(BuildContext context) {
//     return Scaffold(
//         resizeToAvoidBottomInset: false,
//         appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white,
//           ),
//           title: Text('Configuration', style: TextStyle(color: Colors.white)),
//         ),
//         backgroundColor: Colors.white,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 15),
//                   child: Text(
//                     'Table Type(Max seat)',
//                     style: TextStyle(
//                         color: Colors.cyan,
//                         fontSize: 25,
//                         fontWeight: FontWeight.w600),
//                   ),
//                 ),
//                 // TooltipSample(),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 40, right: 15),
//                   child: Text(
//                     'Enter a number to indicate the number of tables for each table format.',
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 11, right: 10, top: 10),
//               child: Row(
//                 children: [
//                   AddTableItem('A', 2),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   AddTableItem('B', 4),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 11, right: 10, top: 10),
//               child: Row(
//                 children: [
//                   AddTableItem('C', 6),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   AddTableItem('D', 8),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 11, right: 10, top: 10),
//               child: Row(
//                 children: [
//                   AddTableItem('E', 10),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }
// }
