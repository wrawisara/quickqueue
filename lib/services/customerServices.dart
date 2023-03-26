import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CustomerServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customer');
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurant');
  final CollectionReference couponCollection =
      FirebaseFirestore.instance.collection('coupons');
  final CollectionReference bookingCollection =
      FirebaseFirestore.instance.collection('bookings');

  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    try {
      QuerySnapshot restaurantQuerySnapshot = await restaurantCollection.where('status', isEqualTo: 'open').get();

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
      
      QuerySnapshot querySnapshot =
          await customerCollection.where('c_id', isEqualTo: cusId).get();

      String customerTier = querySnapshot.docs[0]['tier'];

   QuerySnapshot couponQuery = await FirebaseFirestore.instance
          .collection('coupons')
          .where('tier', isEqualTo: customerTier)
          .where('status', isEqualTo: 'available')
          .get();

      List<Map<String, dynamic>> coupons = [];
      couponQuery.docs.forEach((doc) {
        String couponName = doc.get('name');
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
          'couponName': couponName,
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
      QuerySnapshot couponQuery =
          await couponCollection.where('status', isEqualTo: 'collected').where('c_id', isEqualTo: cusId).get();

      List<Map<String, dynamic>> coupons = [];
      couponQuery.docs.forEach((doc) {
        String code = doc.get('code');
        String couponName = doc.get('name');
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

    if (points >= 20 && points < 30) {
      tier = 'Silver';
    } else if (points >= 30 && points > 20) {
      tier = 'Gold';
    } else {
      tier = 'Bronze';
    }

    final customerDocSnapshot = await FirebaseFirestore.instance
        .collection('customer')
        .where('c_id', isEqualTo: cusId)
        .get();
    final customerDoc = customerDocSnapshot.docs[0];
    await customerDoc.reference.update({'tier': tier});
  }

  Future<void> updatePointsOnCheckIn(String cusId, String bookingQueue) async {
    try {
      final customerDocs =
          await customerCollection.where('c_id', isEqualTo: cusId).get();
      final customerDoc = customerDocs.docs.first;
      int currentPointsC = customerDoc.get('point_c');
      int currentPointsM = customerDoc.get('point_m');
      int currentReputation = customerDoc.get('reputation_points');
      final currentTier = customerDoc.get('tier');
      String type = bookingQueue.substring(0, 1);
      int numPersons = 0;
      if (type == 'A') {
        numPersons = 2;
      } else if (type == 'B') {
        if (currentReputation < 50) {
          numPersons = 4;
        } else {
          numPersons = 4;
        }
      } else if (type == 'C' || type == 'D' || type == 'E') {
        if (currentReputation < 50) {
          numPersons = 4;
        } else {
          numPersons = 8;
        }
      }

      int newPointsM = currentPointsM +
          (numPersons > 2
              ? (numPersons >= 3 ? 6 : (numPersons > 4 ? 8 : 2))
              : 2);
      int newPointsC = currentPointsC +
          (numPersons > 2
              ? (numPersons >= 3 ? 6 : (numPersons > 4 ? 8 : 2))
              : 2);
      int newReputation = currentReputation;
      int tmpNum = (numPersons > 2
              ? (numPersons >= 3 ? 6 : (numPersons > 4 ? 8 : 2))
              : 2);

      if (currentReputation < 100) {
        newReputation += numPersons ~/ 2;
        if (newReputation > 100) {
          newReputation = 100;
        }
      }
      final updateData = {
        'point_m': newPointsM,
        'point_c': newPointsC,
        'reputation_points': newReputation,
      };
      
      if (currentTier == 'Gold' && currentPointsM > 40) {
        updateData['point_c'] = (newPointsC + (numPersons * 2)) - tmpNum;
      }
      await customerDoc.reference.update(updateData);
      updateCustomerTier(cusId, newPointsM);
    } catch (e) {
      print('Error when updating points $e');
    }
  }

  Future<void> subtractReputation(String cusId) async {
    try {
      final customerQuery =
          await customerCollection.where('c_id', isEqualTo: cusId).get();

      if (customerQuery.docs.isNotEmpty) {
        final customerDoc = customerQuery.docs.first;

        final currentReputation = customerDoc.get('reputation_points');

        final newReputation = currentReputation - 5;
        customerDoc.reference.update({'reputation_points': newReputation});

        print('Reputation subtracted successfully!');
      } else {
        print('Error: Customer with ID $cusId does not exist');
      }
    } catch (e) {
      print('Error subtracting reputation: $e');
    }
  }

  String generateCouponCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  Future<void> useCoupon(
      String cusId, int requiredPoints, String couponId) async {
    try {

    final couponQuerySnapshot = await couponCollection
        .where('coupon_id', isEqualTo: couponId)
        .where('c_id', isEqualTo: cusId)
        .get();

    if (couponQuerySnapshot.size > 0) {
      throw Exception('You already collected this coupon');
    } else {
      // There are no existing documents with the specified 'c_id' and 'coupon_id'

    QuerySnapshot<Map<String, dynamic>> couponQuery = await couponCollection
        .where('coupon_id', isEqualTo: couponId)
        .get() as QuerySnapshot<Map<String, dynamic>>;

    QuerySnapshot<Map<String, dynamic>> customerQuery = await customerCollection
        .where('c_id', isEqualTo: cusId)
        .get() as QuerySnapshot<Map<String, dynamic>>;

    final couponDoc = couponQuery.docs.first;
    final customerDoc = customerQuery.docs.first;
    final currentPointsC = customerDoc.get('point_c');
    final newPointsC = currentPointsC - requiredPoints;
    if (newPointsC < 0) {
      throw Exception('Insufficient points to use this coupon');
    }
    

    // Create a new coupon document with the same data as the original document
    final newCouponDoc = await couponCollection.add(couponDoc.data());

    // Update the new coupon document with the new c_id and status
    final updateDataCoupon = {
      'c_id': cusId,
      'status': 'collected',
      'code': generateCouponCode()
    };
    await newCouponDoc.update(updateDataCoupon);

    // Update the customer document with the new point_c value
    final updateDataCustomer = {'point_c': newPointsC};
    await customerDoc.reference.update(updateDataCustomer);
    }
    } catch (e){
      throw('You already collected this coupon.');
    }
  }

  Future<List<DocumentSnapshot>> getBookingQueue(String resId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await bookingCollection
        .where('r_id', isEqualTo: resId)
        .orderBy('created_at', descending: false)
        .get() as QuerySnapshot<Map<String, dynamic>>;
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

  Future<void> updateExpiredCoupons() async {
    final now = DateTime.now();
    final expiredCouponsQuery =
        await couponCollection.where('end_date', isLessThan: now).get();

    for (final couponDoc in expiredCouponsQuery.docs) {
      await couponDoc.reference.delete();
      print('Expired coupon ${couponDoc.id} has been deleted');
    }
  }

  Future<void> updateBookingQueue() async {
    final now = DateTime.now();
    final expiredCouponsQuery =
        await bookingCollection.where('status', isEqualTo: 'canceled').get();

    for (final couponDoc in expiredCouponsQuery.docs) {
      await couponDoc.reference.delete();
      print('Expired coupon ${couponDoc.id} has been deleted');
    }
  }
}
