import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerServices{

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    DatabaseReference restaurantReference = _databaseReference.child('restaurant');

    DatabaseEvent databaseEvent = await restaurantReference.once();
    List<Map<String, dynamic>> restaurants = [];

    if (databaseEvent.snapshot.value != null) {
      (databaseEvent.snapshot.value as Map).forEach((key, value) {
        String address = value['address'];
        GeoPoint location = value['location'];
        String username = value['username'];
        String phone = value['phone'];
        String res_logo = value['res_logo'];
        // use something like this for display imageUrl to image
        // Image.network(
        //  res_logo,
        //  fit: BoxFit.cover,
        //  width: 100,
        //  height: 100,
        //  ),

        restaurants.add({
          'address': address,
          'location': location,
          'username': username,
          'phone': phone,
          'res_logo': res_logo,
        });
      });
    }

    return restaurants;
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
    } catch (e){
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
  final newPointsM = currentPointsM + (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
  final newPointsC = currentPointsC + (numPersons > 2 ? (numPersons > 4 ? 6 : (numPersons > 5 ? 8 : 2)) : 0);
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



}