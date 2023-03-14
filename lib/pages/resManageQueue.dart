import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:quickqueue/model/booking.dart';
import 'package:quickqueue/widgets/resQueueTable.dart';

class ResManageQueue extends StatefulWidget {

  @override
  State<ResManageQueue> createState() => _ResManageQueueState();
}

class _ResManageQueueState extends State<ResManageQueue> {

  int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        automaticallyImplyLeading: false, 
        iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Reservation",
            style: TextStyle(color: Colors.white),
          ),
          actions:  <Widget>[
            IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search Restaurant')));
                // method to show the search bar
                // showSearch(
                //   context: context,
                //   // delegate to customize the search bar
                //   // delegate: CustomSearchDelegate()
                // );
              },
            ),
          ]
        ),
        body: ResQueueTable(),
      );
  }
}