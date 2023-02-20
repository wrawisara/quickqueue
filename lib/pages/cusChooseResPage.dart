import 'package:flutter/material.dart';
import '../model/allRestaurant.dart';
import 'cusBookingPage.dart';

//หน้า CusChooseRes
class CusChooseResPage extends StatefulWidget {
  const CusChooseResPage({super.key});
  @override
  State<CusChooseResPage> createState() => _CusChooseResPageState();
}

class _CusChooseResPageState extends State<CusChooseResPage> {
  //กลุ่มข้อมูล
  // List<AllRestaurant> restaurants = [
  //   AllRestaurant("On The Table", "1", "assets/img/onthetable.jpg"),
  //   AllRestaurant("Fam Time Steak and Pasta", "15", "assets/img/fametime.jpg"),
  //   AllRestaurant("Mo-Mo-Paradise", "30", "assets/img/momo.jpg"),
  // ];
  
  static List<String> restaurantName = [
    'On The Table',
    'Fam Time Steak and Pasta',
    'Mo-Mo-Paradise'
  ];
  static List<int> queueNum = [1, 2, 3];
  static List<String> img = [
    'assets/img/onthetable.jpg',
    'assets/img/fametime.jpg',
    'assets/img/momo.jpg'
  ];

  final List<AllRestaurant> restaurantData = List.generate(
      restaurantName.length,
      (index) => AllRestaurant(
          '${restaurantName[index]}', queueNum[index], '${img[index]}'));

  //แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text('Restaurant', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
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
            IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Want to go Profile')));
              },
            ),
          ]),
      body: Container(
        child: ListView.builder(
            itemCount: restaurantData.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: Text(
                    restaurantData[index].name,
                    style: TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                      "Queue " + restaurantData[index].queueNum.toString()),
                  leading: SizedBox(
                    width: 50,
                    height: 60,
                    child: Image.asset(restaurantData[index].img),
                  ),
                  onTap: () {
                    print('Tapped');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CusBookingPage(allRestaurantModel: restaurantData[index])));
                  },
                ),
              );
            }),
      ),
    );
  }
}





// CustomAppBar(Icons.arrow_back,Icons.search_off_outlined),

//  body: ListView.builder(
//           itemCount: restaurants.length,
//           itemBuilder: (BuildContext context, int index) {
//             AllRestaurant restaurant = restaurants[index];
//             return ListTile(
//                 leading: Image.asset(restaurant.img),
//                 title: Text(
//                   restaurant.name,
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 subtitle: Text(("Queue " + restaurant.queueNum),
//                     style: TextStyle(fontSize: 16)),
//                 onTap: () {
//                   print("choose" + restaurant.name);
//                   navigateToCusBookingPage(context);
//                 });
//           }),


//แบบเก่าใช้งานได้
// class _CusChooseResPageState extends State<CusChooseResPage> {
//   //กลุ่มข้อมูล ย้ายไป return ใน model Allrestaurant
//   List<AllRestaurant> restaurants = [
//     AllRestaurant("On The Table", "1", "assets/img/onthetable.jpg"),
//     AllRestaurant("Fam Time Steak and Pasta", "15", "assets/img/fametime.jpg"),
//     AllRestaurant("Mo-Mo-Paradise", "30", "assets/img/momo.jpg"),
//   ];
//   //แสดงผลข้อมูล
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           iconTheme: IconThemeData(
//             color: Colors.white,
//           ),
//           title: Text('Restaurant', style: TextStyle(color: Colors.white)),
//           actions: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.search_rounded,
//                 color: Colors.white,
//               ),
//               // tooltip: 'Show Snackbar',
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Search Restaurant')));
//                     // method to show the search bar
//               // showSearch(
//               //   context: context,
//               //   // delegate to customize the search bar
//               //   // delegate: CustomSearchDelegate()
//               // );
//               }, 
//             ),
    
//             IconButton(
//               icon: const Icon(
//                 Icons.account_circle_rounded,
//                 color: Colors.white,
//               ),
//               // tooltip: 'Show Snackbar',
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Want to go Profile')));
//               },
//             ),
//           ]),
//       body: Container(
//         child: ListView.builder(
//             itemCount: restaurants.length,
//             itemBuilder: (BuildContext context, int index) {
//               AllRestaurant restaurant = restaurants[index];
//               return ListTile(
//                   leading: Image.asset(restaurant.img),
//                   title: Text(
//                     restaurant.name,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   subtitle: Text(("Queue " + restaurant.queueNum),
//                       style: TextStyle(fontSize: 16)),
//                   onTap: () {
//                     print("choose" + restaurant.name);
//                     navigateToCusBookingPage(context);
//                   });
//             }),
//       ),
//     );
//   }
// }

// navigateToCusBookingPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return CusBookingPage();
//   }));
// }
