// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCDbWonZs7AXi4G19X3mnINuyENSqgVTIY',
    appId: '1:392002823379:web:7acd6abc2c168f8757a026',
    messagingSenderId: '392002823379',
    projectId: 'quickqueue-17550',
    authDomain: 'quickqueue-17550.firebaseapp.com',
    databaseURL: 'https://quickqueue-17550-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'quickqueue-17550.appspot.com',
    measurementId: 'G-J15BMFZN9E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBPgiV_YE22CtQ9DR_JKZ8po8VfPzLY4dg',
    appId: '1:392002823379:android:d3c17c96bb3f05df57a026',
    messagingSenderId: '392002823379',
    projectId: 'quickqueue-17550',
    databaseURL: 'https://quickqueue-17550-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'quickqueue-17550.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBZmucerJZJ8AzpUdeKmflJlHRV3HC35Yw',
    appId: '1:392002823379:ios:0b027d529bc7dde757a026',
    messagingSenderId: '392002823379',
    projectId: 'quickqueue-17550',
    databaseURL: 'https://quickqueue-17550-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'quickqueue-17550.appspot.com',
    iosClientId: '392002823379-c232lca23s3efcgdeekt1apljrhf54ja.apps.googleusercontent.com',
    iosBundleId: 'com.example.quickqueue',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBZmucerJZJ8AzpUdeKmflJlHRV3HC35Yw',
    appId: '1:392002823379:ios:0b027d529bc7dde757a026',
    messagingSenderId: '392002823379',
    projectId: 'quickqueue-17550',
    databaseURL: 'https://quickqueue-17550-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'quickqueue-17550.appspot.com',
    iosClientId: '392002823379-c232lca23s3efcgdeekt1apljrhf54ja.apps.googleusercontent.com',
    iosBundleId: 'com.example.quickqueue',
  );
}
