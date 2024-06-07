
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/screen/bottomNav.dart';
import 'package:ukjobsearch/screen/welcomePage.dart';

import 'authScreen.dart';

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
  bool visible = false;
  var temp;

  void verifyUserPhoneNumber() {
    phoneauth.verifyPhoneNumber(
      phoneNumber: mobileNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await phoneauth.signInWithCredential(credential).then(
        //       (value) => print('success'),
        //     );
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) async {
        receivedID = verificationId;
        otpFieldVisibility = true;
        
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );


  }

  Future verifyOTPCode() async {
    final provider =
    Provider.of<FavouritesJob>(context, );
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
            child: const myNewBar(),
            //myNewBar(),
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
    navigatorkey.currentState!.popUntil((route) => route.isFirst);
  }

sendOtpWeb(String mobileNumberWeb)async {
  //FirebaseAuth auth = FirebaseAuth.instance;
mobileNumber=mobileNumberWeb;
// Wait for the user to complete the reCAPTCHA & for an SMS code to be sent.
  ConfirmationResult confirmationResult = await phoneauth.signInWithPhoneNumber(mobileNumber);
  print("OTP Sent to $mobileNumber");
  return confirmationResult;

}
webAuthentication(confirmationResult, String otp)async{
  UserCredential userCredential = await confirmationResult.confirm(otp);

  userCredential.additionalUserInfo!.isNewUser
      ? Navigator.push(context, MaterialPageRoute(builder:(context)=>myNewBar()))
      : Navigator.push(context, MaterialPageRoute(builder:(context)=>WelcomeHomeScreen ()));
  //xuserCredential.additionalUserInfo
}



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouritesJob>(
      create: (BuildContext context) => FavouritesJob(),
      builder: (context, child){
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
                  //sendOtpWeb(mobileNumber);
                } else {


                    verifyUserPhoneNumber();
                  //webAuthentication(phoneauth.currentUser, otpController.text);

                }
              },
              child: Text(otpFieldVisibility ? 'Login' : 'Verify'),
            ),
            const SizedBox(height: 12,),

          ],
        ),
      ),);
      }
    );
  }
}




class PhoneOTPVerification extends StatefulWidget {
  const PhoneOTPVerification({Key? key}) : super(key: key);

  @override
  State<PhoneOTPVerification> createState() => _PhoneOTPVerificationState();
}

class _PhoneOTPVerificationState extends State<PhoneOTPVerification> {
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  FirebaseAuth phoneauth = FirebaseAuth.instance;
  bool visible = false;
  String phonenumber='';
  var temp;

  // @override
  // void dispose() {
  //   phoneNumber.dispose();
  //   otp.dispose();
  //   super.dispose();
  // }
  sendOTP(String phoneNumber) async {
    phoneNumber = phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;
    ConfirmationResult result = await auth.signInWithPhoneNumber(
      '+44$phoneNumber',
    );
    print("OTP Sent to +44 $phoneNumber");
    return result;
  }
  authenticate(ConfirmationResult confirmationResult, String otp) async {

    UserCredential userCredential = await confirmationResult.confirm(otp);
    // Navigator.push(context, MaterialPageRoute(builder:(context)=>myNewBar()));

    userCredential.additionalUserInfo!.isNewUser
        ? Navigator.push(context, MaterialPageRoute(builder:(context)=>myNewBar()))
        : Navigator.push(context, MaterialPageRoute(builder:(context)=>WelcomeHomeScreen()));;
  }
  Widget SubmitOTPButton(String text) => ElevatedButton(
    onPressed: () =>authenticate(temp, otp.text),
    child: Text(text),
  );
  Widget SendOTPButton(String text) => ElevatedButton(
    onPressed: () async {
      setState(() {visible = !visible;});
      sendOTP(phoneNumber.text);
    },
    child: Text(text),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Phone OTP Authentication"),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputTextField("Contact Number", phoneNumber, context),
            visible ? inputTextField("OTP", otp, context) : const SizedBox(),
            !visible ? SendOTPButton("Send OTP") : SubmitOTPButton("Submit"),
          ],
        ),
      ),
    );
  }





  Widget inputTextField(String labelText, TextEditingController textEditingController, BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(10.00),
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.5,
          child: TextFormField(
            obscureText: labelText == "OTP" ? true : false,
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: labelText,
              hintStyle: const TextStyle(color: Colors.blue),
              filled: true,
              fillColor: Colors.blue[100],
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
            ),
          ),
        ),
      );
}

