import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class UserRegister{

Future<void> registerAdminWithEmailAndPassword(String email, String username, String password) async {
  // validate Email 
  if (EmailValidator.validate(email)){
  try {
    final emailCheck = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: email)
        .get();
    if (emailCheck.docs.isNotEmpty){
      throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is aldreay use');
    } else {
      UserCredential userCredential = await createUser(email, password);

      int id = randomInt();
      bool isNotEmpty = await checkIdInCollection('admin', id.toString());
      if (!isNotEmpty){
        // Add data to admin collection
        await FirebaseFirestore.instance.collection('admin').doc(userCredential.user?.uid).set({
        'email': email,
        'username': username,
        'a_id': randomInt().toString(),
        });
      }
    }
  } catch (e) {
    throw FirebaseAuthException(code: 'somthing-wrong', message: 'Unknown error occur');
  }
  } 
  // Invalid email
  else {
    throw FirebaseAuthException(code: 'invalid-email', message: 'The email is invalid');
  }
}

Future<void> registerCustomerWithEmailAndPassword(String email, String firstname, String lastname,  String password, String phoneNum ) async {
  if (EmailValidator.validate(email)){
  try {
    final checking_result = await FirebaseFirestore.instance
        .collection('customer')
        .where('email', isEqualTo: email)
        .get();
    if (checking_result.docs.isNotEmpty){
        throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
        UserCredential userCredential = await createUser(email, password);

        int id = randomInt();
        bool isNotEmpty = await checkIdInCollection('customer', id.toString());
        if (!isNotEmpty){
          // Add data to customer collection
          await FirebaseFirestore.instance.collection('customer').doc(userCredential.user?.uid).set({
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'cus_id': randomInt().toString(),
          'phone': phoneNum,
          });
        }
      }
    } catch (e) {
    throw FirebaseAuthException(code: 'Somthing wrong', message: 'Unknown error occur');
    } 
  } // Invalid email
  else {
    throw FirebaseAuthException(code: 'invalid-email', message: 'The email is invalid');
  }
}

Future<void> registerRestaurantWithEmailAndPassword(String email, String username, String password, String phoneNum
, String address, double latitude, double longitude, String branch, Blob logo) async {
  if (EmailValidator.validate(email)){
  try {
    final customerEmailResult = await FirebaseFirestore.instance
        .collection('customer')
        .where('email', isEqualTo: email)
        .get();
    if (customerEmailResult.docs.isNotEmpty){
      throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
      UserCredential userCredential = await createUser(email, password);

      int id = randomInt();
      bool isNotEmpty = await checkIdInCollection('restaurant', id.toString());
      if (!isNotEmpty){
        // Add data to restaurant collection
        await FirebaseFirestore.instance.collection('restaurant').doc(userCredential.user?.uid).set({
        'email': email,
        'username': username,
        'r_id': randomInt().toString(),
        'phone': phoneNum,
        'address': address,
        'location': GeoPoint(latitude, longitude),
        });

      } 
    }
    } catch (e) {
    throw FirebaseAuthException(code: 'Somthing wrong', message: 'Unknown error occur');
    } 
  } // Invalid email
  else {
    throw FirebaseAuthException(code: 'invalid-email', message: 'The email is invalid');
  }
}

Future<UserCredential> createUser(String email, String password) async{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: hashPassword(password),);
      return userCredential;
}

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}


randomInt() async{
  final rand = Random();
  int id = rand.nextInt(99999);
  return id;
}

Future<bool> checkIdInCollection(String collectionName, String id) async{
  final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: id)
      .get();
  bool isNotEmpty = result.docs.isNotEmpty;
  if (!isNotEmpty){
    int newId = randomInt();
    return checkIdInCollection(collectionName, newId.toString());
  } else {
  return isNotEmpty;
  }
}
}