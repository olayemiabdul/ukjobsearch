import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/authentication/forgotpassword.dart';

import 'package:ukjobsearch/authentication/phonelogin.dart';
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 27, top: 55),
            child: Container(
              height: 400,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      child: Text('Login Or SignUp'),
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 36,
                        width: 290,
                        child: TextField(
                          controller: emailController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              label: Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.grey.shade300,
                                  ),
                                  Text(
                                    'Enter email',
                                    style:
                                        TextStyle(color: Colors.grey.shade300),
                                  )
                                ],
                              )),
                          obscureText: false,
                        ),
                      ),
                    ),

                    // TextFormField(
                    //     controller: nameController,
                    //     cursorColor: Colors.white,
                    //     textInputAction: TextInputAction.next,
                    //     decoration: InputDecoration(
                    //       labelText: 'enter your Displayname',
                    //     ),
                    //     obscureText: false,
                    //   ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 36,
                        width: 290,
                        child: TextField(
                          controller: passwordController,
                          cursorColor: Colors.white,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              label: Row(
                                children: [
                                  Icon(
                                    Icons.lock_sharp,
                                    color: Colors.grey.shade300,
                                  ),
                                  Text(
                                    'Enter password',
                                    style:
                                        TextStyle(color: Colors.grey.shade300),
                                  )
                                ],
                              )),
                          obscureText: true,
                        ),
                      ),
                    ),
                    Align(
                      child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 7, bottom: 20),
                          child: const Text(
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
                            return ForgotPasswordPage();
                          }));
                        },
                      ),
                      alignment: Alignment.topRight,
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
                        child: Center(
                            child: Text(
                          'Continue ',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    SizedBox(height: 8),

                    Text('Dont have account yet ?'),
                    SizedBox(height: 8),
                    Container(
                      height: 36,
                      width: 290,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                                  style: TextStyle(
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
                    SizedBox(
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
                            Icon(Icons.abc),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              child: Center(
                                  child: Text('Continue with Phone number')),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return PhoneLoginPage();
                                }));
                                // phoneSignIn();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
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
                          signInWithGoogle();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
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
                    SizedBox(
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
                          //signInWithFacebook();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Row(
                            children: [
                              Image(
                                  height: 25,
                                  width: 25,
                                  image:
                                      AssetImage("assets/images/facebook.jpg")),
                              SizedBox(
                                width: 35,
                              ),
                              Center(child: Text('Continue with facebook')),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    //PhoneLoginPage(),
                    SizedBox(height: 20),
                    RichText(
                        text: TextSpan(
                            text: 'By Signing up,',
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'Poppins Bold',
                              fontSize: 10,
                            ),
                            children: [
                          TextSpan(
                            text: 'I agree to the olayemi fintech',
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
        ),
      ),
    );
  }

  Future signIn() async {
    final validvalue = formKey.currentState?.validate();
    //if (validvalue!) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            height: 5.0,
            width: 5.0,
            child: CircularProgressIndicator(
              color: Colors.amber,
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOutFromGoogle() async {
    final GoogleSignIn googleUser = await GoogleSignIn();
    await googleUser.signOut();
    await FirebaseAuth.instance.signOut();
  }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }
}
