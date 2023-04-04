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
                            child: Text('No restaurant data was found'),
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
                                              child: Text(
                                                '${queueNum} QUEUE',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                          22, 197, 130, 1)
                                                      .withOpacity(0.8),
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
                                        ),
                                        trailing: Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color:
                                                // Color.fromRGBO(
                                                //                 47, 212, 149, 1).withOpacity(0.7),
                                                Colors.cyan.withOpacity(0.7),
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Book",
                                              style: new TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
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
                                    height: 100,
                                    margin: EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    decoration: new BoxDecoration(
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
                                              child: Text(
                                                '${queueNum} QUEUE',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color.fromRGBO(
                                                          22, 197, 130, 1)
                                                      .withOpacity(0.8),
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
                                        ),
                                        trailing: Container(
                                          width: 60.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color:
                                                // Color.fromRGBO(
                                                //                 47, 212, 149, 1).withOpacity(0.7),
                                                Colors.cyan.withOpacity(0.7),
                                            border: Border.all(
                                                color: Colors.white, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Book",
                                              style: new TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ),
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
