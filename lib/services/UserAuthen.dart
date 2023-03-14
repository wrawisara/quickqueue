import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthenServices {
  // Create Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
Future<User?> userSignInWithEmailAndPassword({required String email, required String password}) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
    }
    // Exception 
     on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case 'user-not-found':
        throw FirebaseAuthException(code: e.code, message: 'User is not found');
      case 'invalid-email':
        throw FirebaseAuthException(code: e.code, message: 'Invalid email');
      case 'user-disabled':
        throw FirebaseAuthException(code: e.code, message: 'User is disabled');
    }
  } 
}

// not used anymore
Future<bool> isPasswordCorrect(String email, String password, String collectionName) async{
  QuerySnapshot<Map<String, dynamic>> collectionQuery =
      await FirebaseFirestore.instance
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();


    // Get the hashed password for the user from the document
    String hashedPassword = collectionQuery.docs[0].data()['password'];

    // Hash the login password
    String salt = collectionQuery.docs[0].data()['salt'];
    String hashedLoginPassword = sha256.convert(utf8.encode(password + salt)).toString();
    

    // Check if the hashed login password matches the hashed password in the database
    if (hashedPassword != hashedLoginPassword) {
      return false;
    } else {
      return true;
    }
}

Future<String> getUserType(String email, String password) async {
  List<String> collectionName = ['customer', 'restaurant'];
  for(String c in collectionName){ 
      QuerySnapshot<Map<String, dynamic>> collectionQuery =
      await FirebaseFirestore.instance
          .collection(c)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (collectionQuery.docs.isNotEmpty){
        return collectionQuery.docs[0].data()['role'];
      }
  }
  throw FirebaseAuthException(
    code: 'user-not-found',
    message: 'User not found',
  );
}
  
  
  Future<void> logout() async {
    await _auth.signOut();
  }
}
