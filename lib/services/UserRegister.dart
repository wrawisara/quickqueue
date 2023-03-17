import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:quickqueue/model/restaurant.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class UserRegisterService {
  Future<void> registerCustomerWithEmailAndPassword(
      String email,
      String firstname,
      String lastname,
      String password,
      String phoneNum) async {
    if (EmailValidator.validate(email)) {
      try {
        final customerDocResult = await FirebaseFirestore.instance
            .collection('customer')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (customerDocResult.docs.isNotEmpty) {
          throw FirebaseAuthException(
              code: 'email-is-already-in-use',
              message: 'The email is already use');
        } else {
          final userCrendential = await createUser(email, password);
          final id = userCrendential.user!.uid;

          // Add data to customer collection
          final customerDocRef =
              await FirebaseFirestore.instance.collection('customer').add({
            'c_id': id,
            'email': email,
            'firstname': firstname,
            'lastname': lastname,
            'phone': phoneNum,
            'tier': 'Bronze',
            'point_m': 0, //  membership points
            'point_c': 0, // coupon points
            'status': "", // booking status
            'reputation_points': 100, // reputation if cancel = go down
            'role': 'customer',
          });
          //}
        }
      } catch (e) {
        throw FirebaseAuthException(
            code: 'Somthing wrong',
            message: 'Unknown error occur: ${e.toString()}');
      }
    } // Invalid email
    else {
      throw FirebaseAuthException(
          code: 'invalid-email', message: 'The email is invalid');
    }
  }

  // create with no coupon
  Future<void> createCouponsCollection(String uid) async {
    final CollectionReference<Map<String, dynamic>> couponsCollection =
        FirebaseFirestore.instance.collection('coupons');
    final DocumentReference<Map<String, dynamic>> customerDocRef =
        FirebaseFirestore.instance.collection('customer').doc(uid);
    final DocumentReference<Map<String, dynamic>> couponsDocRef =
        couponsCollection.doc(uid);

    try {
      // Get user data
      final DocumentSnapshot<Map<String, dynamic>> customerData =
          await customerDocRef.get();

      // Create coupons collection with user data
      await couponsDocRef.set({
        'user': customerDocRef,
        'email': customerData.get('email'),
        'coupons': [],
      });
    } catch (e) {
      print('Error creating coupons collection: $e');
    }
  }

  Future<void> createBookingInfo(String resId) async {
    CollectionReference<Map<String, dynamic>> bookingCollectionRef =
        FirebaseFirestore.instance.collection("bookings");
    DocumentReference<Map<String, dynamic>> bookingDocRef =
        bookingCollectionRef.doc();

    Timestamp timestamp = Timestamp.now();
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    DateTime dateTime = timestamp.toDate();
    String timeString = DateFormat('H.mm').format(dateTime);

    await bookingDocRef.set({
      'c_id': '',
      'r_id': resId,
      'booking_queue': null,
      'date': date,
      'time': timeString,
      'guest': null,
      'status': null,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp()
    });
  }

  Future<void> createCollectionIfNotExists(String collectionName) async {
    CollectionReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection(collectionName);
    DocumentReference<Map<String, dynamic>> docRef = collectionRef.doc('dummy');
    await docRef.set({'created': true});
    await docRef.delete();
  }

  Future<void> createTableInfoWhenRegister(String resId) async {
    final tableInfoCollectionRef =
        FirebaseFirestore.instance.collection("tableInfo");
    for (var tableType in ['A', 'B', 'C', 'D', 'E']) {
      final querySnapshot = await tableInfoCollectionRef
          .where('r_id', isEqualTo: resId)
          .where('table_type', isEqualTo: tableType)
          .limit(1)
          .get();

      if (querySnapshot.size == 0) {
        // Collection does not exist, create it
        await createCollectionIfNotExists('tableInfo');
      }
      
      await FirebaseFirestore.instance.collection('tableInfo').add({
            'r_id': resId,
            'available': 0,
            'capacity': 0,
            'table_type': tableType,
          });
    }
  }

  Future<void> registerRestaurantWithEmailAndPassword(
      String email,
      String username,
      String password,
      String phoneNum,
      String address,
      double latitude,
      double longitude,
      String branch,
      File image) async {
    if (EmailValidator.validate(email)) {
      try {
        final restaurantEmailResult = await FirebaseFirestore.instance
            .collection('restaurant')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        if (restaurantEmailResult.docs.isNotEmpty) {
          throw FirebaseAuthException(
              code: 'email-is-already-in-use',
              message: 'The email is already use');
        } else {
          String imageUrl = "";
          if (image != null) {
            imageUrl = await uploadImage(image);
          }
          // create User for authentication
          final userCrendential = await createUser(email, password);
          final id = userCrendential.user!.uid;

          // Add data to restaurant collection
          final docRef =
              await FirebaseFirestore.instance.collection('restaurant').add({
            'r_id': id,
            'email': email,
            'username': username,
            'phone': phoneNum,
            'address': address,
            'location': GeoPoint(latitude, longitude),
            'res_logo': imageUrl,
            'queue_status': 'close',
            'role': 'restaurant',
          });
          createTableInfoWhenRegister(id);
          //createBookingInfo(id);
          //}
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw FirebaseAuthException(
              code: 'weak-password', message: 'Password is too weak');
        }
      } catch (e) {
        print(e.toString());
      }
    } // Invalid email
    else {
      throw FirebaseAuthException(
          code: 'invalid-email', message: 'The email is invalid');
    }
  }

  Future<String> uploadImage(File image) async {
    // uploading code
    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch.toString()}.png';
    final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('images').child(fileName);
    final UploadTask task = firebaseStorageRef.putFile(image);
    final TaskSnapshot snapshot = await task.whenComplete(() => null);
    final String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  Future<UserCredential> createUser(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
}
