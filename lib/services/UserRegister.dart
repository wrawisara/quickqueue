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
            'point_m': 10, //  membership points
            'point_c': 10, // coupon points
            'reputation_points': 100, // reputation if cancel = go down
            'role': 'customer',
          });
          //}
        }
      } catch (e) {
        throw FirebaseAuthException(
            code: 'Somthing wrong',
            message: 'This email is already use. Please try again.');
      }
    } // Invalid email
    else {
      throw FirebaseAuthException(
          code: 'invalid-email', message: 'The email is invalid');
    }
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
              message: 'This email is already use. Please try again. ');
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
            'branch': branch,
            'location': GeoPoint(latitude, longitude),
            'res_logo': imageUrl,
            'status': 'close',
            'role': 'restaurant',
          });
          createTableInfoWhenRegister(id);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw FirebaseAuthException(
              code: 'weak-password', message: 'Password is too weak');
        } else {
          rethrow;
        }
        
      } catch (e) {
        print(e.toString());
        throw FirebaseAuthException(
            code: 'Somthing wrong',
            message: 'This email is already use. Please try again.');
      }
    } // Invalid email
    else {
      throw FirebaseAuthException(
          code: 'invalid-email', message: 'The email is invalid');
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

  Future<UserCredential> createUser(String email, String password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
}
