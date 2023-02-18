import 'package:flutter/material.dart';
import '../model/AllRestaurant.dart';

//หน้า CusChooseRes
class CusChooseResPage extends StatefulWidget {
  const CusChooseResPage({super.key});
  @override
  State<CusChooseResPage> createState() => _CusChooseResPageState();
}

class _CusChooseResPageState extends State<CusChooseResPage> {
  //กลุ่มข้อมูล
  List<AllRestaurant> restaurants = [
    AllRestaurant("On The Table", "1", "assets/img/onthetable.jpg"),
    AllRestaurant("Fam Time Steak and Pasta", "15", "assets/img/fametime.jpg"),
    AllRestaurant("Mo-Mo-Paradise", "30", "assets/img/momo.jpg"),
  ];
  //แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Restaurant",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (BuildContext context, int index) {
            AllRestaurant restaurant = restaurants[index];
            return ListTile(
                leading: Image.asset(restaurant.img),
                title: Text(
                  restaurant.name,
                  style: TextStyle(fontSize: 20),
                ),
                subtitle: Text(("Queue " + restaurant.queueNum),
                    style: TextStyle(fontSize: 16)),
                onTap: () {
                  // print("choose" + restaurant.name);
                  // navigateToSecondPage(context);
                });
          }),
    );
  }
}

// navigateToSecondPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
   
//   }));
// }
