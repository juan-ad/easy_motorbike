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
    apiKey: 'AIzaSyBJGFsb78Q9IfE6Dt9ZuQjsOL2wk5mzbh8',
    appId: '1:824369544494:web:a8a2f6a7295765502f0ebf',
    messagingSenderId: '824369544494',
    projectId: 'easy-moto-flutter',
    authDomain: 'easy-moto-flutter.firebaseapp.com',
    storageBucket: 'easy-moto-flutter.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvjtOBtjHdzUEmzWG1FRnnKp0kzaGhj4M',
    appId: '1:824369544494:android:5686d579786a82652f0ebf',
    messagingSenderId: '824369544494',
    projectId: 'easy-moto-flutter',
    storageBucket: 'easy-moto-flutter.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCZqm_4NI1lBUtnSlCRDekg4xQjf-t3XvQ',
    appId: '1:824369544494:ios:46a51f28db231b962f0ebf',
    messagingSenderId: '824369544494',
    projectId: 'easy-moto-flutter',
    storageBucket: 'easy-moto-flutter.appspot.com',
    androidClientId: '824369544494-j54h20fsn7aglvc7bti9hdnqla75qgei.apps.googleusercontent.com',
    iosClientId: '824369544494-4mnc5t0mnsrtholu5dtcgaifrmbe5ah1.apps.googleusercontent.com',
    iosBundleId: 'com.mobile.easymotorbike.easyMotorbike',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCZqm_4NI1lBUtnSlCRDekg4xQjf-t3XvQ',
    appId: '1:824369544494:ios:46a51f28db231b962f0ebf',
    messagingSenderId: '824369544494',
    projectId: 'easy-moto-flutter',
    storageBucket: 'easy-moto-flutter.appspot.com',
    androidClientId: '824369544494-j54h20fsn7aglvc7bti9hdnqla75qgei.apps.googleusercontent.com',
    iosClientId: '824369544494-4mnc5t0mnsrtholu5dtcgaifrmbe5ah1.apps.googleusercontent.com',
    iosBundleId: 'com.mobile.easymotorbike.easyMotorbike',
  );
}
