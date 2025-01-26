import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: _apiKeyWeb,
        appId: _appIdWeb,
        messagingSenderId: _messagingSenderIdWeb,
        projectId: _projectId,
        authDomain: _authDomainWeb,
        storageBucket: _storageBucket,
        measurementId: _measurementIdWeb,
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: _apiKeyAndroid,
          appId: _appIdAndroid,
          messagingSenderId: _messagingSenderIdAndroid,
          projectId: _projectId,
          storageBucket: _storageBucket,
        );
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

  // Web Configuration
  static const String _apiKeyWeb = 'AIzaSyAi2qOlY2EmEobmHryWEdlNZic_Q0-pFAg';
  static const String _appIdWeb = '1:1005411286344:web:7047888cdde23b9feb477d';
  static const String _messagingSenderIdWeb = '1005411286344';
  static const String _measurementIdWeb = 'G-C327K28XRW';

  // Android Configuration
  static const String _apiKeyAndroid = 'AIzaSyAVWrBtM0Ugbtn0SbCA8cv2xC5dJ9rhw8E';
  static const String _appIdAndroid = '1:1005411286344:android:848928ba939ed985eb477d';
  static const String _messagingSenderIdAndroid = '1005411286344';

  // Common Configuration
  static const String _projectId = 'nasa-apod-rkd';
  static const String _authDomainWeb = 'nasa-apod-rkd.firebaseapp.com';
  static const String _storageBucket = 'nasa-apod-rkd.firebasestorage.app';
}
