import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/pages/mobile_input.dart';
import 'package:hyperloop/pages/phone_verify.dart';
import 'pages/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'pages/landing.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => Landing(),
    '/home': (context) => HomePage(),
    '/mobile_input': (context) => PhoneAuthGetPhone(),
    '/verify': (context) => PhoneAuthVerify()
  },
));

