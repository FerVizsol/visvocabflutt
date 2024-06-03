import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:visvocabflutter/firebase_options.dart';

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.deviceCheck,
  );
}
