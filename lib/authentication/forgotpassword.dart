import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8,top: 8,left: 80,right: 80),
                  child: TextFormField(


                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(

                        hintText: "Please Enter Your Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(

                            color: Color(0xFF000000),
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        fillColor: Colors.purple.withOpacity(0.2),
                        filled: true,
                        prefixIcon: const Icon(Icons.mail, color: Colors.purple,)),
                    obscureText: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && EmailValidator.validate(email)
                            ? 'Enter your valid Email pls'
                            : null,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email can not be empty'),
                        ),
                      );
                    }
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
          return const SpinKitDoubleBounce(

            color: Colors.green,
            size: 60,
            duration: Duration(seconds: 70),



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
