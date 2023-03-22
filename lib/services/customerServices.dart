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
        String resId = doc.get('r_id');
        String address = doc.get('address');
        GeoPoint location = doc.get('location');
        String username = doc.get('username');
        String phone = doc.get('phone');
        String res_logo = doc.get('res_logo');
        String branch = doc.get('branch');
        String status = doc.get('status');

        restaurants.add({
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

      print(restaurants);

      return restaurants;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getAllCurrentTierCoupon(
      String cusId) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('customer');
      final querySnapshot =
          await collectionRef.where('c_id', isEqualTo: cusId).get();

      String customerTier = querySnapshot.docs[0]['tier'];

      QuerySnapshot couponQuery = await FirebaseFirestore.instance
          .collection('coupons')
          .where('tier', isEqualTo: customerTier)
          .get();

      List<Map<String, dynamic>> coupons = [];
      couponQuery.docs.forEach((doc) {
        String code = doc.get('code');
        String couponName = doc.get('couponName');
        String? cusId = doc.get('c_id');
        double discount = doc.get('discount');
        Timestamp endDate = doc.get('end_date');
        Timestamp startDate = doc.get('start_date');
        String img = doc.get('img');
        String menu = doc.get('menu');
        int requiredPoint = doc.get('required_point');
        String? resId = doc.get('r_id');
        String tier = doc.get('tier');
        // to be changed
        String? couponId = doc.get('coupon_id');

        coupons.add({
          'code': code,
          'couponName': couponName,
          'c_id': cusId,
          'discount': discount,
          'end_date': endDate,
          'start_date': startDate,
          'img': img,
          'requiredPoint': requiredPoint,
          'r_id': resId,
          'coupon_id': couponId,
          'menu': menu,
          'tier': tier,
        });
      });

      // Return the list of coupon documents
      return coupons;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentCustomerCoupon(
      String cusId) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('customer');
      final querySnapshot =
          await collectionRef.where('c_id', isEqualTo: cusId).get();


      QuerySnapshot couponQuery = await FirebaseFirestore.instance
          .collection('coupons')
          .where('status', isEqualTo: 'used')
          .get();

      List<Map<String, dynamic>> coupons = [];
      couponQuery.docs.forEach((doc) {
        String code = doc.get('code');
        String couponName = doc.get('couponName');
        String? cusId = doc.get('c_id');
        double discount = doc.get('discount');
        Timestamp endDate = doc.get('end_date');
        Timestamp startDate = doc.get('start_date');
        String img = doc.get('img');
        String menu = doc.get('menu');
        int requiredPoint = doc.get('required_point');
        String? resId = doc.get('r_id');
        String tier = doc.get('tier');
        String status = doc.get('status');
        String? couponId = doc.get('coupon_id');

        coupons.add({
          'code': code,
          'couponName': couponName,
          'c_id': cusId,
          'discount': discount,
          'end_date': endDate,
          'start_date': startDate,
          'img': img,
          'requiredPoint': requiredPoint,
          'r_id': resId,
          'coupon_id': couponId,
          'menu': menu,
          'tier': tier,
          'status': status,
        });
      });

      // Return the list of coupon documents
      return coupons;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserInfo(String uid) async {
    final collectionRef = FirebaseFirestore.instance.collection('customer');
    final querySnapshot =
        await collectionRef.where('c_id', isEqualTo: uid).get();
    return querySnapshot;
  }

  Future<List<Map<String, dynamic>>> getCurrentUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // User is signed in
      String uid = user.uid;
      QuerySnapshot<Map<String, dynamic>> userInfoSnapshot;
      try {
        userInfoSnapshot = await getUserInfo(uid);
        Map<String, dynamic> currentUserInfo =
            userInfoSnapshot.docs.first.data();
        List<Map<String, dynamic>> userData = [
          {
            'tier': currentUserInfo['tier'],
            'point_c': currentUserInfo['point_c'],
            'point_m': currentUserInfo['point_m'],
            'reputation_points': currentUserInfo['reputation_points'],
            'status': currentUserInfo['status'],
            'email': currentUserInfo['email'],
            'phone': currentUserInfo['phone'],
            'firstname': currentUserInfo['firstname'],
            'lastname': currentUserInfo['lastname'],
          }
        ];
        print(currentUserInfo['point_c']);
        return userData;
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
    final currentPointsM = customerDoc.get('point_m');
    final currentPointsC = customerDoc.get('point_c');
    final currentTier = customerDoc.get('tier');
    final newPointsM = currentPointsM +
        (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
    final newPointsC = currentPointsC +
        (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
    final updateData = {
      'point_m': newPointsM,
      'point_c': newPointsC,
    };
    if (currentTier == 'Gold' && currentPointsM > 40) {
      updateData['point_c'] = newPointsC * 2;
    }
    await customerDocRef.update(updateData);
    updateCustomerTier(cusId, newPointsM);
  }

  Future<void> useCoupon(
      String cusId, int requiredPoints, String couponId) async {
        print(couponId);
    QuerySnapshot<Map<String, dynamic>> couponQuery = await FirebaseFirestore
        .instance
        .collection('coupons')
        .where('coupon_id', isEqualTo: couponId)
        .get();

        QuerySnapshot<Map<String, dynamic>> customerQuery = await FirebaseFirestore
        .instance
        .collection('customer')
        .where('c_id', isEqualTo: cusId)
        .get();

    final couponDoc = couponQuery.docs.first;
    final customerDoc = customerQuery.docs.first;
    final currentPointsC = customerDoc.get('point_c');
    final newPointsC = currentPointsC - requiredPoints;
    if (newPointsC < 0) {
      throw Exception('Insufficient points to use this coupon');
    }
    final updateDataCustomer = {'point_c': newPointsC};
    final updateDataCoupon = {'status': 'used'};
    await customerDoc.reference.update(updateDataCustomer);
    await couponDoc.reference.update(updateDataCoupon);
  }

  Future<List<DocumentSnapshot>> getBookingQueue(String resId) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
      .collection('bookings')
      .where('r_id', isEqualTo: resId)
      .orderBy('created_at', descending: false)
      .get();
  return snapshot.docs;
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

  // tobe delete
  Future<List<String>> getCustomerName(String cusId) async {
  final QuerySnapshot<Map<String, dynamic>> customerSnapshot =
      await _firestore.collection('customer').where('c_id', isEqualTo: cusId).get();
  if (customerSnapshot.docs.isNotEmpty) {
    final customer = customerSnapshot.docs.first;
    final firstName = customer['first_name'] as String;
    final lastName = customer['last_name'] as String;
    return [firstName, lastName];
  }
  return [];
}
}