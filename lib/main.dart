import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'config/firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/disclaimer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable offline persistence for Direct writes/reads
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final prefs = await SharedPreferences.getInstance();
  final hasAgreed = prefs.getBool('has_agreed_to_disclaimer') ?? false;

  runApp(RailAlertApp(hasAgreedToDisclaimer: hasAgreed));
}

class RailAlertApp extends StatelessWidget {
  final bool hasAgreedToDisclaimer;

  const RailAlertApp({super.key, required this.hasAgreedToDisclaimer});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RailAlert Raiwala',
      theme: AppTheme.themeData,
      home: hasAgreedToDisclaimer 
          ? const Scaffold(body: Center(child: Text('Dashboard Placeholder - Awaiting Step 14')))
          : const DisclaimerScreen(),
    );
  }
}
