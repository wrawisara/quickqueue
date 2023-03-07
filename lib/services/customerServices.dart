import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerServices {
  // final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref("https://quickqueue-17550-default-rtdb.asia-southeast1.firebasedatabase.app");

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
}




//อันเก่าใช้ไม่ได้
  // Future<List<Map<String, dynamic>>> getAllRestaurants() async {
  //   //บันทึกข้อมูลลง firebase ได้
  //   DatabaseReference restaurantReference =
  //       _databaseReference.child('restaurant');
  //   DatabaseEvent databaseEvent = await restaurantReference.once();
  //   //เขียนเพิ่ม
  //   // QuerySnapshot restaurantSnapshot =
  //   //     await _firestore.collection('restaurant').get();
  //   List<Map<String, dynamic>> restaurants = [];

  //   //snapshot เอา event ตอนนั้นมา
  //   if (databaseEvent.snapshot.value != null) {
  //     (databaseEvent.snapshot.value as Map).forEach((key, value) {
  //       String address = value['address'];
  //       GeoPoint location = value['location'];
  //       String username = value['username'];
  //       String phone = value['phone'];
  //       String res_logo = value['res_logo'];
  //       // use something like this for display imageUrl to image
  //       // Image.network(
  //       //  res_logo,
  //       //  fit: BoxFit.cover,
  //       //  width: 100,
  //       //  height: 100,
  //       //  ),

  //   // if (restaurantSnapshot.docs.isNotEmpty) {
  //   //   (databaseEvent.snapshot.value as Map).forEach((key, value) {
  //   //     for (var document in restaurantSnapshot.docs) {
  //   //       Map<String, dynamic>? restaurantData =
  //   //           document.data() as Map<String, dynamic>?;
  //   //       String address = restaurantData!['address'];
  //   //       GeoPoint location = restaurantData['location'];
  //   //       String username = restaurantData['username'];
  //   //       String phone = restaurantData['phone'];
  //   //       String res_logo = restaurantData['res_logo'];
  //   //       // use something like this for display imageUrl to image
  //   //       // Image.network(
  //   //       //  res_logo,
  //   //       //  fit: BoxFit.cover,
  //   //       //  width: 100,
  //   //       //  height: 100,
  //   //       //  ),

  //         restaurants.add({
  //           'address': address,
  //           'location': location,
  //           'username': username,
  //           'phone': phone,
  //           'res_logo': res_logo,
  //         });
  //       }
  //     );
  //   }
  //   return restaurants;
    
  // }