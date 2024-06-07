import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/authentication/forgotpassword.dart';

import 'package:ukjobsearch/authentication/phonelogin.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/screen/bottomNav.dart';
import 'package:ukjobsearch/utils.dart';

final formKey = GlobalKey<FormState>();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.clickSignup}) : super(key: key);
  final VoidCallback clickSignup;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final otpController = TextEditingController();
  FirebaseAuth phoneauth = FirebaseAuth.instance;
  var receivedID = '';
  var otpFieldVisibility = false;
  var mobileNumber = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouritesJob>(
      create: (BuildContext context) =>FavouritesJob(),
      builder: (context, child){
      return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.amber,
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            width:MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              //image: const DecorationImage(image: AssetImage('assets/images/welcomeImage.png')),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.greenAccent,
                  Colors.white,
                ],
              ),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),

            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Welcome To',
                        style: TextStyle(
                            fontFamily: 'Kanit Bold',
                            color: Colors.green,
                            fontSize: 30),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' FineJobs',
                            style: TextStyle(
                                fontFamily: 'Kanit Bold',
                                color: Colors.green,
                                fontSize: 30),
                          ),
                          // TextSpan(
                          //   text: ' \n      ',
                          //   style: TextStyle(
                          //       fontFamily: 'Satisfy',
                          //       color: Colors.black,
                          //       fontSize: 20),
                          // ),
                          TextSpan(
                            text: ' UK',
                            style: TextStyle(
                                fontFamily: 'Kanit Bold',
                                color: Colors.green,
                                fontSize: 30),
                          ),
                        ],
                      ),
                    ),
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
                            color: Colors.green,
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
                            color: Colors.green,
                            fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' the Cv-Library and Reed.co.uk ',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.green,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 36,
                      width: 290,
                      child: TextField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black),
                            ),
                            label: Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Enter email',
                                  style:
                                      TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                        obscureText: false,
                      ),
                    ),
                  ),


                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 36,
                      width: 290,
                      child: TextField(
                        controller: passwordController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black),
                            ),
                            label: Row(
                              children: [
                                Icon(
                                  Icons.lock_sharp,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Enter password',
                                  style:
                                      TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                        obscureText: true,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: const Padding(
                        padding: EdgeInsets.only(right: 7, bottom: 20),
                        child: Text(
                          'Forgot Password ?',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: Colors.lightBlueAccent),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const ForgotPasswordPage();
                        }));
                      },
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 290,
                    decoration: BoxDecoration(
                      // gradient: new LinearGradient(
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      //   colors: [
                      //     Colors.purpleAccent,
                      //     Colors.lightBlue,
                      //   ],
                      // ),

                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      color: Colors.blue,
                      border: Border.all(
                        color: Colors.greenAccent,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        signIn();
                      },
                      child: const Center(
                          child: Text(
                        'Continue with Email',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(height: 8),

                  const Text('Dont have account yet ?'),
                  const SizedBox(height: 8),
                  Container(
                    height: 36,
                    width: 290,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.purpleAccent,
                          Colors.lightBlue,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.blueGrey,
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 17, bottom: 7),
                      child: InkWell(
                        onTap: () {},
                        child: RichText(
                            text: TextSpan(
                                text: 'Sign up with email',
                                children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.clickSignup,
                                text: 'Click Here',
                                style: const TextStyle(
                                  fontFamily: 'Poppins Bold',
                                  fontSize: 20,
                                  color: Colors.redAccent,
                                ),
                              )
                            ])),
                      ),
                    ),
                  ),
                  // InkWell(
                  //   child: Text('Forgot Password'),
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) =>ForgotPasswordPage()));
                  //   },
                  // )
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
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.abc),
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
                                    child: const PhoneOTPVerification(),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
                          signInWithGoogle();
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
                  const SizedBox(
                    height: 8,
                  ),
                  // Container(
                  //   height: 36,
                  //   width: 290,
                  //   decoration: BoxDecoration(
                  //     borderRadius: const BorderRadius.only(
                  //         topLeft: Radius.circular(10),
                  //         topRight: Radius.circular(10),
                  //         bottomLeft: Radius.circular(10),
                  //         bottomRight: Radius.circular(10)),
                  //     color: Colors.white,
                  //     border: Border.all(
                  //       color: Colors.black,
                  //       width: 1,
                  //     ),
                  //   ),
                  //   child: InkWell(
                  //     onTap: () {
                  //       //signInWithFacebook();
                  //     },
                  //     child: const Padding(
                  //       padding: EdgeInsets.only(left: 8),
                  //       child: Row(
                  //         children: [
                  //           Image(
                  //               height: 25,
                  //               width: 25,
                  //               image:
                  //                   AssetImage("assets/images/facebook.jpg")),
                  //           SizedBox(
                  //             width: 35,
                  //           ),
                  //           Center(child: Text('Continue with facebook')),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  //PhoneLoginPage(),
                  const SizedBox(height: 20),
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
                          text: 'I agree to the fine jobs',
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
                ],
              ),
            ),
          ),
        ),
      );}
    );
  }

  Future signIn() async {
    final validvalue = formKey.currentState?.validate();
    //if (validvalue!) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const SizedBox(
            height: 5.0,
            width: 5.0,
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            ),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      print(e);
      //to create error message when user already exist or not
      Utils.showSnackBar(e.message);
    }
    // navigatorkey to hide showDialog
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

  // void phoneSignIn() {
  //   FirebaseAuth.instance.signInWithPhoneNumber(numberController.text, RecaptchaVerifier(container: 'recaptcha',
  //     size: RecaptchaVerifierSize.compact,
  //     theme: RecaptchaVerifierTheme.dark, auth: FirebaseAuthWeb.instance
  //   ));
  // }

  Future signInWithGoogle() async {
    // Trigger the authentication flow for android
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: const String.fromEnvironment('GOOGLE_CLIENT_ID'),
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

  Future<void> signOutFromGoogle() async {
    final GoogleSignIn googleUser = GoogleSignIn();
    await googleUser.signOut();
    await FirebaseAuth.instance.signOut();
  }

  void signOutGoogle() async {
    final GoogleSignIn googleUser = GoogleSignIn();
    await googleUser.signOut();
    await phoneauth.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', false);

    // uid = null;
    // name = null;
    // userEmail = null;
    // imageUrl = null;

    print("User signed out of Google account");
  }

}
