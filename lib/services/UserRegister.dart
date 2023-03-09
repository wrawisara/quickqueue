import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
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
          //int randId = await randomInt();
          //Tuple2<bool, String> result =
          //await checkIdInCollection('customer', randId.toString());
          //bool isNotEmpty = result.item1;
          //String id = result.item2;
          //if (!isNotEmpty) {
          //int salt = await randomInt();
          // create User for authentication
          await createUser(email, password);
          //String hashedPassword =
          //await hashPassword(password, salt.toString());

          // Add data to customer collection
          final customerDocRef =
              await FirebaseFirestore.instance.collection('customer').add({
            'email': email,
            //'password': hashedPassword,
            //'id': id.toString(),
            //'salt': salt.toString(),
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

          // create coupon for this customer
          await createCouponsSampleCollection(customerDocRef.id);
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

  // create with 10 coupons
  Future<void> createCouponsSampleCollection(String cusId) async {
    CollectionReference<Map<String, dynamic>> couponsCollectionRef =
        FirebaseFirestore.instance.collection('coupons');

    for (var i = 0; i < 4; i++) {
      DateTime now = DateTime.now();
      DateTime startDate = now.add(Duration(days: i));
      DateTime endDate = startDate.add(Duration(days: 7));

      String couponName = 'Coupon ${i + 1}';
      String couponCode = 'CODE${i + 1}';
      double discount = (i + 1) * 2.0;
      String description = 'Description for Coupon ${i + 1}';
      int requiredPoint = (i + 1) * 20;
      String imageUrl = 'https://via.placeholder.com/150';

      DocumentReference<Map<String, dynamic>> couponDocRef =
          couponsCollectionRef.doc();

      await couponDocRef.set({
        'name': couponName,
        'code': couponCode,
        'discount': discount,
        'description': description,
        'required_point': requiredPoint,
        'start_date': Timestamp.fromDate(startDate),
        'end_date': Timestamp.fromDate(endDate),
        'img': imageUrl,
        'cus_id': cusId,
      });
    }
  }

  Future<void> createBookingInfoForTest(String resId, String? cusId) async {
    CollectionReference<Map<String, dynamic>> bookingCollectionRef =
        FirebaseFirestore.instance.collection("bookings");
    DocumentReference<Map<String, dynamic>> bookingDocRef =
        bookingCollectionRef.doc();

    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    String timeString = DateFormat('H.mm').format(dateTime);
    
    for (var i = 0; i < 4; i ++){

    await bookingDocRef.set({
      'cus_id': cusId,
      'r_id': resId,
      'booking_queue': i,
      'date': timestamp,
      'time': timeString,
      'guest': null,
      'status': null,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp()
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
          int randId = await randomInt();
          Tuple2<bool, String> result =
              await checkIdInCollection('restaurant', randId.toString());
          bool isNotEmpty = result.item1;
          String id = result.item2;
          if (!isNotEmpty) {
            int salt = await randomInt();
            // Upload image for logo
            String imageUrl = "";
            if (image != null) {
              imageUrl = await uploadImage(image);
            }
            // create User for authentication
            await createUser(email, password);
            String hashedPassword =
                await hashPassword(password, salt.toString());

            // Add data to restaurant collection
            await FirebaseFirestore.instance.collection('restaurant').add({
              'email': email,
              'username': username,
              'id': id.toString(),
              'phone': phoneNum,
              'address': address,
              'password': hashedPassword,
              'location': GeoPoint(latitude, longitude),
              'salt': salt.toString(),
              'res_logo': imageUrl,
              'role': 'restaurant',
            });
          }
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
    // debug
    //final String imagePath = image.absolute.path;

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

  Future<String> hashPassword(String password, String salt) async {
    return sha256.convert(utf8.encode(password + salt)).toString();
  }

  Future<int> randomInt() async {
    final rand = Random();
    int id = rand.nextInt(999999);
    return id;
  }

  Future<Tuple2<bool, String>> checkIdInCollection(
      String collectionName, String id) async {
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection(collectionName)
        .where('id', isEqualTo: id)
        .get();
    bool isNotEmpty = result.docs.isNotEmpty;
    if (isNotEmpty) {
      int newId = await randomInt();
      return checkIdInCollection(collectionName, newId.toString());
    } else {
      return Tuple2(isNotEmpty, id.toString());
    }
  }
}
