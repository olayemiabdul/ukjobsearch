import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/authentication/authourity.dart';
import 'firebase_options.dart';

import 'package:ukjobsearch/authentication/emailverification.dart';

import 'package:ukjobsearch/utils.dart';
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    //for flutter web or you can run from terminal
    //dart pub global activate flutterfire_cli
    //flutterfire configure
    //import firebase_options.dart to main.dart

    //or use
    // options: FirebaseOptions( apiKey: "AIzaSyAQNN37TiffhHmEOMn1uVa31l1cy7XLjuA",
    // authDomain: "uk-job-search.firebaseapp.com",
    // projectId: "uk-job-search",
    // storageBucket: "uk-job-search.appspot.com",
    // messagingSenderId: "1063846392894",
    // appId: "1:1063846392894:web:efba2a0f0a8fffb587cd6f"),
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(JobsearchApp());
}

final navigatorkey = GlobalKey<NavigatorState>();

class JobsearchApp extends StatelessWidget {
  JobsearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          actionsIconTheme: const IconThemeData(color: Colors.white),
        ),
      ),
      //for user error messafe
      //scaffoldMessengerKey: Utils.showSnackBar('text'),
      scaffoldMessengerKey: messengerkey,
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: ( context)=>FavouritesJob (),
        child: Scaffold(
          body: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(
                    height: 5,
                    width: 5,
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                } else if (snapshot.hasData) {
                  return EmailVerificationPage();
                } else {
                  return myAuthPage();
                }
              }),
        ),
      ),
    );
  }
}


