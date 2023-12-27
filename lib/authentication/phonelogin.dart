import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/screen/bottomNav.dart';
import 'package:ukjobsearch/screen/welcomePage.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final otpController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final lastNameController = TextEditingController();
  FirebaseAuth phoneauth = FirebaseAuth.instance;
  var receivedID = '';
  var otpFieldVisibility = false;
  var mobileNumber = '';

  void verifyUserPhoneNumber() {
    phoneauth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await phoneauth.signInWithCredential(credential).then(
              (value) => print('success'),
            );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        receivedID = verificationId;
        otpFieldVisibility = true;
        // Create a PhoneAuthCredential with the code
        // PhoneAuthCredential credential = PhoneAuthProvider.credential(
        //     verificationId: verificationId, smsCode: smsCode);

        //Sign the user in (or link) with the credential
        //await phoneauth.signInWithCredential(credential);
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );

    // verificationCompleted(PhoneAuthCredential credential) async {
    //   await phoneauth.signInWithCredential(credential).then(
    //         (value) => print('success'),
    //       );
    // }

    // verificationFailed(FirebaseAuthException e) {
    //   print(e.message);
    // }

    // codeSent(String verificationId, int? resendToken) {
    //   receivedID = verificationId;
    //   otpFieldVisibility = true;
    //   setState(() {});
    // }
    // codeSent(String verificationId, int? resendToken) async {
    //   // Update the UI - wait for the user to enter the SMS code
    //   String smsCode = 'xxxx';
    //   receivedID = verificationId;
    //   otpFieldVisibility = true;
    //   // Create a PhoneAuthCredential with the code
    //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
    //       verificationId: verificationId, smsCode: smsCode);

    //   // Sign the user in (or link) with the credential
    //   await phoneauth.signInWithCredential(credential);
    // }

    // codeAutoRetrievalTimeout(String verificationId) {
    //   print('TimeOut');
    //   verificationId;
    // }
  }

  Future verifyOTPCode() async {
    final provider =
    Provider.of<FavouritesJob>(context, listen: false);
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: receivedID,
      smsCode: otpController.text,
    );
    try {
      final userDetails = await phoneauth
          .signInWithCredential(credential)
          .then((value) =>     Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: provider,
            child: const WelcomeHomeScreen(),
          ),
        ),
      ),);
      await userDetails.user.updateDisplayName(lastNameController.text);
      // await userDetails.user?.updateDisplayName(lastNameController.text);
      await FirebaseAuth.instance.currentUser
          ?.updateDisplayName(lastNameController.text);
      //await userDetails.user.displayName(lastNameController);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  // void phoneSignIn() {
  //   FirebaseAuth.instance.signInWithPhoneNumber(
  //       mobileController.text,
  //       RecaptchaVerifier(
  //           container: 'recaptcha',
  //           size: RecaptchaVerifierSize.normal,
  //           theme: RecaptchaVerifierTheme.dark,
  //           auth: FirebaseAuthWeb.instance));
  // }

//Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
  // Future mobilePhoneAuth() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(
  //       '',
  //       RecaptchaVerifier(
  //         container: 'recaptcha',
  //         size: RecaptchaVerifierSize.compact,
  //         theme: RecaptchaVerifierTheme.dark,
  //         auth: FirebaseAuthWeb.instance,
  //         onSuccess: () => print('reCAPTCHA Completed!'),
  //         onError: (FirebaseAuthException error) => print(error),
  //         onExpired: () => print('reCAPTCHA Expired!'),
  //       ));
  //   await confirmationResult.confirm('123456');
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          IntlPhoneField(
            controller: mobileController,
            initialCountryCode: 'GB',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Mobile Number',
              labelText: 'Phone',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onChanged: (uservalue) {
              mobileNumber = uservalue.completeNumber;
            },
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: lastNameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'enter your name ',
            ),
            obscureText: false,
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'enter your email',
            ),
            obscureText: false,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Visibility(
              visible: otpFieldVisibility,
              child: TextField(
                controller: otpController,
                decoration: const InputDecoration(
                  hintText: 'OTP Code',
                  labelText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (otpFieldVisibility) {
                verifyOTPCode();
              } else {
                verifyUserPhoneNumber();
              }
            },
            child: Text(otpFieldVisibility ? 'Login' : 'Verify'),
          ),
          const SizedBox(height: 12,),

        ],
      ),
    ));
  }
}
