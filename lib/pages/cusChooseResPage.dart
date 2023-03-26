import 'package:flutter/material.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:quickqueue/utils/color.dart';
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
  final BookingServices bookingServices = BookingServices();

  late Future<List<Map<String, dynamic>>> _restaurantDataFuture;
  late Future<Map<String, int>> _queueDataFuture;
  late List<Map<String, dynamic>> _searchResults;

  @override
  void initState() {
    super.initState();
    _restaurantDataFuture = customerServices.getAllRestaurants();
    _searchResults = [];

    _queueDataFuture = _restaurantDataFuture.then((restaurantData) {
      final resIds =
          restaurantData.map<String>((res) => res['r_id'] as String).toList();
      return bookingServices.getTotalBookingQueue(resIds);
    });
  }

  //search box
  void _onSearchQueryChanged(String query) {
    _restaurantDataFuture.then((restaurantData) {
      setState(() {
        _searchResults = restaurantData.where((restaurant) {
          final name = restaurant['username'].toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower);
        }).toList();
      });
    });
  }

  //แสดงผลข้อมูล
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false, // Disable the back icon
          title: Text('Restaurant', style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
              ),
              // tooltip: 'Show Snackbar',
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text('Want to go My booked')));

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CusProfilePage()));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                showLogoutAlertDialog(context);
              },
            ),
          ]),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchQueryChanged,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: _searchResults.isEmpty
                  ? FutureBuilder<List<Map<String, dynamic>>>(
                      future: _restaurantDataFuture,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        List<Map<String, dynamic>> restaurantData =
                            snapshot.data ?? [];
                        return FutureBuilder<Map<String, int>>(
                            future: _queueDataFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, int>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error fetching data'),
                                );
                              }

                              final queueData = snapshot.data ?? {};
                              final totalQueue = queueData.values
                                  .fold(0, (sum, queue) => sum + queue);
                              print(queueData);
                              return ListView.builder(
                                itemCount: restaurantData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> restaurant =
                                      restaurantData[index];
                                  final queueNum =
                                      queueData[restaurant['r_id']] ?? 0;
                                  return Container(
                                    height: 100,
                                    margin: EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    decoration: new BoxDecoration(
                                      // border: Border.all(
                                      //   color: Colors.black.withOpacity(0.4),
                                      //   width: 1,
                                      // ),
                                      // color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.1),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      color: cyanPrimaryLight,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.only(
                                            top: 10, left: 15, right: 20),
                                        title: Text(
                                          restaurant['username'],
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(3),
                                              // decoration: BoxDecoration(
                                              //   color: Color.fromRGBO(
                                              //           72, 210, 157, 1)
                                              //       .withOpacity(0.9),
                                              //   borderRadius:
                                              //       BorderRadius.circular(5),
                                              // ),
                                              child: Text(
                                                '${queueNum} QUEUE',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color:
                                                Color.fromRGBO(22, 197, 130, 1).withOpacity(0.8),
                                                      // Color.fromARGB(255, 18, 182, 157),
                                                      // Color.fromRGBO(47, 212, 149, 1).withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        leading: Container(
                                          decoration: new BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    restaurant['res_logo']),
                                              )),
                                          width: 60,
                                          height: 90,
                                          // height: MediaQuery.of(context)
                                          //     .size
                                          //     .height,
                                          // child: Image.network(
                                          //   restaurant['res_logo'],
                                          //   fit: BoxFit.contain,
                                          //   width: 90,
                                          //   height: 90,
                                          // ),
                                        ),
                                        trailing: InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: 60.0,
                                            height: 40.0,
                                            decoration: new BoxDecoration(
                                              color:
                                              Color.fromRGBO(
                                                              47, 212, 149, 1).withOpacity(0.7),
                                                  // Colors.cyan.withOpacity(0.7),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Book",
                                                style: new TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Icon(
                                        //   Icons.add,
                                        //   color: Colors
                                        //       .grey, // set color of icon here
                                        // ),
                                        onTap: () {
                                          try {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CusBookingPage(
                                                            restaurant:
                                                                restaurant)));
                                          } catch (e) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: Text(e.toString()),
                                                  actions: [],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      })
                  : FutureBuilder<List<Map<String, dynamic>>>(
                      future: _restaurantDataFuture,
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                        List<Map<String, dynamic>> restaurantData =
                            snapshot.data ?? [];
                        return FutureBuilder<Map<String, int>>(
                            future: _queueDataFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<Map<String, int>> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error fetching data'),
                                );
                              }

                              final queueData = snapshot.data ?? {};
                              final totalQueue = queueData.values
                                  .fold(0, (sum, queue) => sum + queue);
                              print(queueData);
                              return ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map<String, dynamic> restaurant =
                                      _searchResults[index];
                                  final queueNum =
                                      queueData[restaurant['r_id']] ?? 0;
                                  return Container(
                                    height: 90,
                                    margin: EdgeInsets.only(
                                        top: 20, left: 10, right: 10),
                                    decoration: new BoxDecoration(
                                      color: Colors.cyan.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.only(
                                          top: 10, left: 15, right: 20),
                                      title: Text(
                                        restaurant['username'],
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                      72, 210, 157, 1)
                                                  .withOpacity(0.9),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              '${queueNum} queue',
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      leading: Container(
                                        width: 90,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Image.network(
                                          restaurant['res_logo'],
                                          fit: BoxFit.contain,
                                          width: 90,
                                          height: 90,
                                        ),
                                      ),
                                      onTap: () {
                                        // TODO: navigate to booking page
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CusBookingPage(
                                                        restaurant:
                                                            restaurant)));
                                      },
                                    ),
                                  );
                                },
                              );
                            });
                      })),
        ],
      ),
    );
  }
}

navigateToLoginPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return LoginPage();
  }));
}

showLogoutAlertDialog(BuildContext context) {
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
