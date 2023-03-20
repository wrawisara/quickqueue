import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class BookingServices {
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('bookings');
  final CollectionReference tableInfoCollection =
      FirebaseFirestore.instance.collection('tableInfo');
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customer');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getBookingData() async {
    try {
      QuerySnapshot bookingQuerySnapshot =
          await _firestore.collection('bookings').get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        String cusId = doc.get('c_id');
        String resId = doc.get('r_id');
        int guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        Timestamp createdAt = doc.get('created_at');
        Timestamp updatedAt = doc.get('updated_at');

        //print('bookig ' + bookingQueue);
        //print('cusID ' + cusId);
        //print('resId ' + resId);
        //print('guest ' + guest);
        //print('date ' + date);
        //print('time ' + time);
        //print('status ' + status);
        //print('created ' + createdAt.toString());
        //print('updated ' + updatedAt.toString());

        booking.add({
          'bookingQueue': bookingQueue,
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': 'pending',
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
      QuerySnapshot bookingQuerySnapshot = await _firestore
          .collection('bookings')
          .where('c_id', isEqualTo: cusId)
          .orderBy('created_at', descending: true)
          .get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        String cusId = doc.get('c_id');
        String resId = doc.get('r_id');
        int guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        Timestamp createdAt = doc.get('created_at');
        Timestamp updatedAt = doc.get('updated_at');

        //print('bookig ' + bookingQueue);
        //print('cusID ' + cusId);
        //print('resId ' + resId);
        //print('guest ' + guest);
        //print('date ' + date);
        //print('time ' + time);
        //print('status ' + status);
        //print('created ' + createdAt.toString());
        //print('updated ' + updatedAt.toString());

        booking.add({
          'bookingQueue': bookingQueue,
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': 'pending',
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
      QuerySnapshot bookingQuerySnapshot = await _firestore
          .collection('bookings')
          .where('r_id', isEqualTo: resId)
          .orderBy('created_at', descending: true)
          .get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
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
          'c_id': cusId,
          'r_id': resId,
          'guest': guest,
          'date': date,
          'time': time,
          'status': 'pending',
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

  // Booking

  Future<void> bookTable(String resId, String cusId, String date, String time,
      int guests, String bookingQueue) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await bookingCollection.where('c_id', isEqualTo: cusId).get()
              as QuerySnapshot<Map<String, dynamic>>;

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Customer already has a booking.');
      }

      await FirebaseFirestore.instance.collection('bookings').add({
        'booking_queue': bookingQueue,
        'created_at': DateTime.now(),
        'c_id': cusId,
        'r_id': resId,
        'date': date,
        'guest': guests,
        'status': 'booked',
        'time': time,
        'updated_at': DateTime.now(),
      });
    } catch (e) {
      print('Error occurred when booking : $e');
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
      final QuerySnapshot<Map<String, dynamic>> bookingQueueSnapshot =
          await bookingCollection
              .where('booking_queue', isEqualTo: bookingQueue)
              .get() as QuerySnapshot<Map<String, dynamic>>;

      final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents =
          bookingQueueSnapshot.docs;

      if (documents.isNotEmpty) {
        final String bookingId = documents.first.id;
        final DocumentReference<Map<String, dynamic>> bookingDoc =
            bookingCollection.doc(bookingId)
                as DocumentReference<Map<String, dynamic>>;

        await bookingDoc.update({'status': status});
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
}
