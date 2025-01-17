import 'dart:io';


import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/authentication/authourity.dart';
import 'package:ukjobsearch/refactored%20code/firstPage.dart';
import 'firebase_options.dart';

import 'package:ukjobsearch/Auth/emailverification.dart';

import 'package:ukjobsearch/utils.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
Future<void> initializeFirebase() async {
  await Firebase.initializeApp();


}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  //   //for flutter web or you can run from terminal
  //   //dart pub global activate flutterfire_cli
  //   //flutterfire configure
  //   //import firebase_options.dart to main.dart
  //
  //   //or use
  //   // options: const FirebaseOptions( apiKey: "AIzaSyAQNN37TiffhHmEOMn1uVa31l1cy7XLjuA",
  //   // authDomain: "uk-job-search.firebaseapp.com",
  //   // projectId: "uk-job-search",
  //   // storageBucket: "uk-job-search.appspot.com",
  //   // messagingSenderId: "1063846392894",
  //   // appId: "1:1063846392894:web:efba2a0f0a8fffb587cd6f"),
  // );
  // Initialize App Check after Firebase initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Wait a moment after Firebase initialization
    await Future.delayed(const Duration(milliseconds: 500));

    // Initialize App Check with debug token for development
    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      // Production configuration
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.deviceCheck,
      );
    }

    print('Firebase and App Check initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    rethrow;
  }


  HttpOverrides.global = MyHttpOverrides();
  //statusbar color
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF7FFFD4),
      statusBarIconBrightness: Brightness.light,
  ));
  runApp(const JobsearchApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class JobsearchApp extends StatelessWidget {
  const JobsearchApp({Key? key}) : super(key: key);
  ColorScheme generatedScheme() {
    return const ColorScheme(
      // hot pink with teal
      brightness: Brightness.dark,
      primary: Color(0xff50C878),
      onPrimary: Colors.white,
      primaryContainer: Color(0xffFFABDE),
      onPrimaryContainer: Color(0xff21005D),
      secondary: Color(0xffFFD166),
      onSecondary: Colors.black,
      secondaryContainer: Color(0xffffFCD2),
      onSecondaryContainer: Color(0xff422B08),
      error: Color(0xffFF3B30),
      onError: Colors.white,
      errorContainer: Color(0xffFFDAD4),
      onErrorContainer: Color(0xff410002),
      background: Color(0xffFCF8FF),
      onBackground: Color(0xff201A20),
      surface: Color(0xffFEF2FE),
      onSurface: Color(0xff201A20),
      surfaceVariant: Color(0xffDBD5E0),
      onSurfaceVariant: Color(0xff49454F),
      outline: Color(0xff857E92),
      outlineVariant: Color(0xff68606F),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff362F33),
      onInverseSurface: Color(0xffFBF0F3),
      inversePrimary: Color(0xff7FFFD4),
      surfaceTint: Color(0xffFF80AB),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context)=>FavouritesJob(),
      builder: (context, child){
        return  MaterialApp(
          theme: ThemeData(colorScheme: generatedScheme()),
          //for user error messafe
          //scaffoldMessengerKey: Utils.showSnackBar('text'),
          scaffoldMessengerKey: messengerkey,
          navigatorKey: navigatorkey,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: SizedBox(
                          height: 5,
                          width: 5,
                          child: CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.hasData) {
                    return const EmailVerificationPage();
                  } else {
                    return const TheWelcomePage();
                  }
                }),
          ),
        );
      },

    );
  }
}
