import 'package:flutter/material.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/services/customerServices.dart';
import '../model/restaurantList.dart';
import 'cusBookingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

//หน้า CusChooseRes
class CusChooseResPage extends StatefulWidget {
  // Pass the current User
  const CusChooseResPage({Key? key}) : super(key: key);

  //const CusChooseResPage({super.key});
  @override
  State<CusChooseResPage> createState() => _CusChooseResPageState();
}

class _CusChooseResPageState extends State<CusChooseResPage> {
  // Get data from Firebase
  final CustomerServices customerServices = CustomerServices();

  late Future<List<Map<String, dynamic>>> _restaurantDataFuture;

  //กลุ่มข้อมูล
  // static List<String> restaurantName = [
  //   'On The Table',
  //   'Fam Time Steak and Pasta',
  //   'Mo-Mo-Paradise'
  // ];
  // static List<int> queueNum = [1, 2, 3];
  // static List<String> img = [
  //   'assets/img/onthetable.jpg',
  //   'assets/img/fametime.jpg',
  //   'assets/img/momo.jpg'
  // ];

  // final List<AllRestaurant> restaurantData = List.generate(
  //     restaurantName.length,
  //     (index) => AllRestaurant(
  //         '${restaurantName[index]}', queueNum[index], '${img[index]}'));

  @override
  void initState() {
    super.initState();
    _restaurantDataFuture = customerServices.getAllRestaurants();
  }

  //แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false, // Disable the back icon
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
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Want to go Profile')));
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CusProfilePage()));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.bookmark_add_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Want to go Booking History')));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                showAlertDialog(context);
              },
            ),
          ]),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _restaurantDataFuture,
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error fetching data'),
              );
            }

            if (snapshot.data?.isEmpty ?? true) {
              return Center(
                child: Text('No restaurants found'),
              );
            }

            List<Map<String, dynamic>> restaurantData = snapshot.data ?? [];
            return ListView.builder(
              itemCount: restaurantData.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> restaurant = restaurantData[index];
                print("Heelo" + restaurant['username']);
                return Card(
                  child: ListTile(
                    title: Text(
                      restaurant['username'],
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      restaurant['address'],
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: SizedBox(
                      width: 50,
                      height: 60,
                      child: Image.network(
                        restaurant['res_logo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    onTap: () {
                      print('Tapped');
                      // TODO: navigate to booking page
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CusBookingPage(restaurant: restaurant)));
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}


navigateToLoginPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return LoginPage();
  }));
}

  showAlertDialog(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        navigateToLoginPage(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
         Navigator.pop(context, false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign Out"),
      content: Text("Would you like to sign out ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

// navigateToCusBookingPage(BuildContext context) {
//   Navigator.push(context, MaterialPageRoute(builder: (context) {
//     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CusBookingPage(allRestaurantModel: restaurantData[index])));
//   }));
// }



// body เดิม ใช้ได่
// Container(
//         child: ListView.builder(
//             itemCount: restaurantData.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Card(
//                 child: ListTile(
//                   title: Text(
//                     restaurantData[index].name,
//                     style: TextStyle(fontSize: 20),
//                   ),
//                   subtitle: Text(
//                       "Queue " + restaurantData[index].queueNum.toString(), style: TextStyle(fontSize: 18)),
//                   leading: SizedBox(
//                     width: 50,
//                     height: 60,
//                     child: Image.asset(restaurantData[index].img), ),
                  
//                   onTap: () {
//                     print('Tapped');
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CusBookingPage(allRestaurantModel: restaurantData[index])));
//                   },
//                 ),
//               );




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
