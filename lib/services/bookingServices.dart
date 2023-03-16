import 'package:cloud_firestore/cloud_firestore.dart';


class BookingServices {
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('booking');
  final CollectionReference tableInfoCollection =
      FirebaseFirestore.instance.collection('tableInfo');
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;



   Future<List<Map<String, dynamic>>> getBookingData() async {
    try {
      QuerySnapshot bookingQuerySnapshot =
          await _firestore.collection('booking').get();

      List<Map<String, dynamic>> booking = [];

      bookingQuerySnapshot.docs.forEach((doc) {
        String bookingQueue = doc.get('booking_queue');
        String cusId = doc.get('c_id');
        String guest = doc.get('guest');
        String date = doc.get('date');
        String time = doc.get('time');
        String status = doc.get('status');
        DateTime createdAt = doc.get('created_at');
        DateTime updatedAt = doc.get('updated_at');

        booking.add({
          'bookingQueue': bookingQueue,
          'c_id': cusId,
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

  Future<String> getBookingQueue(String restaurantId, String date, int numOfGuests) async {
    final QuerySnapshot<Map<String, dynamic>> bookingQueueSnapshot =
        await bookingCollection
            .where('r_id', isEqualTo: restaurantId)
            .where('date', isEqualTo: date)
            .orderBy('created_at', descending: true)
            .get() as QuerySnapshot<Map<String, dynamic>>;

    final bookingCount = bookingQueueSnapshot.docs.length;
    final lastQueueNumber =
        bookingCount > 0 ? bookingQueueSnapshot.docs.first['queue_number'] : 0;

    String tableType = getTableType(numOfGuests);

    final tableTypeQuerySnapshot =
        await tableInfoCollection.where('r_id', isEqualTo: restaurantId).get();
    final tableTypes = tableTypeQuerySnapshot.docs.map((doc) => doc['table_type']).toList();
    final tableTypeCount = tableTypes.length;

    final tableTypeIndex = bookingCount % tableTypeCount;
    tableType = tableTypes[tableTypeIndex];

    final queueNumber = lastQueueNumber + 1;
    return tableType + queueNumber.toString().padLeft(3, '0');
}

  Future<String> getPreviousQueue(String resId, String date, int queueNumber) async {
  final previousQueueSnapshot = await bookingCollection
      .where('r_id', isEqualTo: resId)
      .where('date', isEqualTo: date)
      .where('booking_queue', isLessThan: queueNumber)
      .orderBy('booking_queue', descending: true)
      .limit(1)
      .get() as QuerySnapshot<Map<String, dynamic>>;

  if (previousQueueSnapshot.docs.isNotEmpty) {
    final previousQueueNumber = previousQueueSnapshot.docs.first['queue_number'];
    final tableTypeQuerySnapshot =
        await tableInfoCollection.where('r_id', isEqualTo: resId).get();
    final tableTypes = tableTypeQuerySnapshot.docs.map((doc) => doc['table_type']).toList();
    final tableTypeCount = tableTypes.length;
    final tableTypeIndex = previousQueueNumber % tableTypeCount;
    final tableType = tableTypes[tableTypeIndex];
    final previousQueueNumberString = previousQueueNumber.toString().padLeft(3, '0');
    return tableType + previousQueueNumberString;
  }

  return '';
}

  // Booking

  Future<void> bookTable(String resId, String cusId, String date, String time, int guests) async {
    String bookingQueue = await getBookingQueue(resId, date.toString(), guests);
    print('Booking Queue ' + bookingQueue);
    print('Guest :' + guests.toString());
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
  }

  
  String getTableType(int guests) {
    if (guests <= 2) {
      return 'A';
    } else if (guests <= 4) {
      return 'B';
    } else if (guests <= 6) {
      return 'C';
    } else if (guests <= 8) {
      return 'D';
    } else {
      return 'E';
    }
  }
}