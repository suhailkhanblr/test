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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
      apiKey: "AIzaSyAkE3B_eLqG51pMLT9mgybCFJVLua5JJ6E",
      authDomain: "will-sell-classified.firebaseapp.com",
      databaseURL: "https://will-sell-classified-default-rtdb.firebaseio.com",
      projectId: "will-sell-classified",
      storageBucket: "will-sell-classified.appspot.com",
      messagingSenderId: "118794407923",
      appId: "1:118794407923:web:00bf7ef8f5ea136efacc86",
      measurementId: "G-VBJ1WFYNXS"
  );
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARuUXN7TvMM8o1wimHk2VYE1diLJIFhvQ',
    appId: '1:118794407923:android:9ba72f789f93697cfacc86',
    messagingSenderId: '118794407923',
    projectId: 'will-sell-classified',
    databaseURL: 'https://will-sell-classified-default-rtdb.firebaseio.com',
    storageBucket: 'will-sell-classified.appspot.com',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpIsw3dn84pDYTwuje6hyavYQPNcrNAh4',
    appId: '1:118794407923:ios:af09ed33464de5d7facc86',
    messagingSenderId: '118794407923',
    projectId: 'will-sell-classified',
    databaseURL: 'https://will-sell-classified-default-rtdb.firebaseio.com',
    storageBucket: 'will-sell-classified.appspot.com',
    androidClientId:
    '118794407923-4e0ikbp8qjhg0hi3qp4o5semf9nvl8ib.apps.googleusercontent.com',
    iosClientId:
    '118794407923-s99j5senc6k7ecdg01tgbpn2iqeqbnqt.apps.googleusercontent.com',
    iosBundleId: 'com.duet.classified.iosapp',
  );
}
