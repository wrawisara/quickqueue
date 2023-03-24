import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'dart:ui';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class BookingServices {
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('bookings');
  final CollectionReference tableInfoCollection =
      FirebaseFirestore.instance.collection('tableInfo');
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customer');
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurant');

  Future<List<Map<String, dynamic>>> getBookingData() async {
    try {
      QuerySnapshot bookingQuerySnapshot =
          await bookingCollection.get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        //String previousQueue = doc.get('previous_queue');
        String cusId = doc.get('c_id');
        String resId = doc.get('r_id');
        int guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        Timestamp createdAt = doc.get('created_at');
        Timestamp updatedAt = doc.get('updated_at');

        booking.add({
          'bookingQueue': bookingQueue,
          //'previousQueue': previousQueue,
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': status,
          'created_at': createdAt,
          'updated_at': updatedAt,
        });
      });

      print(booking);

      return booking;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getBookingDataForCustomer(
      String cusId) async {
    try {
      QuerySnapshot bookingQuerySnapshot = await bookingCollection
          .where('c_id', isEqualTo: cusId)
          .orderBy('created_at', descending: true)
          .get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        //String previousQueue = doc.get('previous_queue');
        String cusId = doc.get('c_id');
        String resId = doc.get('r_id');
        int guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        Timestamp createdAt = doc.get('created_at');
        Timestamp updatedAt = doc.get('updated_at');

        booking.add({
          'bookingQueue': bookingQueue,
          //'previousQueue': previousQueue,
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': status,
          'created_at': createdAt,
          'updated_at': updatedAt,
        });
      });

      print(booking);

      return booking;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getBookingDataForRestaurant(
      String resId) async {
    try {
      final now = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(now);
      QuerySnapshot bookingQuerySnapshot = await bookingCollection
          .where('r_id', isEqualTo: resId)
          .where('date', isEqualTo: todayString)
          .orderBy('created_at')
          .get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        //String previousQueue = doc.get('previous_queue');
        String cusId = doc.get('c_id');
        String resId = doc.get('r_id');
        int guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        Timestamp createdAt = doc.get('created_at');
        Timestamp updatedAt = doc.get('updated_at');

        booking.add({
          'bookingQueue': bookingQueue,
          //'previousQueue': previousQueue,
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': status,
          'created_at': createdAt,
          'updated_at': updatedAt,
        });
      });

      print(booking);

      return booking;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getRestaurantById(String resId) async {
    try {
      final QuerySnapshot querySnapshot = await restaurantCollection
          .where('r_id', isEqualTo: resId)
          .limit(1)
          .get();

      List<Map<String, dynamic>> restaurant = [];

      querySnapshot.docs.forEach((doc) {
        String resId = doc.get('r_id');
        String address = doc.get('address');
        GeoPoint location = doc.get('location');
        String username = doc.get('username');
        String phone = doc.get('phone');
        String res_logo = doc.get('res_logo');
        String branch = doc.get('branch');
        String status = doc.get('status');

        restaurant.add({
          'r_id': resId,
          'address': address,
          'location': location,
          'username': username,
          'phone': phone,
          'res_logo': res_logo,
          'branch': branch,
          'status': status,
        });
      });

      // Return the first document
      return restaurant;
    } catch (e) {
      print('Error occurred while getting restaurant by ID: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getCustomerById(String cusId) async {
    try {
      final QuerySnapshot querySnapshot = await customerCollection
          .where('c_id', isEqualTo: cusId)
          .limit(1)
          .get();

      List<Map<String, dynamic>> customer = [];

      querySnapshot.docs.forEach((doc) {
        String firstname = doc.get('firstname');
        String lastname = doc.get('lastname');

        customer.add({
          'firstname': firstname,
          'lastname': lastname,
        });
      });

      // Return the first document
      return customer;
    } catch (e) {
      print('Error occurred while getting customer by ID: $e');
      throw e;
    }
  }

  Future<String> getBookingQueue(
      String resId, String date, int numOfGuests) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> bookingQueueSnapshot =
          await bookingCollection
              .where('r_id', isEqualTo: resId)
              .where('date', isEqualTo: date)
              .orderBy('created_at', descending: true)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      final bookingCount = bookingQueueSnapshot.docs.length;

      final lastQueueNumber = bookingCount > 0
          ? bookingQueueSnapshot.docs.first['booking_queue']?.toString()
          : null;

      final tableType = getTableType(numOfGuests);

      String formattedQueueNumber = '001';
      if (lastQueueNumber != null) {
        final lastTableType = lastQueueNumber.substring(0, 1);
        if (lastTableType == tableType) {
          final lastQueueNumberInt = int.parse(lastQueueNumber.substring(1));
          formattedQueueNumber =
              (lastQueueNumberInt + 1).toString().padLeft(3, '0');
        }
      }

      final bookingQueue = '$tableType$formattedQueueNumber';
      print('Booking queue: $bookingQueue');
      return bookingQueue;
    } catch (e) {
      print('Error occurred when get booking queue : $e');
      throw (e);
    }
  }

    Future<String> getPreviousBookingQueue(
      String resId, String date, int numOfGuests) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> bookingQueueSnapshot =
          await bookingCollection
              .where('r_id', isEqualTo: resId)
              .where('date', isEqualTo: date)
              .orderBy('created_at', descending: true)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      final bookingCount = bookingQueueSnapshot.docs.length;

      final lastQueueNumber = bookingCount > 0
          ? bookingQueueSnapshot.docs.first['booking_queue']?.toString()
          : null;

      final tableType = getTableType(numOfGuests);

      String formattedQueueNumber = '001';
      if (lastQueueNumber != null) {
        final lastTableType = lastQueueNumber.substring(0, 1);
        if (lastTableType == tableType) {
          final lastQueueNumberInt = int.parse(lastQueueNumber.substring(1));
          formattedQueueNumber =
              (lastQueueNumberInt).toString().padLeft(3, '0');
        }
      }

      String previousBookingQueue = '$tableType$formattedQueueNumber';

      return previousBookingQueue;
    } catch (e) {
      print('Error occurred when get booking queue : $e');
      throw (e);
    }
  }


  Future<Map<String, int>> getTotalBookingQueue(List<String> resIds) async {
  try {
    final Map<String, int> totalQueues = {};

final now = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(now);
      
    for (final resId in resIds) {
      final querySnapshot =
          await bookingCollection.where('r_id', isEqualTo: resId).where('date', isEqualTo: todayString).get();
      final count = querySnapshot.docs.length;
      totalQueues[resId] = count;
    }

    return totalQueues;
  } catch (e) {
    print('Error occurred when getting total booking queue: $e');
    throw (e);
  }
}
Future<int> getTotalBookingQueueForOneRes(String resId) async {
  try {
    int totalQueue = 0;
    final now = DateTime.now();
    final todayString = DateFormat('yyyy-MM-dd').format(now);
      final querySnapshot =
          await bookingCollection.where('r_id', isEqualTo: resId).where('date', isEqualTo: todayString).get();
      final count = querySnapshot.docs.length;
      totalQueue = count-1;

    return totalQueue;
  } catch (e) {
    print('Error occurred when getting total booking queue: $e');
    throw (e);
  }
}

  // Booking
Future<void> bookTable(String resId, String cusId, String date, String time,
      int guests, String bookingQueue) async {
    try {
      if (cusId != '' ){
      final now = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(now);
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await bookingCollection.where('c_id', isEqualTo: cusId).where('date', isEqualTo: todayString).get()
              as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        throw ('Customer already has a booking.');
       
      }

      await FirebaseFirestore.instance.collection('bookings').add({
        'booking_queue': bookingQueue,
        //'previous_queue': previousBookingQueue,
        'created_at': DateTime.now(),
        'c_id': cusId,
        'r_id': resId,
        'date': date,
        'guest': guests,
        'status': 'pending',
        'time': time,
        'updated_at': DateTime.now(),
      });
      } else if (cusId == ''){
        await FirebaseFirestore.instance.collection('bookings').add({
        'booking_queue': bookingQueue,
        //'previous_queue': previousBookingQueue,
        'created_at': DateTime.now(),
        'c_id': cusId,
        'r_id': resId,
        'date': date,
        'guest': guests,
        'status': 'pending',
        'time': time,
        'updated_at': DateTime.now(),
      });
      }
    } catch (e) {
      print('$e');
      throw e;
    }
  }


  String getTableType(int guests) {
    if (guests > 0 && guests <= 2) {
      return 'A';
    } else if (guests >= 3 && guests <= 4) {
      return 'B';
    } else if (guests >= 5 && guests <= 7) {
      return 'C';
    } else if (guests == 8) {
      return 'D';
    } else {
      return 'E';
    }
  }

  Future<void> updateBookingStatus(String bookingQueue, String status) async {
    try {
      final now = DateTime.now();
      final todayString = DateFormat('yyyy-MM-dd').format(now);
      final QuerySnapshot<Map<String, dynamic>> bookingQueueSnapshot =
          await bookingCollection
              .where('booking_queue', isEqualTo: bookingQueue)
              .where('date', isEqualTo: todayString)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          bookingQueueSnapshot.docs;

      if (documents.isNotEmpty) {
        final String bookingId = documents.first.id;
        final DocumentReference<Map<String, dynamic>> bookingDoc =
            bookingCollection.doc(bookingId)
                as DocumentReference<Map<String, dynamic>>;

        await bookingDoc.update({
          'status': status,
          'updated_at': DateTime.now() 
        });
        print('Booking status updated successfully');
      } else {
        print('No booking found with booking queue: $bookingQueue');
      }
    } catch (e) {
      print('Error occurred while updating booking status: $e');
      throw e;
    }
  }

  Future<void> deleteBooking(String cusId) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await bookingCollection.where('c_id', isEqualTo: cusId).get() as QuerySnapshot<Map<String, dynamic>>;

      for (final doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    print('Bookings successfully deleted.');
    
    } catch (e) {
      print('Error occurred while deleting booking: $e');
      throw e;
    }
  }

  // to be decided wether to delete or not 
  Future<void> deleteOldBookings() async {
  final now = DateTime.now();
  final todayString = DateFormat('yyyy-MM-dd').format(now);

  final oldBookingsQuerySnapshot = await bookingCollection
      .where('date', isLessThan: todayString)
      .get() as QuerySnapshot<Map<String, dynamic>>;

  final batch = FirebaseFirestore.instance.batch();

  oldBookingsQuerySnapshot.docs.forEach((doc) {
    batch.delete(doc.reference);
  });

  await batch.commit();
}

Future<void> downloadBookingsCsv(String resId) async {
  try {
  // Query the bookings collection
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await bookingCollection.where('r_id', isEqualTo: resId).get() as QuerySnapshot<Map<String, dynamic>>;

  // Convert the data into a CSV format
  final List<List<dynamic>> rows = [];
  rows.add(['booking_id', 'res_id', 'booking_queue','booking_date', 'booking_time', 'guests']); // Add header row
  for (final QueryDocumentSnapshot<Map<String, dynamic>> document
      in querySnapshot.docs) {
    rows.add([
      document.id,
      document.data()['r_id'],
      document.data()['booking_queue'],
      document.data()['date'],
      document.data()['time'],
      document.data()['guest']
    ]);
  }
  final String csvData = const ListToCsvConverter().convert(rows);

  // Save the CSV data to a file on the device
  final Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory();
  const String csvFileName = 'bookings.csv';
  final File csvFile = File('${appDocumentsDirectory.path}/$csvFileName');
  await csvFile.writeAsString(csvData);

  // Offer the user the option to download the file
  await shareFile(csvFile);
  } catch (e){
    print('Error during downloading CSV $e');
  }
}

Future<void> shareFile(File file) async {
  final String fileName = file.path.split('/').last;
  final List<String> paths = file.path.split('/');
  paths.removeLast();
  final String directory = paths.join('/');

   await Share.shareXFiles([XFile(file.path)],
      text: 'Here is your CSV file: $fileName',
      subject: 'CSV File',
      sharePositionOrigin: Rect.fromLTWH(0, 0, 10, 10));
}
}
