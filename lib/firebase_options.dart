// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDbrShRkJo2dYUznPXUK8BNjnPKD7yRjHk',
    appId: '1:269095760236:web:6f8c46537a2e026415c349',
    messagingSenderId: '269095760236',
    projectId: 'sauvage-91416',
    authDomain: 'sauvage-91416.firebaseapp.com',
    storageBucket: 'sauvage-91416.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBYrWiXs3QCvHkdi111TQIfEf5hvI-2jCo',
    appId: '1:269095760236:android:006288e837b61dc415c349',
    messagingSenderId: '269095760236',
    projectId: 'sauvage-91416',
    storageBucket: 'sauvage-91416.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyARnG5XaOqy2lic536tZ1YjD7hBYyQLVZo',
    appId: '1:269095760236:ios:12c7a7c993a9826e15c349',
    messagingSenderId: '269095760236',
    projectId: 'sauvage-91416',
    storageBucket: 'sauvage-91416.appspot.com',
    iosBundleId: 'com.example.dineIn',
  );
}
