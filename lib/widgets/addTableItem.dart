import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:quickqueue/model/tableInfo.dart';

class AddTableItem extends StatefulWidget {
  //parameter จากหน้า resConfig
  String type='';
  int person = 0;

  AddTableItem(this.type,this.person);

  //ใช้ส่งข้อมูล setstate ไปหน้า resConfig 
  // final Function(String) onTextTbCpChanged;
  // AddTableItem(this.type,this.person, {Key? key, required this.onTextTbCpChanged}) : super(key: key);

  @override
  State<AddTableItem> createState() => _AddTableItemState();
}

class _AddTableItemState extends State<AddTableItem> {


  //นำค่าไป setstae ใน textfield
  String capacity = '';
  String table_capacity = '';


  // Future _tableCapacityState(String val) {
  //   setState(() => table_capacity = val);
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 190,
          height: 170,
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.cyan.withOpacity(0.3), width: 3),
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
                              Text(widget.person.toString() + " Guest",style: TextStyle(fontSize: 16),),
                            ]),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        width: 150,
                        height: 30,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Number of table',
                          ),
                          onChanged: (val) {
                            setState(() => table_capacity = val);
                            // widget.onTextTbCpChanged(table_capacity);
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
                                  fontSize: 22, fontWeight: FontWeight.bold),
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
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Number of guest',
                          ),
                          onChanged: (val) {
                            setState(() => capacity = val);
                            // widget.onTextTbCpChanged(capacity);
                          },
                        )),
                        SizedBox(
                      height: 5,
                    ),
                        Container(
                        width: 150,
                        height: 30,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                            labelText: 'Number of table',
                          ),
                          onChanged: (val) {
                            setState(() => table_capacity = val);
                            // widget.onTextTbCpChanged(table_capacity);
                          },
                          
                        )
                         
                        ),
                  ],
                ),
        ),
      ],
    );
  }
}

// Future<String> getTableData(String type,String guest){
//   return
// }
