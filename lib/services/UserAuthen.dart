import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthenServices {
  // Create Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
Future<UserCredential?> adminSignInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  // This part use to perform CRUD operation Read, Create, Update, Delete
    final adminDocs = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();


// check if adminDocs is Empty or not  then check if the password is correct
    if (adminDocs.docs.isNotEmpty) {
      bool isPasswordValid = await isPasswordCorrect(email, password);
      if (isPasswordValid){
          return userCredential;
      } else {
          throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect password',
        );
      }
    }
    // Exception 
  } catch (e) {
    throw FirebaseAuthException(code: 'something-went-wrong', message: 'Something went wrong');
  } 
}


Future<UserCredential?> customerSignInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

  // This part use to perform CRUD operation Read, Create, Update, Delete
    final customerDocs = await FirebaseFirestore.instance
        .collection('customer')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();


// check if customerDocs is Empty or not  then check if the password is correct
    if (customerDocs.docs.isNotEmpty) {
      bool isPasswordValid = await isPasswordCorrect(email, password);
      if (isPasswordValid){
          return userCredential;
      } else {
          throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect password',
        );
      }
    }
    // Exception 
  } catch (e) {
    throw FirebaseAuthException(code: 'something-went-wrong', message: 'Something went wrong');
  } 
}

Future<bool> isPasswordCorrect(String email, String password) async{
  QuerySnapshot<Map<String, dynamic>> adminQuery =
      await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();


    // Get the hashed password for the user from the document
    String hashedPassword = adminQuery.docs[0].data()['password'];

    // Hash the login password
    String hashedLoginPassword = sha256.convert(utf8.encode(password)).toString();

    // Check if the hashed login password matches the hashed password in the database
    if (hashedPassword != hashedLoginPassword) {
      return false;
    } else {
      return true;
    }
}
}
