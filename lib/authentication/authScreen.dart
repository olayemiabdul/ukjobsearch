
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';
import 'package:ukjobsearch/authentication/longinscreen.dart';
import 'package:ukjobsearch/authentication/register.dart';
import 'package:ukjobsearch/authentication/signupscreen.dart';
import 'package:ukjobsearch/screen/underConstruction.dart';


class ProfileAuth extends StatefulWidget {
  const ProfileAuth({super.key});

  @override
  State<ProfileAuth> createState() => _ProfileAuthState();
}

class _ProfileAuthState extends State<ProfileAuth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //appBar: newAppBar(context),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.greenAccent,
                  Colors.white,
                ],
              ),),


          child: ListView(
            children: [
              const SizedBox(
                height: 2,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Log In Or SignUp',
                  //textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: 'Poppins ExtraBold',
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height:800,
                  width: 600,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(35),
                        bottomRight: Radius.circular(35)),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1, left: 3),
                    child: Column(
                      children: [
                        // TextButton(onPressed:(){
                        //   Navigator.push(context,MaterialPageRoute(builder:(context)=>const UserDetailsPage()));
                        // }, child: Text('save')),

                        Expanded(
                          flex: 1,
                          child: Container(

                            height:6,

                            child: TabContainer(
                              childCurve: Curves.ease,

                              colors: const [
                                Colors.greenAccent,
                                Colors.greenAccent,
                              ],
                              radius: 10,
                              tabEdge: TabEdge.top,
                              tabCurve: Curves.easeInToLinear,
                              tabs: const [
                                Text('Sign In'),
                              Text(  'Register'),
                              ],

                              //color: Theme.of(context).colorScheme.secondary,
                              children:  [
                               const SignInPage(),
                                SignUpScreen(clickSignin: () { const SignInPage(); },),
                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//   AppBar newAppBar(BuildContext context) {
//     return AppBar(
//         //   bottm: const TabBar(tabs: [

//         //          Tab(
//         //           icon: Icon(Icons.book),
//         //           text: "Quran Text & Ayah Audio",
//         //         ),
//         //         Tab(
//         //           icon: Icon(Icons.alarm),
//         //           text: "Quran & Translation",
//         //         ),
//         //         Tab(
//         //           icon: Icon(Icons.alarm),
//         //           text: "Translation only",
//         //         ),
//         //         Tab(
//         //           icon: Icon(Icons.alarm),
//         //           text: "Page2 only",
//         //         ),
//         //         Tab(
//         //           icon: Icon(Icons.alarm),
//         //           text: "Page3 only",
//         //         ),
//         //       ],
//         //  ),
//         backgroundColor: Colors.white,
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 10),
//             child: Icon(
//               Icons.search_off_outlined,
//               color: Colors.black,
//             ),
//           )
//         ],
//         title: Row(
//           children: [
//             const Text(
//               'Abdullahi',
//               style: TextStyle(
//                 fontFamily: 'Poppins Bold',
//                 fontSize: 15,
//                 color: Colors.black,
//               ),
//             ),
//             const SizedBox(
//               width: 0.1,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 2),
//               child: Container(
//                 height: 30,
//                 width: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(5),
//                       topRight: Radius.circular(5),
//                       bottomLeft: Radius.circular(5),
//                       bottomRight: Radius.circular(5)),
//                   color: Colors.green,
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Colors.greenAccent,
//                   ),
//                   InkWell(
//                     onTap: () async {},
//                     child: const Text(
//                       'Set Your Location',
//                       style: TextStyle(
//                         fontFamily: 'Poppins Black',
//                         fontSize: 10,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ]),
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Container(
//               width: 20,
//               height: 30,
//               child: const Icon(
//                 Icons.person,
//                 size: 10,
//                 color: Colors.green,
//               ),
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.white,
//                 border: Border.all(
//                   color: Colors.black,
//                   width: 2,
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Center(
//               child: RichText(
//                 text: TextSpan(
//                   text: '',
//                   children: [
//                     TextSpan(
//                       text: ' SignUp',
//                       style: TextStyle(
//                         color: Colors.lightBlueAccent,
//                         fontSize: 14,
//                       ),
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return SignUpPage(
//                               clickSignin: () {},
//                             );
//                           }));
//                         },
//                     ),
//                     TextSpan(
//                         text: '/',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     TextSpan(
//                       text: ' SignIn',
//                       recognizer: TapGestureRecognizer()
//                         ..onTap = () {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return LoginPage(
//                               clickSignup: () {},
//                             );
//                           }));
//                         },
//                       style: TextStyle(
//                         color: Colors.lightBlueAccent,
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 5,
//             ),
//             const Icon(
//               Icons.shopping_cart,
//               color: Colors.black,
//             ),
//             // const SizedBox(
//             //   width: 2,
//             // ),
//             RichText(
//               text: const TextSpan(
//                   text: 'Basket',
//                   children: [TextSpan(text: ''), TextSpan(text: '(0)')]),
//             ),
//           ],
//         ),
//         leading: const Padding(
//           padding: EdgeInsets.only(left: 1),
//           child: Image(
//             height: 5,
//             width: 5,
//             image: AssetImage(
//               "assets/images/logo.png",
//             ),
//           ),
//         ));
//   }
//
}