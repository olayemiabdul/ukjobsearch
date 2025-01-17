// import 'dart:io';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:ukjobsearch/authentication/forgotpassword.dart';
// import 'package:ukjobsearch/authentication/phonelogin.dart';
// import 'package:ukjobsearch/provider/favouriteProvider.dart';
// import 'package:ukjobsearch/refactored%20code/bottomNav.dart';
// import 'package:ukjobsearch/utils.dart';
//
// import '../Auth/forgotpassword.dart';
// import '../main.dart';
//
// final formKey = GlobalKey<FormState>();
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key, required this.clickSignup}) : super(key: key);
//   final VoidCallback clickSignup;
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   FirebaseAuth phoneauth = FirebaseAuth.instance;
//
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<FavouritesJob>(
//       create: (BuildContext context) => FavouritesJob(),
//       builder: (context, child) {
//         return SafeArea(
//           child: Scaffold(
//             body: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.greenAccent,
//                     Colors.white,
//                   ],
//                 ),
//               ),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         const SizedBox(height: 20),
//                         const Text(
//                           'Welcome To FineJobs UK',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'Kanit Bold',
//                             fontSize: 28,
//                             color: Colors.green,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         const Text(
//                           'Your one-stop destination for all your job search needs. Apply to 1M+ jobs across the UK in 1-tap.',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () {
//                             final provider = Provider.of<FavouritesJob>(context, listen: false);
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => ChangeNotifierProvider.value(
//                                   value: provider,
//                                   child: const myNewBar(),
//                                 ),
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             backgroundColor: Colors.green,
//                           ),
//                           child: const Text(
//                             'Continue Exploring Our Portal',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         const Text(
//                           'Login or Sign Up to Get Personalized Offers',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontFamily: 'Poppins Bold',
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildTextField(
//                           controller: emailController,
//                           hintText: 'Enter Email',
//                           icon: Icons.email,
//                           obscureText: false,
//                         ),
//                         const SizedBox(height: 10),
//                         _buildTextField(
//                           controller: passwordController,
//                           hintText: 'Enter Password',
//                           icon: Icons.lock,
//                           obscureText: true,
//                         ),
//                         const SizedBox(height: 10),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => const ForgotPasswordPage(),
//                                 ),
//                               );
//                             },
//                             child: const Text(
//                               'Forgot Password?',
//                               style: TextStyle(
//                                 color: Colors.lightBlueAccent,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () => signIn(),
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                             backgroundColor: Colors.blue,
//                           ),
//                           child: const Text(
//                             'Continue with Email',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         TextButton(
//                           onPressed: widget.clickSignup,
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.redAccent,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         _buildSocialLoginButton(
//                           onTap: () {
//                             if (!kIsWeb && Platform.isAndroid) {
//                               signInWithGoogle();
//                             } else if (kIsWeb) {
//                               signInWithGoogleWeb();
//                             }
//                           },
//                           label: 'Continue with Google',
//                           assetPath: 'assets/images/google.png',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     required IconData icon,
//     required bool obscureText,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.black54),
//         hintText: hintText,
//         filled: true,
//         fillColor: Colors.grey[200],
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(30),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSocialLoginButton({
//     required VoidCallback onTap,
//     required String label,
//     required String assetPath,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 10),
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(30),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Image.asset(assetPath, height: 24, width: 24),
//             const SizedBox(width: 10),
//             Text(
//               label,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future signIn() async {
//     final validvalue = formKey.currentState?.validate();
//     //if (validvalue!) return;
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (context) {
//           return const SizedBox(
//             height: 5.0,
//             width: 5.0,
//             child: SizedBox(
//               height: 50,
//               width: 50,
//               child: CircularProgressIndicator(
//                 color: Colors.green,
//               ),
//             ),
//           );
//         });
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text, password: passwordController.text);
//     } on FirebaseAuthException catch (e) {
//       print(e);
//       //to create error message when user already exist or not
//       Utils.showSnackBar(e.message);
//     }
//     // navigatorkey to hide showDialog
//     navigatorkey.currentState!.popUntil((route) => route.isFirst);
//   }
//
//   Future signInWithGoogle() async {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//     if (googleUser != null) {
//       final GoogleSignInAuthentication googleAuth =
//       await googleUser.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//       await FirebaseAuth.instance.signInWithCredential(credential);
//     }
//   }
//
//   Future<User?> signInWithGoogleWeb() async {
//     final GoogleAuthProvider authProvider = GoogleAuthProvider();
//     try {
//       final UserCredential userCredential =
//       await FirebaseAuth.instance.signInWithPopup(authProvider);
//       return userCredential.user;
//     } catch (e) {
//       return null;
//     }
//   }
// }
