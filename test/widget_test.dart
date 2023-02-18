@TestOn('vm')
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quickqueue/services/UserRegisterBackend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   testWidgets('registerWithEmailAndPassword should create a new admin document in Firestore', (WidgetTester tester) async {
    runApp(MaterialApp(home: Scaffold()));
      await tester.runAsync(() async {
        UserRegisterBackend check = UserRegisterBackend();
        await check.registerAdminWithEmailAndPassword('test@example.com', 'testuser', 'testpassword');
      });
      await Future.delayed(Duration(seconds: 1)); // wait for Firestore to update
      final snapshot = await FirebaseFirestore.instance.collection('admin').where('email', isEqualTo: 'test@example.com').get();
      expect(snapshot.docs.length, 1);
      expect(snapshot.docs[0].data()['email'], 'test@example.com');
      expect(snapshot.docs[0].data()['username'], 'testuser');
    });
  }







//simple flutter test
// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:quickqueue/main.dart';

// void main() {
//   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
//     // Build our app and trigger a frame.
//     await tester.pumpWidget(const MyApp());

//     // Verify that our counter starts at 0.
//     expect(find.text('0'), findsOneWidget);
//     expect(find.text('1'), findsNothing);

//     // Tap the '+' icon and trigger a frame.
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();

//     // Verify that our counter has incremented.
//     expect(find.text('0'), findsNothing);
//     expect(find.text('1'), findsOneWidget);
//   });
// }
