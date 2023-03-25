import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference couponCollection =
      FirebaseFirestore.instance.collection('coupons');
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurant');
  final CollectionReference tableInfoCollection =
      FirebaseFirestore.instance.collection('tableInfo');
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection('customer');

  Future<void> addCoupon(
      String couponName,
      String couponMenuName,
      double discount,
      int requiredPoint,
      String tier,
      String resId,
      File image,
      DateTime expiredDate) async {
    try {
      DateTime now = DateTime.now();
      //DateTime expiredDate = now.add(Duration(days: 7));
      String imageUrl = await uploadImage(image);
      String couponId = Uuid().v4();
      //check
      print(couponName);

      await couponCollection.add({
        'name': couponName,
        'code': null,
        'c_id': null,
        'r_id': resId,
        'coupon_id': couponId,
        'menu': couponMenuName,
        'discount': discount,
        'required_point': requiredPoint,
        'tier': tier,
        'start_date': now,
        'end_date': expiredDate,
        'img': imageUrl,
        'status': 'available',
      });
    } catch (e) {
      print('Error adding coupon: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCurrentRestaurants(String resId) async {
    try {
      QuerySnapshot restaurantQuerySnapshot = await restaurantCollection
          .where('r_id', isEqualTo: resId)
          .get();

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

        print(address);

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

  Future<void> setTableInfo(String resId, Map<String, int> tableInfo) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tableInfo');
      final querySnapshot =
          await collectionRef.where('r_id', isEqualTo: resId).get();

      final batch = FirebaseFirestore.instance.batch();

      querySnapshot.docs.forEach((doc) {
        String tableType = '';
        Map<String, dynamic>? data;

        if (doc.exists && doc.data() != null) {
          data = doc.data();
          tableType = data['table_type'];
        } else {
          data = {
            'capacity': 0,
          };
        }

        tableInfo.forEach((key, value) {
          if (key == tableType) {
            int capacity = value;
            data!['capacity'] = capacity;
            batch.set(doc.reference, data);
          }
        });
      });

      // Commit the batched writes
      await batch.commit();
    } catch (e) {
      print('Error when edit table: $e');
    }
  }

  Future<void> updateRestaurantStatus(String resId, String status) async {
    // Update the customer's tier in the database
    final customerDocSnapshot = await restaurantCollection
        .where('r_id', isEqualTo: resId)
        .get();
    final customerDoc = customerDocSnapshot.docs[0];
    await customerDoc.reference.update({'status': status});
  }

  Future<void> setTableInfoForTableE(String resId, Map<String, int> tableInfo,
      int? eTableNum, Map<String, int> tableInfo2) async {
    try {
      setTableInfo(resId, tableInfo2);
      final collectionRef = FirebaseFirestore.instance.collection('tableInfo');
      final querySnapshot =
          await collectionRef.where('r_id', isEqualTo: resId).get();

      // Iterate over the documents and update the tableType and capacity attributes
      final batch = FirebaseFirestore.instance.batch();

      querySnapshot.docs.forEach((doc) {
        String tableType = '';
        Map<String, dynamic>? data;

        // Check if the document exists and has data
        if (doc.exists && doc.data() != null) {
          data = doc.data();
          tableType = data['table_type'];
        } else {
          // Handle the case when the document does not exist
          // or does not have data, e.g. by creating a new document
          data = {
            'capacity': 0,
          };
        }

        // Update the data for the specified table types
        tableInfo.forEach((key, value) {
          if (key == tableType) {
            data!['capacity'] = value;
            batch.set(doc.reference, data);
          }
        });
      });

      // Commit the batched writes
      await batch.commit();
    } catch (e) {
      print('Error when edit table: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllTableInfo(String resId) async {
    try {
      QuerySnapshot tableInfoQuery = await tableInfoCollection
          .where('r_id', isEqualTo: resId)
          .get();

      List<Map<String, dynamic>> tableInfo = [];

      tableInfoQuery.docs.forEach((doc) {
        int capacity = doc.get('capacity');
        String tableType = doc.get('table_type');

        tableInfo.add({
          'capacity': capacity,
          'table_type': tableType,
        });
      });
      tableInfo.sort((a, b) => a['table_type'].compareTo(b['table_type']));

      return tableInfo;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<num> getTotalCapacity(String resId) async {
    try {
      final QuerySnapshot querySnapshot = await tableInfoCollection
          .where('r_id', isEqualTo: resId)
          .get();

      num totalCapacity = 0;

      querySnapshot.docs.forEach((doc) {
        totalCapacity += doc.get('capacity');
      });

      print('Total Capacity: ' + totalCapacity.toString());
      return totalCapacity;
    } catch (e) {
      print('Error occurred while getting total capacity: $e');
      throw e;
    }
  }

  Future<String> getNumberOfQueue(String resId) async {
    try {
      String numQueue = "0";
      QuerySnapshot tableInfoQuery = await tableInfoCollection
          .where('r_id', isEqualTo: resId)
          .get();

      // todo after create booking

      return numQueue;
    } catch (e) {
      print('Error fetching data: $e');
      throw e;
    }
  }

  Future<String> uploadImage(File image) async {
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images').child(fileName);
    final UploadTask task = firebaseStorageRef.putFile(image);
    final TaskSnapshot snapshot = await task.whenComplete(() => null);
    final String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<void> redeemCustCoupon(String resId, String code) async {
     try {
    final couponQuery = await couponCollection
        .where('r_id', isEqualTo: resId)
        .where('code', isEqualTo: code)
        .get();

    if (couponQuery.docs.isNotEmpty) {
      final couponDocId = couponQuery.docs[0].id;
      await couponCollection.doc(couponDocId).delete();
    } else {
      throw 'Coupon not found';
    }
  } catch (e) {
    print(e.toString());
    throw 'Failed to redeem coupon';
  }
  }
}
