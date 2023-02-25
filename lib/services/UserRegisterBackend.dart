import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class UserRegisterService{

Future<void> registerCustomerWithEmailAndPassword(String email, String firstname, String lastname, String password, String phoneNum ) async {
  if (EmailValidator.validate(email)){
  try {
    final checkingResult = await FirebaseFirestore.instance
        .collection('customer')
        .where('email', isEqualTo: email)
        .get();
    if (checkingResult.docs.isNotEmpty){
        throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
        //UserCredential userCredential = await createUser(email, password);

        int salt = await randomInt();
        String hashedPassword = await hashPassword(password, salt.toString());
        int id = await randomInt();
        bool isNotEmpty = await checkIdInCollection('customer', id.toString());
        if (!isNotEmpty){
          // Add data to customer collection
          await FirebaseFirestore.instance.collection('customer').add({
          'email': email,
          'password': hashedPassword,
          'id': id.toString(),
          'salt': salt,
          'firstname': firstname,
          'lastname': lastname,
          'phone': phoneNum,
          'role': 'Customer',
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

// Finished
Future<void> registerRestaurantWithEmailAndPassword(String email, String username, String password, String phoneNum
, String address, double latitude, double longitude, String branch) async {
  if (EmailValidator.validate(email)){
  try {
    final customerEmailResult = await FirebaseFirestore.instance
        .collection('restaurant')
        .where('email', isEqualTo: email)
        .get();
    if (customerEmailResult.docs.isNotEmpty){
      throw FirebaseAuthException(code: 'email-is-already-in-use', message: 'The email is already use');
    } else {
      //UserCredential userCredential = await createUser(email, password); 

      int salt = await randomInt();
      String hashedPassword = await hashPassword(password, salt.toString());
      int id = await randomInt();
      bool isNotEmpty = await checkIdInCollection('restaurant', id.toString());
      if (!isNotEmpty){
        // Add data to restaurant collection
        await FirebaseFirestore.instance.collection('restaurant').add({
        'email': email,
        'username': username,
        'id': id.toString(),
        'phone': phoneNum,
        'address': address,
        'password': hashedPassword,
        'location': GeoPoint(latitude, longitude),
        'salt': salt,
        'role': 'Restaurant'
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

//Future<UserCredential> createUser(String email, String password) async{
      //UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //email: email,
      //password: await hashPassword(password),);
      //return userCredential;
//}

Future<String> hashPassword(String password, String salt) async{
  return sha256.convert(utf8.encode(password + salt)).toString();
}


Future<int> randomInt() async{
  final rand = Random();
  int id = rand.nextInt(999999);
  return id;
}


Future<bool> checkIdInCollection(String collectionName, String id) async{
  final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
      .collection(collectionName)
      .where('id', isEqualTo: id)
      .get();
  bool isNotEmpty = result.docs.isNotEmpty;
  if (isNotEmpty){
    int newId = await randomInt();
    return checkIdInCollection(collectionName, newId.toString());
  } else {
  return isNotEmpty;
  }
}
}