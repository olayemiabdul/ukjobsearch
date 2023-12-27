import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukjobsearch/main.dart';
import 'package:ukjobsearch/utils.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  'Receive an email to/reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                TextFormField(
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'Enter something';
                  //   }
                  //   return null;
                  // },
                  controller: emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'enter your email',
                  ),
                  obscureText: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && EmailValidator.validate(email)
                          ? 'Enter your valid Email pls'
                          : null,
                ),
                // TextFormField(
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Enter something';
                //     }
                //     return null;
                //   },
                // ),
                ElevatedButton.icon(
                  onPressed: () {
                    // if (formKey.currentState!.validate()) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Email can not be empty'),
                    //     ),
                    //   );
                    // }
                    resetPassowrd();
                  },
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future resetPassowrd() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const CircularProgressIndicator(
            color: Colors.amber,
            strokeWidth: 5,
            value: 3.0,
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('password reset has been sent to your email');
      // to hide loading indicator
      navigatorkey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
