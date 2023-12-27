import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukjobsearch/screen/bottomNav.dart';
import 'package:ukjobsearch/utils.dart';

class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer = Timer(const Duration(seconds: 2), () {});
  @override
  void initState() {
    // To create user from currentUser
    super.initState();
    // to send email verification
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();
      //depend on sendEmailVerification() from firebaseAuth
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkedIfEmailVerified();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  Future checkedIfEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    //after the email is veriffied the page should direct to homepage
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer!.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ?//Home()
       const myNewBar ()
      : Scaffold(
          appBar: AppBar(
            title: const Text('Verify Email'),
          ),
          body: SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Center(
                    child: Text(
                  'Verification email has been sent',
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                )),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    canResendEmail ? sendVerificationEmail : null;
                    //to control how many times user can resend email
                  },
                  icon: const Icon(
                    Icons.email_outlined,
                    size: 32,
                  ),
                  label: const Text(
                    'Resend Email',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    //to cancel email verification with cancel
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    size: 32,
                  ),
                  label: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
        );
}
