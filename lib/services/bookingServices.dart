import 'package:cloud_firestore/cloud_firestore.dart';

class BookingServices {
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('bookings');
  final CollectionReference tableInfoCollection =
      FirebaseFirestore.instance.collection('tableInfo');
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
        String guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        DateTime createdAt = doc.get('created_at');
        DateTime updatedAt = doc.get('updated_at');

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
          ? bookingQueueSnapshot.docs.first['booking_queue']
          : 0;

      String tableType = getTableType(numOfGuests);
      //print('tableType: $tableType');

      final tableTypeQuerySnapshot =
          await tableInfoCollection.where('r_id', isEqualTo: resId).get();
      final tableTypes =
          tableTypeQuerySnapshot.docs.map((doc) => doc['table_type']).toList();
      final tableTypeCount = tableTypes.length;

      final tableTypeIndex = bookingCount % tableTypeCount;
      tableType = tableTypes[tableTypeIndex];

       final queueNumber = lastQueueNumber != null ? lastQueueNumber + 1 : 1;
      return tableType + queueNumber.toString().padLeft(3, '0');
    } catch (e) {
      print('Error occurred when get booking queue : $e');
      throw (e);
    }
  }

  // Booking

  Future<void> bookTable(
      String resId, String cusId, String date, String time, int guests) async {
    try {
      String bookingQueue =
          await getBookingQueue(resId, date.toString(), guests);
      await FirebaseFirestore.instance.collection('bookings').add({
        'booking_queue': bookingQueue,
        'created_at': DateTime.now(),
        'c_id': cusId,
        'r_id': resId,
        'date': date,
        'guest': guests,
        'status': 'pending',
        'time': time,
        'updated_at': DateTime.now(),
      });
    } catch (e) {
      print('Error occurred when booking : $e');
    }
  }

  String getTableType(int guests) {
    if (guests <= 2) {
      return 'A';
    } else if (guests < 5) {
      return 'B';
    } else if (guests < 7) {
      return 'C';
    } else if (guests <= 8) {
      return 'D';
    } else {
      return 'E';
    }
  }
}
