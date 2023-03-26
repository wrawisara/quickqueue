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
     on FirebaseAuthException catch (e) {
    print(e.code);
    switch (e.code) {
      case 'user-not-found':
        throw FirebaseAuthException(code: e.code, message: 'User is not found');
      case 'invalid-email':
        throw FirebaseAuthException(code: e.code, message: 'Invalid email');
      case 'user-disabled':
        throw FirebaseAuthException(code: e.code, message: 'User is disabled');
      case 'wrong-password':
        throw FirebaseAuthException(code: e.code, message: 'Wrong password');
      case 'too-many-requests':
        throw FirebaseAuthException(code: e.code, message: 'Please wait');
    }
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
