import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukjobsearch/authentication/phonelogin.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';

import 'bottomNav.dart';

class ShowUpAnimation extends StatefulWidget {
  final Widget child;

  int? delay;

  ShowUpAnimation({super.key, required this.child, this.delay});

  @override
  _ShowUpAnimationState createState() => _ShowUpAnimationState();
}

class _ShowUpAnimationState extends State<ShowUpAnimation>
    with TickerProviderStateMixin {
  late AnimationController animController;

  /// CREATING THE ANIMATION  VARIABLE OF TYPE OFFSET
  late Animation<Offset> animOffset;

  /// CREATING THE TIMER VARIABLE
  late Timer timer;

  @override
  void initState() {
    super.initState();

    animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: animController);
    animOffset = Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
        .animate(curve);

    if (widget.delay == null) {
      animController.forward();
    } else {
      timer = Timer(Duration(milliseconds: widget.delay!), () {
        animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    animController.dispose();
    timer.cancel();
  }




  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animController,
      child: SlideTransition(
        position: animOffset,
        child: widget.child,
      ),
    );
  }
}

class TheWelcomePage extends StatefulWidget {
  const TheWelcomePage({super.key});

  @override
  State<TheWelcomePage> createState() => _TheWelcomePageState();
}

class _TheWelcomePageState extends State<TheWelcomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouritesJob>(
      create: (BuildContext context) =>FavouritesJob(),
      builder: (context, child){
      return SafeArea(
        child: Scaffold(
          body: AnimatedContainer(
            height: double.infinity,
            width: double.infinity,
            curve: Curves.decelerate,
            decoration:  BoxDecoration(

              image: DecorationImage(
                  image: const AssetImage('assets/images/bg1.png'),
                  fit: BoxFit.fill,
                colorFilter:  ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                  ),

            ),
            duration: const Duration(seconds: 60),
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),

                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome to Tuned Jobs!',
                        textStyle: const TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 2000),
                      ),
                    ],

                    totalRepeatCount: 4,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: RichText(
                      text: const TextSpan(
                        text:
                        'your one-stop destination for all your job search needs',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 15),
                        children: <TextSpan>[
                          // TextSpan(
                          //   text: ' \n      ',
                          //   style: TextStyle(
                          //       fontFamily: 'Satisfy',
                          //       color: Colors.black,
                          //       fontSize: 20),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: RichText(
                      text: const TextSpan(
                        text:
                        'Our platform aggregates job listings from various leading job portals across the UK,',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' the Cv-Library and Reed.co.uk ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 380,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final provider =
                      Provider.of<FavouritesJob>(context, listen: false);
                      //navigate to job search with out login or sign up
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: const myNewBar(),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: RichText(text:  const
                      TextSpan(
                        text: ' \n        ',
                        style: TextStyle(
                            fontFamily: 'Satisfy',
                            color: Colors.black,
                            fontSize: 14),

                        children: <TextSpan>[
                          TextSpan(
                            text: 'Continue Exploring Our Portal',

                            style: TextStyle(
                                fontFamily: 'Kanit Bold',
                                color: Colors.green,
                                fontSize: 14),
                          ) ,

                          TextSpan(
                            text: '\n',
                            style: TextStyle(
                                fontFamily: 'Satisfy',
                                color: Colors.black,
                                fontSize: 14),
                          ),
                          TextSpan(
                            text: ' Apply to 1M+ Jobs across the UK in 1-tap',
                            style: TextStyle(
                                fontFamily: 'Kanit Bold',
                                color: Colors.green,
                                fontSize: 14),
                          ),
                        ],
                      ), ),
                    )
                    ,
                  ),
                  const SizedBox(height: 30,),
                  const Align(
                    alignment: Alignment.center,
                    child: Text('Login Or SignUp to get personalised Offers', style: TextStyle(
                      fontFamily: 'Poppins Bold',
                      fontSize: 14,
                    ),),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 36,
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        //choosing platform
                        if (!kIsWeb && Platform.isAndroid) {
                          signInWithGoogleAI() ;
                        } else if (kIsWeb) {
                          signInWithGoogleWeb();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: [
                            Image(
                                height: 25,
                                width: 25,
                                image:
                                AssetImage('assets/images/google.png')),
                            SizedBox(
                              width: 35,
                            ),
                            Center(child: Text('Continue with Google'))
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  !kIsWeb && Platform.isAndroid?Text(''):

                  Container(
                    height: 36,
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.black,),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: const Center(
                                child: Text('Continue with Phone number')),
                            onTap: () {
                              final provider =
                              Provider.of<FavouritesJob>(context, listen: false);
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return const
                              //   PhoneLoginPage();
                              //   //PhoneOTPVerification();
                              // }));
                              // phoneSignIn();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangeNotifierProvider.value(
                                    value: provider,
                                    child: const PhoneLoginPage(),
                                  ),
                                ),
                              );
                            },
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                      text: const TextSpan(
                          text: 'By Signing up,',
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: 'Poppins Bold',
                            fontSize: 10,
                          ),
                          children: [
                            TextSpan(
                              text: 'I agree to the tuned jobs',
                              style: TextStyle(
                                fontFamily: 'Poppins Bold',
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                            TextSpan(
                              text: 'Terms of use and  Privacy policy',
                              style: TextStyle(
                                fontFamily: 'Poppins Bold',
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            )
                          ])),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
      );
      },
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogleAI() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // The user canceled the sign-in
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  Future signInWithGoogle() async {
    // Trigger the authentication flow for android
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: "YOUR_CLIENT_ID.apps.googleusercontent.com",
      scopes: <String>[
        'email',

      ],

    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    // Obtain the auth details from the request
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential result =
      await FirebaseAuth.instance.signInWithCredential(credential);
      //  User? user = result.user;
      // if (user != null) {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const myNewBar(),
      //       ));
      // }
    }
    //pop to the first page
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }
  Future<User?> signInWithGoogleWeb() async {
    //for web login
    String? name, imageUrl, userEmail, uid;
    // Initialize Firebase
    await Firebase.initializeApp();
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    // The `GoogleAuthProvider` can only be
    // used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
      await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('auth', true);
      print("name: $name");
      print("userEmail: $userEmail");
      print("imageUrl: $imageUrl");
    }
    return user;
  }
}
