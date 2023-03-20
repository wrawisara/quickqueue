import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/model/tableInfo.dart';
import 'package:quickqueue/pages/resConfigTable.dart';

class AddTableItem extends StatefulWidget {
  //parameter จากหน้า resConfig
  String type = '';
  int person = 0;
  // String capacity = '';
  // String table_capacity = '';
  final Function(dynamic)? onCapacityChanged;
  final VoidCallback? onInvalidInput;

  final Function(dynamic) onTableCapacityChanged; // new callback function
  AddTableItem(this.type, this.person,
      {required this.onTableCapacityChanged,
      this.onCapacityChanged,
      this.onInvalidInput});

  // String getTableCapacity(){
  //   return table_capacity;
  // }

  //ใช้ส่งข้อมูล setstate ไปหน้า resConfig
  // final Function(String) onTextTbCpChanged;
  // AddTableItem(this.type,this.person, {Key? key, required this.onTextTbCpChanged}) : super(key: key);

  @override
  State<AddTableItem> createState() => _AddTableItemState();
}

class _AddTableItemState extends State<AddTableItem> {
  TextEditingController _tableCapacityController = TextEditingController();

  // เอา alert ไปโชว์หน้า ResConfigTablePage
//   void showAlert() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Invalid Input'),
//         content: Text('All fields can only contain numeric values'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text('OK'),
//           ),
//         ],
//       );
//     },
//   );
// }

  //นำค่าไป setstae ใน textfield

  @override
  void dispose() {
    _tableCapacityController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 180,
          height: 170,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 2),
            borderRadius: BorderRadius.circular(40.0),
          ),
          margin: EdgeInsets.only(top: 5),
          // padding: EdgeInsets.symmetric(horizontal: 25),
          child: widget.type != 'E'
              ? Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRect(
                          child: Icon(
                            Icons.table_restaurant,
                            size: 60,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Table " + widget.type,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              Text(
                                widget.person.toString() + " Seats",
                                style: TextStyle(fontSize: 16),
                              ),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 140,
                        height: 30,
                        child: TextField(
                          controller: _tableCapacityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Number of table',
                          ),
                          onChanged: (value) {
                            print("addTable: " + value);
                            if (int.tryParse(value) != null) {
                              print("int" + value);
                              widget.onTableCapacityChanged(
                                  int.tryParse(value) ?? 0);
                            } else {
                              widget.onTableCapacityChanged(null);
                              //  print("throw");
                              //  throw Exception('All fields can only contain numeric values');
                            }
                          },
                        )),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRect(
                          child: Icon(
                            Icons.table_restaurant,
                            size: 60,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Table " + widget.type,
                              style: TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(children: [
                              Text("Customize"),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: 150,
                        height: 30,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Number of seats',
                          ),
                          onChanged: (value) {
                             print("addTable: " + value);
                             if (int.tryParse(value) != null) {
                              print("int" + value);
                                widget.onCapacityChanged!(int.tryParse(value) ?? 0);
                            } else {
                              widget.onCapacityChanged!(null);
                            }
                          },
                        )),
                    SizedBox(
                      height: 6,
                    ),
                    Container(
                        width: 150,
                        height: 30,
                        child: TextField(
                          controller: _tableCapacityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            labelText: 'Number of table',
                          ),
                          onChanged: (value) {
                            if (int.tryParse(value) != null) {
                              print("int" + value);
                              widget.onTableCapacityChanged(
                                  int.tryParse(value) ?? 0);
                            } else {
                              widget.onTableCapacityChanged(value);
                            }
                          },
                        )),
                  ],
                ),
        ),
      ],
    );
  }
}
