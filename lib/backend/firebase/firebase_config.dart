import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:visvocabflutter/firebase_options.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
}
