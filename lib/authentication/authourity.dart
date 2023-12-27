import 'package:flutter/material.dart';
import 'package:ukjobsearch/authentication/longinscreen.dart';
import 'package:ukjobsearch/authentication/signupscreen.dart';

class myAuthPage extends StatefulWidget {
  const myAuthPage({super.key});

  @override
  State<myAuthPage> createState() => _myAuthPageState();
}

class _myAuthPageState extends State<myAuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return
    isLogin
        ? LoginPage(clickSignup: () { setState(() {
                isLogin = !isLogin;
              }); },
          
          )
        : SignUpPage(clickSignin: switchbetween,
          
          );
  }
 void switchbetween() {
  setState(() {
                isLogin = !isLogin;
              });
}
}


