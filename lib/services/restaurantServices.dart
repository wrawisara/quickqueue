import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class RestaurantServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String generateCouponCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

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
      String couponCode = generateCouponCode();
      //check
      print(couponName);

      await _firestore.collection('coupons').add({
        'couponName': couponName,
        'code': couponCode,
        'cus_id': null,
        'res_id': resId,
        'menu': couponMenuName,
        'discount': discount,
        'required_point': requiredPoint,
        'tier': tier,
        'start_date': Timestamp.fromDate(now),
        'end_date': expiredDate,
        'img': imageUrl,
      });
    } catch (e) {
      print('Error adding coupon: $e');
    }
  }

  // haven't check
  Future<void> setTableInfo(String resId, Map<String, int> tableInfo) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('tableInfo');
      final querySnapshot =
          await collectionRef.where('r_id', isEqualTo: resId).get();

      // Iterate over the documents and update the tableType and capacity attributes
      final batch = FirebaseFirestore.instance.batch();

      querySnapshot.docs.forEach((doc) {
        String tableType = '';
        Map<String, dynamic>? data;
        int capacity;

        // Check if the document exists and has data
        if (doc.exists && doc.data() != null) {
          data = doc.data();
          tableType = data['table_type'];
        } else {
          // Handle the case when the document does not exist
          // or does not have data, e.g. by creating a new document
          data = {
            'available': 0,
            'capacity': 0,
          };
        }

        // Update the data for the specified table types
        tableInfo.forEach((key, value) {
          if (key == tableType) {
            int capacity = value;
            data!['capacity'] = capacity;
            data['available'] = capacity;
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
        int capacity;

        // Check if the document exists and has data
        if (doc.exists && doc.data() != null) {
          data = doc.data();
          tableType = data['table_type'];
        } else {
          // Handle the case when the document does not exist
          // or does not have data, e.g. by creating a new document
          data = {
            'available': 0,
            'capacity': 0,
          };
        }

        // Update the data for the specified table types
        tableInfo.forEach((key, value) {
          if (key == tableType) {
            data!['capacity'] = value;
            data['available'] = eTableNum;
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
      QuerySnapshot tableInfoQuery = await _firestore
          .collection('tableInfo')
          .where('r_id', isEqualTo: resId)
          .get();

      List<Map<String, dynamic>> tableInfo = [];

      tableInfoQuery.docs.forEach((doc) {
        int available = doc.get('available');
        int capacity = doc.get('capacity');
        String tableType = doc.get('table_type');

        tableInfo.add({
          'available': available,
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

  Future<String> getNumberOfQueue(String resId) async {
    try {
      String numQueue = "0";
      QuerySnapshot tableInfoQuery = await _firestore
          .collection('tableInfo')
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
}