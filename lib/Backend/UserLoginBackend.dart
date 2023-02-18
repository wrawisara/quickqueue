import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<UserCredential?> adminSignInWithEmailAndPassword(
    String email, String password) async {
  try {
    // using method from Firebase cannot change the name
    // error code 
    //invalid-email:
    //Thrown if the email address is not valid.
    //user-disabled:
    //Thrown if the user corresponding to the given email has been disabled.
    //user-not-found:
    //Thrown if there is no user corresponding to the given email.
    //wrong-password:
    //Thrown if the password is invalid for the given email, or the account corresponding to the email does not have a password set.
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

//Get admin form collection admin that email is equal to given email
    final adminDocs = await FirebaseFirestore.instance
        .collection('admin')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

// check if adminDocs is Empty or not  then check if the password is correct
    if (adminDocs.docs.isNotEmpty) {
      final admin = adminDocs.docs.first;
      if (admin['password'] == password) {
        return userCredential;
      } else {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect password',
        );
      }
    }
    // Exception 
  } on FirebaseAuthException catch (e) {
    print('FirebaseAuthException $e');
    throw e;
  } catch (e) {
    print('Error $e');
    throw e;
  }
}
