import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:tuple/tuple.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


class UserRegisterService{

Future<void> registerCustomerWithEmailAndPassword(String email, String firstname, String lastname, String password, String phoneNum ) async {
  if (EmailValidator.validate(email)){
  try {
    final checkingResult = await FirebaseFirestore.instance
        .collection('customer')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (checkingResult.docs.isNotEmpty){
        throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
        int randId = await randomInt();
        Tuple2<bool, String> result = await checkIdInCollection('customer', randId.toString());
        bool isNotEmpty = result.item1;
        String id = result.item2;
        if (!isNotEmpty){
          int salt = await randomInt();
          // create User for authentication
          await createUser(email, password);
          String hashedPassword = await hashPassword(password, salt.toString());

          // Add data to customer collection
          await FirebaseFirestore.instance.collection('customer').add({
          'email': email,
          'password': hashedPassword,
          'id': id.toString(),
          'salt': salt.toString(),
          'firstname': firstname,
          'lastname': lastname,
          'phone': phoneNum,
          'point_m': 0, //  membership points
          'point_c': 0, // coupon points
          'status': "", // booking status
          'reputation_points': 100, // reputation if cancel = go down
          'role': 'customer',
          });
        }
      }
    } catch (e) {
    throw FirebaseAuthException(code: 'Somthing wrong', message: 'Unknown error occur: ${e.toString()}');
    } 
  } // Invalid email
  else {
    throw FirebaseAuthException(code: 'invalid-email', message: 'The email is invalid');
  }
}


Future<void> registerRestaurantWithEmailAndPassword(String email, String username, String password, String phoneNum
, String address, double latitude, double longitude, String branch, File image) async {
  if (EmailValidator.validate(email)){
  try {
    final customerEmailResult = await FirebaseFirestore.instance
        .collection('restaurant')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();
    if (customerEmailResult.docs.isNotEmpty){
      throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
      int randId = await randomInt();
      Tuple2<bool, String> result = await checkIdInCollection('restaurant', randId.toString());
      bool isNotEmpty = result.item1;
      String id = result.item2;
      if (!isNotEmpty){
        int salt = await randomInt();
        // create User for authentication
        await createUser(email, password);
        String hashedPassword = await hashPassword(password, salt.toString());

        // Upload image for logo
        String imageUrl = uploadImage(image, 'restaurant');

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
    } on FirebaseAuthException catch(e){
      if (e.code == 'weak-password'){
        throw FirebaseAuthException(code: 'weak-password', message: 'Password is too weak');
      }
    } catch (e) {
      print(e.toString());
    } 
  } // Invalid email
  else {
    throw FirebaseAuthException(code: 'invalid-email', message: 'The email is invalid');
  }
}

uploadImage(File image, String collectionName) async{
  final String fileName = '${DateTime.now().millisecondsSinceEpoch.toString()}.png';
  final Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(collectionName).child(fileName);
  final UploadTask task = firebaseStorageRef.putFile(image);
  final TaskSnapshot snapshot = await task.whenComplete(() => null);
  final String imageUrl = await snapshot.ref.getDownloadURL();
  return imageUrl;
}

Future<UserCredential> createUser(String email, String password) async{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password);
      return userCredential;
}

Future<String> hashPassword(String password, String salt) async{
  return sha256.convert(utf8.encode(password + salt)).toString();
}


Future<int> randomInt() async{
  final rand = Random();
  int id = rand.nextInt(999999);
  return id;
}


Future<Tuple2<bool, String>> checkIdInCollection(String collectionName, String id) async{
  final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: id)
      .get();
  bool isNotEmpty = result.docs.isNotEmpty;
  if (isNotEmpty){
    int newId = await randomInt();
    return checkIdInCollection(collectionName, newId.toString());
  } else {
  return Tuple2(isNotEmpty, id.toString());
  }
}
}