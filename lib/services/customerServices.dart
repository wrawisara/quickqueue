import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class CustomerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    try {
      QuerySnapshot restaurantQuerySnapshot =
          await _firestore.collection('restaurant').get();

      List<Map<String, dynamic>> restaurants = [];

      restaurantQuerySnapshot.docs.forEach((doc) {
        String address = doc.get('address');
        GeoPoint location = doc.get('location');
        String username = doc.get('username');
        String phone = doc.get('phone');
        String res_logo = doc.get('res_logo');

        print(address);

        restaurants.add({
          'address': address,
          'location': location,
          'username': username,
          'phone': phone,
          'res_logo': res_logo,
        });
      });

      print(restaurants);

      return restaurants;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    } 
}

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(String uid) async {
    DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot =
        await _firestore.collection('customer').doc(uid).get();
    return userInfoSnapshot;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      String uid = user.uid;
      DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot;
      try {
        userInfoSnapshot = await getUserInfo(uid);
        return userInfoSnapshot;
      } catch (e) {
        print('Error when getting UserInfo');
        rethrow;
      }
    } else {
      throw Exception('No user is signed in');
    }
  }

  // Points Update

  Future<void> updateCustomerTier(String cusId, int points) async {
    String tier;

    // Determine the customer's new tier based on their points
    if (points >= 20) {
      tier = 'Silver';
    } else if (points >= 30) {
      tier = 'Gold';
    } else {
      tier = 'Bronze';
    }
    // Update the customer's tier in the database
    await FirebaseFirestore.instance
        .collection('customer')
        .doc(cusId)
        .update({'tier': tier});
  }

  Future<void> updatePointsOnCheckIn(String cusId, int numPersons) async {
    final customerDocRef =
        FirebaseFirestore.instance.collection('customer').doc(cusId);
    final customerDoc = await customerDocRef.get();
    final currentPointsM = customerDoc.get('points_m');
    final currentPointsC = customerDoc.get('points_c');
    final currentTier = customerDoc.get('tier');
    final newPointsM = currentPointsM +
        (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
    final newPointsC = currentPointsC +
        (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
    final updateData = {
      'points_m': newPointsM,
      'points_c': newPointsC,
    };
    if (currentTier == 'Gold' && currentPointsM > 40) {
      updateData['points_c'] = newPointsC * 2;
    }
    await customerDocRef.update(updateData);
    updateCustomerTier(cusId, newPointsM);
  }
    

  Future<void> useCoupon(String cusId, double requiredPoints) async {
    final customerDocRef =
        FirebaseFirestore.instance.collection('customer').doc(cusId);
    final customerDoc = await customerDocRef.get();
    final currentPointsC = customerDoc.get('points_c');
    final newPointsC = currentPointsC - requiredPoints;
    if (newPointsC < 0) {
      throw Exception('Insufficient points to use this coupon');
    }
    final updateData = {'points_c': newPointsC};
    await customerDocRef.update(updateData);
  }

  Future<void> createBookings(String cusId, String resId, int guests) async {
    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    String timeString = DateFormat('H.mm').format(dateTime);

    Timestamp bookingDate = timestamp;
    String bookingTime = timeString;

    String tableType = getTableType(guests);

    int numBookings = await FirebaseFirestore.instance
        .collection('bookings')
        .where('r_id', isEqualTo: resId)
        .where('date', isEqualTo: bookingDate)
        .where('time', isEqualTo: bookingTime)
        .where('status', isEqualTo: 'confirmed')
        .where('booking_queue', isGreaterThanOrEqualTo: tableType)
        .where('booking_queue', isLessThan: tableType + 'z')
        .get()
        .then((querySnapshot) => querySnapshot.docs.length);

// Format booking queue number with leading zeros
    String bookingQueue =
        '${tableType}${(numBookings + 1).toString().padLeft(3, '0')}';
    createBookingDoc(resId, cusId, bookingQueue, guests);
  }

  Future<void> createBookingDoc(String resId, String? cusId, String bookingQueue,int guests) async {
    CollectionReference<Map<String, dynamic>> bookingCollectionRef =
        FirebaseFirestore.instance.collection("bookings");
    DocumentReference<Map<String, dynamic>> bookingDocRef =
        bookingCollectionRef.doc();

    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    String timeString = DateFormat('H.mm').format(dateTime);

    await bookingDocRef.set({
      'cus_id': cusId,
      'r_id': resId,
      'booking_queue': bookingQueue,
      'date': timestamp,
      'time': timeString,
      'guest': guests,
      'status': 'รอคิว',
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp()
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