// import 'package:flutter/material.dart';
// import 'class/AllRestaurant.dart';

// void main() {
//   runApp(const Myapp());
// }

// //สร้าง widget เอง
// class Myapp extends StatelessWidget {
//   const Myapp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: "Quick Queue",
//       home: LoginPage(),
//       theme: ThemeData(primarySwatch: Colors.cyan),
//     );
//   }
// }

// //หน้า login
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Login', style: TextStyle(color: Colors.white)),
//         ),
//         body: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
//                   child: Text(
//                     "Quick Queue",
//                     style: TextStyle(fontSize: 40, color: Colors.cyan),
//                   )),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(90.0),
//                     ),
//                     labelText: 'Email',
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                 child: TextField(
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(90.0),
//                     ),
//                     labelText: 'Password',
//                   ),
//                 ),
//               ),
//               Container(
//                   height: 80,
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                     child: const Text('Log In',style: TextStyle(color: Colors.white)),
//                     onPressed: () {
//                       navigateToCusChooseResPage(context);
//                     },
//                   )),
//               Container(
//                   height: 80,
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                     child: const Text('Sign In',style: TextStyle(color: Colors.white)),
//                     onPressed: () {
                     
//                     },
//                   )),
//               TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   'or Register for Restaurant ',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }

// navigateToCusChooseResPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return CusChooseResPage();
//   }));
// }

// //หน้า CusChooseRes
// class CusChooseResPage extends StatefulWidget {
//   const CusChooseResPage({super.key});
//   @override
//   State<CusChooseResPage> createState() => _CusChooseResPageState();
// }

// class _CusChooseResPageState extends State<CusChooseResPage> {
//   //กลุ่มข้อมูล
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
//         title: const Text(
//           "Restaurant",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: ListView.builder(
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
//                   navigateToSecondPage(context);
//                 });
//           }),
//     );
//   }
// }

// navigateToSecondPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     return MySecondPage();
//   }));
// }

// class MySecondPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(
//             "Booking",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         body: Container(
//             child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Hello, Second Page',
//                 style: TextStyle(fontSize: 22),
//               ),
//             ],
//           ),
//         )));
//   }
// }













