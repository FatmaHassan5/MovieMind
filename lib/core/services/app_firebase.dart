import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// تهيئة Firebase مرة واحدة عند بداية التطبيق.
/// لو التهيئة فشلت (مثلاً لسه ما عملتيش `flutterfire configure`)
/// التطبيق مش بيقع — [ready] بتفضل false وصفحات الدخول بتعرض رسالة واضحة.
abstract class AppFirebase {
  static bool ready = false;

  static Future<void> init() async {
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      ready = true;
    } catch (e) {
      debugPrint('Firebase init failed: $e');
    }
  }
}
