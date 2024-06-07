import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukjobsearch/authentication/forgotpassword.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/utils.dart';

import 'authScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.clickSignin});
  final VoidCallback clickSignin;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();

  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 10,
          width: double.infinity,
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 60.0),
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        TextField(
                          controller: nameController,

                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.dark,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Fullname/Username",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFF000000),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              fillColor: Colors.purple.withOpacity(0.2),
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.purple,
                              )),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.dark,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFF000000),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              fillColor: Colors.purple.withOpacity(0.2),
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.mail,
                                color: Colors.purple,
                              )),
                          obscureText: false,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (email) =>
                              email != null && !EmailValidator.validate(email)
                                  ? 'Enter your Email pls'
                                  : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          textInputAction: TextInputAction.done,
                          keyboardAppearance: Brightness.dark,
                          keyboardType: TextInputType.emailAddress,
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Color(0xFF000000),
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              fillColor: Colors.purple.withOpacity(0.2),
                              filled: true,
                              prefixIcon: const Icon(
                                Icons.mail,
                                color: Colors.purple,
                              )),

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (passwordvalue) =>
                              passwordvalue != null && passwordvalue.length < 6
                                  ? 'Enter atleast 6 characters'
                                  : null,
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        child: ElevatedButton(
                          onPressed: () {
                            signUp();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.purple,
                          ),
                          child: const Text(
                            "Sign up",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),

                    const Center(child: Text("Or")),
                    const SizedBox(
                      height: 10,
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
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: RichText(
                            text: TextSpan(
                                text: 'You already have an account ?',
                                children: [
                              TextSpan(
                                style: const TextStyle(color: Colors.purple),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.clickSignin,
                                text: 'SignIn',
                              )
                            ])),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    // to implement the signup validation
    final validation = formKey.currentState!.validate();
    if (!validation) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: true,
        builder: (context) {
          return const SizedBox(
            height: 2.0,
            width: 2.0,
            child: SpinKitRing(color: Colors.green,
            size: 40,)
          );
        });
    try {
      final userDetails =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //to display user input name, photo, number
      await userDetails.user?.updateDisplayName(nameController.text);
      //await userDetails.user?.updateDisplayName(lastnameController.text);
      userDetails.user!.displayName;
      // await userDetails.user
      //     ?.updatePhoneNumber(numberController.text as PhoneAuthCredential);
      await userDetails.user?.updatePhotoURL(imageController.text);

      //     .then((value) {
      //   final user = FirebaseAuth.instance.currentUser!;
      //   return user.updateDisplayName(user.displayName);
      // });
    } on FirebaseAuthException catch (e) {
      print(e);
      //to create error message when user already exist or not
      Utils.showSnackBar(e.message);
    }
    // navigatorkey to hide showDialog
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

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
    //to return user to the first page
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();

  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();

  final imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.values.first,
            children: [
              header(context),
              inputField(context),
              forgotPassword(context),
              signup(context),
            ],
          ),
        ),
      ),
    );
  }

  header(context) {
    return const Column(
      children: [
        Text(
          "Welcome Back",
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins Bold'),
        ),
        Text(
          "Enter your credential to login",
          style: TextStyle(fontFamily: 'Poppins Bold'),
        ),
      ],
    );
  }

  inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          textInputAction: TextInputAction.done,
          keyboardAppearance: Brightness.dark,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
          obscureText: false,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Color(0xFF000000),
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
              fillColor: Colors.purple.withOpacity(0.2),
              filled: true,
              prefixIcon: const Icon(
                Icons.mail,
                color: Colors.purple,
              )),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          keyboardAppearance: Brightness.dark,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFF000000),
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            fillColor: Colors.purple.withOpacity(0.2),
            filled: true,
            prefixIcon: const Icon(Icons.security_update),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            signIn();
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.purple,
          ),
          child: const Text(
            "Login",
            style: TextStyle(
                fontSize: 18, fontFamily: 'Poppins Bold', color: Colors.white),
          ),
        )
      ],
    );
  }

  forgotPassword(context) {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.only(right: 7, bottom: 20),
        child: Text(
          'Forgot Password ?',
          style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 14,
              color: Colors.purple),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const ForgotPasswordPage();
        }));
      },
    );
  }

  signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileAuth(),
                ),
              );
            },
            child: const Text(
              "Register",
              style: TextStyle(color: Colors.purple),
            ))
      ],
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
              child: SpinKitRing(
                color: Colors.green,
                size: 60,
                duration: Duration(seconds: 60),
              ));
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
}
