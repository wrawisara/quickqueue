import 'package:flutter/material.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';
import 'package:quickqueue/pages/cusProfilePage.dart';
import 'package:quickqueue/pages/loginPage.dart';
import 'package:quickqueue/services/customerServices.dart';
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
  late List<Map<String, dynamic>> _searchResults;

  @override
  void initState() {
    super.initState();
    _restaurantDataFuture = customerServices.getAllRestaurants();
     _searchResults = [];
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
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 20,right: 20),
            child: TextField(
              decoration: InputDecoration(
                labelText : 'Search',suffixIcon: Icon(Icons.search) ,
              ),
              onChanged: _onSearchQueryChanged,
            ),
          ),
          Expanded(
            child: _searchResults.isEmpty 
              ? FutureBuilder<List<Map<String, dynamic>>>(
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
                  return 
                     ListView.builder(
                      itemCount: restaurantData.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> restaurant = restaurantData[index];
                        return Container(
                          height: 90,
                          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                          decoration: new BoxDecoration(
                           color: Colors.cyan.withOpacity(0.1),
                            
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(top: 10,left: 15,right: 20),
                            title: Text(
                              restaurant['username'],
                              style: TextStyle(fontSize: 22),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  
                                  // width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                              color: Color.fromRGBO(72, 210, 157, 1).withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    //ใส่ queue
                                    "20 queue",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            leading: Container(
                              width: 90,
                              height: MediaQuery.of(context).size.height,
                           
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
                                      builder: (context) => CusBookingPage(
                                          restaurant: restaurant)));
                            },
                          ),
                        );
                      },
                    );
                }
                )
            :  ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> restaurant = _searchResults[index];
                        return Container(
                          height: 90,
                          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                          decoration: new BoxDecoration(
                           color: Colors.cyan.withOpacity(0.1),
                            
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.only(top: 10,left: 15,right: 20),
                            title: Text(
                              restaurant['username'],
                              style: TextStyle(fontSize: 22),
                            ),
                            subtitle: Row(
                              children: [
                                Container(
                                  
                                  // width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                              color: Color.fromRGBO(72, 210, 157, 1).withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    //ใส่ queue
                                    "20 queue",
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            leading: Container(
                              width: 90,
                              height: MediaQuery.of(context).size.height,
                           
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
                                      builder: (context) => CusBookingPage(
                                          restaurant: restaurant)));
                            },
                          ),
                        );
                      }
                    
                
                )
            
          ),
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

