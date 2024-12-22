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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyB42L7MOqPayc0NeDtUaqfrHDSEN_R4l4Q',
    appId: '1:442226138880:web:6d50816661a3cdfddf5de5',
    messagingSenderId: '442226138880',
    projectId: 'travel-app-1c796',
    authDomain: 'travel-app-1c796.firebaseapp.com',
    storageBucket: 'travel-app-1c796.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCs6GzSPdiw8GvhkzrFSLf5VFb2pCizQXo',
    appId: '1:442226138880:android:4650240fdf036c66df5de5',
    messagingSenderId: '442226138880',
    projectId: 'travel-app-1c796',
    storageBucket: 'travel-app-1c796.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB42L7MOqPayc0NeDtUaqfrHDSEN_R4l4Q',
    appId: '1:442226138880:web:ef8bf97d57b1ef7ddf5de5',
    messagingSenderId: '442226138880',
    projectId: 'travel-app-1c796',
    authDomain: 'travel-app-1c796.firebaseapp.com',
    storageBucket: 'travel-app-1c796.firebasestorage.app',
  );
}