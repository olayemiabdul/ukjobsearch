import 'package:flutter/material.dart';

final messengerkey = GlobalKey<ScaffoldMessengerState>();
//this need to be ref in mainpage material page

class Utils {
  static showSnackBar(String? text) {
    if (text == null) return;
   
    final snackBar = SnackBar(content: Text(text, style: const TextStyle(color: Colors.red),),backgroundColor: Colors.white, );
    messengerkey.currentState?..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
