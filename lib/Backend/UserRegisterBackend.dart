import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRegisterBackend{

Future<void> registerAdminWithEmailAndPassword(String email, String username, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Generate a random number for a_id
    final rand = Random();
    final a_id = rand.nextInt(99999);

    // Add data to admin collection
    await FirebaseFirestore.instance.collection('admin').doc(userCredential.user?.uid).set({
      'email': email,
      'username': username,
      'a_id': a_id.toString(),
    });
  } catch (e) {
    print('Error registering user: $e');
    throw e;
  }
}
}
