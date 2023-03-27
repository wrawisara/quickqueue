import 'package:quickqueue/services/bookingServices.dart';
import 'package:quickqueue/services/customerServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickqueue/pages/cusBookedPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:quickqueue/services/restaurantServices.dart';
import 'package:url_launcher/url_launcher.dart';

class CusBookingPage extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const CusBookingPage({Key? key, required this.restaurant}) : super(key: key);

// final List<Map<String, dynamic>> allRestaurantModel;

  @override
  State<CusBookingPage> createState() => _CusBookingPageState();
}

class _CusBookingPageState extends State<CusBookingPage> {
  final CustomerServices customerServices = CustomerServices();
  final BookingServices bookingServices = BookingServices();
  final RestaurantServices restaurantServices = RestaurantServices();
  //เรียกข้อมูล booking มาใช้

  late Future<List<Map<String, dynamic>>> _bookingDataFuture;
  late Future<List<Map<String, dynamic>>> _restaurantDataFuture;
  late Future<Map<String, int>> _queueDataFuture;
  late List<Map<String, dynamic>> _searchResults;
  int numberPerson = 0;

  void updateNumberOfPersons(int value) {
    setState(() {
      numberPerson = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _restaurantDataFuture = customerServices.getAllRestaurants();
   
    _queueDataFuture = _restaurantDataFuture.then((restaurantData) {
      final resId =
          restaurantData.map<String>((res) => res['r_id'] as String).toList();
      return bookingServices.getTotalBookingQueue(resId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Booking",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: ClipRRect(
          child: Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.restaurant['res_logo']),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.cyan[200],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.restaurant['username'],
                    //widget.restaurant.restaurantName,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: Text(
                          "Previous Queue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FutureBuilder<Map<String, int>>(
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
                            final queueNum =
                                queueData[widget.restaurant['r_id']] ?? 0;
                            return Container(
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(
                                                      72, 210, 157, 1)
                                                  .withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text(
                                  '${queueNum} queue',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ));
                          }),
                    ],
                  ),
                  
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          widget.restaurant['branch'],
                          //widget.restaurant.restaurantName,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  FutureBuilder<List<Map<String, dynamic>>>(
                      future: _restaurantDataFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
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
                            child: Text('No date time found'),
                          );
                        }

                         List<Map<String, dynamic>> restaurantData = snapshot.data!
        .where((restaurant) => restaurant['r_id'] == widget.restaurant['r_id'])
        .toList();
                        final latitude = restaurantData[0]['location'].latitude;
                        final longitude =
                            restaurantData[0]['location'].longitude;
                        final mapUrl =
                            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                        print(mapUrl);

                       
                        // final longitude = GeoPoint.longitude;

                        // final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                        return Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 40),
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width) * 0.8,
                                child: GestureDetector(
                                  onTap: () => launch(mapUrl),
                                  child: Text(
                                    'View on Google Maps',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 40,
                        ),
                        child: Text(
                          "Number of persons",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  NumOfPersons(onChanged: updateNumberOfPersons),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.cyan[400],
                        // elevation: 3,
                        minimumSize: Size(350, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: const Text('Book',
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      onPressed: () async {
                        if (currentUser != null && currentUser.uid != null) {
                          DateTime now = DateTime.now();
                          String date = DateFormat('yyyy-MM-dd').format(now);
                          String time = DateFormat('hh:mm a').format(now);
                          String bookingQueue =
                              await bookingServices.getBookingQueue(
                                  widget.restaurant['r_id'],
                                  date,
                                  numberPerson);
                          //String previousBookingQueue = await bookingServices.getPreviousBookingQueue(widget.restaurant['r_id'], date, numberPerson);
                          //print(previousBookingQueue);
                          print(bookingQueue);
                          await bookingServices
                              .bookTable(
                                  widget.restaurant['r_id'],
                                  currentUser.uid,
                                  date,
                                  time,
                                  numberPerson,
                                  bookingQueue)
                              .then((_) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CusBookedPage(
                                      restaurant: widget.restaurant,
                                      numberPerson: numberPerson,
                                    )));
                          }).catchError((e) {
                            print('$e');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(e.toString()),
                                  actions: [],
                                );
                              },
                            );
                          });

                          //save data ลง db
                          //widget.restaurant['username'];
                          //widget.allRestaurantModel.queueNum;
                          //NumOfPersons();

                          // alert แจ้งเตือนว่าจองสำเร็จใช้ได้ค่อยเปิด
                          // showDialog<String>(
                          //   context: context,
                          //   builder: (BuildContext context) => AlertDialog(
                          //     title: const Text('Sucess'),
                          //     content: const Text('Your queue has been booked.'),
                          //   ),
                          // );
                        }
                        ;
                      })
                ],
              )),
        ));
  }
}

//เพิ่มลดจำนวนคนที่จอง
class NumOfPersons extends StatefulWidget {
  // @override
  // State<NumOfPersons> createState() => _NumOfPersonsState();

  final void Function(int) onChanged;
  const NumOfPersons({Key? key, required this.onChanged}) : super(key: key);
  @override
  _NumOfPersonsState createState() => _NumOfPersonsState();
}

class _NumOfPersonsState extends State<NumOfPersons> {
  int numberPerson = 0;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                numberPerson = numberPerson > 0 ? numberPerson - 1 : 0;
                widget.onChanged(numberPerson);
              });
            },
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 30,
          ),
          InkWell(
            onTap: () {},
            child: Container(
              width: 100.0,
              height: 70.0,
              decoration: new BoxDecoration(
                color: Colors.cyan.withOpacity(0.7),
                border: Border.all(color: Colors.white, width: 3),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  "$numberPerson",
                  style: new TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                numberPerson++;
                widget.onChanged(numberPerson);
              });
            },
            icon: Icon(Icons.add),
            color: Colors.black,
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}
