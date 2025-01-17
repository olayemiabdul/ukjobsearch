// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:ukjobsearch/main.dart';
// import 'package:ukjobsearch/utils.dart';
//
// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key, required this.clickSignin}) : super(key: key);
//   final VoidCallback clickSignin;
//
//   @override
//   State<SignUpPage> createState() => _SignUpPageState();
// }
//
// class _SignUpPageState extends State<SignUpPage> {
//   final formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final nameController = TextEditingController();
//   final lastnameController = TextEditingController();
//   final numberController = TextEditingController();
//   final passwordController = TextEditingController();
//   final imageController = TextEditingController();
//   bool isChecked = false;
//   bool selected = false;
//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.green,
//
//       ),
//       body: SafeArea(
//         child: SizedBox(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           child: ListView(
//             children: [
//               Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   SelectableButton(
//                     selected: selected,
//                     style: ButtonStyle(
//                       foregroundColor: WidgetStateProperty.resolveWith<Color?>(
//                             (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.disabled)) {
//                             return Colors.white;
//                           }
//                           return null; // defer to the defaults
//                         },
//                       ),
//                       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//                             (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.selected)) {
//                             return Colors.indigo;
//                           }
//                           return null; // defer to the defaults
//                         },
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         selected = !selected;
//                       });
//                     },
//                     child: const Text('Register'),
//                   ),
//                   const SizedBox(width: 10,),
//                   SelectableButton(
//                     selected: selected,
//                     style: ButtonStyle(
//                       foregroundColor: WidgetStateProperty.resolveWith<Color?>(
//                             (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.selected)) {
//                             return Colors.white;
//                           }
//                           return null; // defer to the defaults
//                         },
//                       ),
//                       backgroundColor: WidgetStateProperty.resolveWith<Color?>(
//                             (Set<WidgetState> states) {
//                           if (states.contains(WidgetState.selected)) {
//                             return Colors.pink;
//                           }
//                           return null; // defer to the defaults
//                         },
//                       ),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         selected = !selected;
//                       });
//                     },
//                     child: const Text('Sign In'),
//                   ),],
//               ),
//               Form(
//                 // form and textformfield is used to validate
//                 key: formKey,
//                 child: Column(children: [
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'First name',
//                       style: TextStyle(
//                         fontFamily: 'Poppins ExtraBold',
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   Card(
//                     color: Colors.white,
//                     elevation: 0,
//                     //shadowColor: Colors.black,
//                     shape: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     child: TextFormField(
//                       controller: nameController,
//                       cursorColor: Colors.white,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                           //labelText: 'enter your Displayname',
//                           ),
//                       obscureText: false,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       'Last name',
//                       style: TextStyle(
//                         fontFamily: 'Poppins ExtraBold',
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Card(
//                     color: Colors.white,
//                     elevation: 0,
//                     //shadowColor: Colors.black,
//                     shape: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//
//                     child: TextFormField(
//                       controller: lastnameController,
//                       cursorColor: Colors.white,
//                       keyboardType: TextInputType.text,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                           //labelText: 'enter your Phonenumber',
//                           ),
//                       obscureText: false,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       'Email-address',
//                       style: TextStyle(
//                         fontFamily: 'Poppins ExtraBold',
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Card(
//                     color: Colors.white,
//                     elevation: 0,
//                     //shadowColor: Colors.black,
//                     shape: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     child: TextFormField(
//                       controller: emailController,
//                       cursorColor: Colors.white,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                           //labelText: 'enter your email',
//                           ),
//                       obscureText: false,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (email) =>
//                           email != null && !EmailValidator.validate(email)
//                               ? 'Enter your Email pls'
//                               : null,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   const Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Text(
//                       'Enter your password',
//                       style: TextStyle(
//                         fontFamily: 'Poppins ExtraBold',
//                         fontSize: 20,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   Card(
//                     color: Colors.white,
//                     elevation: 0,
//                     //shadowColor: Colors.black,
//                     shape: Border.all(
//                       color: Colors.black,
//                       width: 1,
//                     ),
//                     child: TextFormField(
//                       controller: passwordController,
//                       cursorColor: Colors.white,
//                       textInputAction: TextInputAction.next,
//                       decoration: const InputDecoration(
//                           //labelText: 'enter your password',
//                           ),
//                       obscureText: true,
//                       autovalidateMode: AutovalidateMode.onUserInteraction,
//                       validator: (passwordvalue) =>
//                           passwordvalue != null && passwordvalue.length < 6
//                               ? 'Enter atleast 6 characters'
//                               : null,
//                     ),
//                   ),
//                   Checkbox(
//                       value: isChecked,
//                       checkColor: Colors.white,
//                       onChanged: (bool? value) async {
//                         setState(() {
//                           value = isChecked;
//                         });
//                       }),
//                   const Text('Show Password'),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       signUp();
//                     },
//                     icon: const Icon(Icons.lock_open),
//                     label: const Text('SignUp'),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {},
//                     child: RichText(
//                         text: TextSpan(
//                             text: 'You already have an account ?',
//                             children: [
//                           TextSpan(
//                             recognizer: TapGestureRecognizer()
//                               ..onTap = widget.clickSignin,
//                             text: 'Login',
//                           )
//                         ])),
//                   )
//                 ]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future signUp() async {
//     // to implement the signup validation
//     final validation = formKey.currentState!.validate();
//     if (!validation) return;
//     showDialog(
//         context: context,
//         barrierDismissible: false,
//         useSafeArea: true,
//         builder: (context) {
//           return const SizedBox(
//             height: 2.0,
//             width: 2.0,
//             child: CircularProgressIndicator(
//               color: Colors.amber,
//               strokeWidth: 1,
//               value: 1.0,
//             ),
//           );
//         });
//     try {
//       final userDetails =
//           await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailController.text,
//         password: passwordController.text,
//       );
//       //to display user input name, photo, number
//       await userDetails.user?.updateDisplayName(nameController.text);
//       await userDetails.user?.updateDisplayName(lastnameController.text);
//       userDetails.user!.displayName;
//       // await userDetails.user
//       //     ?.updatePhoneNumber(numberController.text as PhoneAuthCredential);
//       await userDetails.user?.updatePhotoURL(imageController.text);
//
//       //     .then((value) {
//       //   final user = FirebaseAuth.instance.currentUser!;
//       //   return user.updateDisplayName(user.displayName);
//       // });
//     } on FirebaseAuthException catch (e) {
//       print(e);
//       //to create error message when user already exist or not
//       Utils.showSnackBar(e.message);
//     }
//     // navigatorkey to hide showDialog
//     navigatorkey.currentState!.popUntil((route) => route.isFirst);
//   }
// }
// class SelectableButton extends StatefulWidget {
//   const SelectableButton({
//     super.key,
//     required this.selected,
//     this.style,
//     required this.onPressed,
//     required this.child,
//   });
//
//   final bool selected;
//   final ButtonStyle? style;
//   final VoidCallback? onPressed;
//   final Widget child;
//
//   @override
//   State<SelectableButton> createState() => _SelectableButtonState();
// }
//
// class _SelectableButtonState extends State<SelectableButton> {
//  WidgetStatesController statesController=WidgetStatesController();
//
//   @override
//   void initState() {
//     super.initState();
//     statesController = WidgetStatesController(
//         <WidgetState>{if (widget.selected) WidgetState.selected});
//   }
//
//   @override
//   void didUpdateWidget(SelectableButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.selected != oldWidget.selected) {
//       statesController.update(WidgetState.selected, widget.selected);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       statesController: statesController,
//       style: widget.style,
//       onPressed: widget.onPressed,
//       child: widget.child,
//     );
//   }
// }