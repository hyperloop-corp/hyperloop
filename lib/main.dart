import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/pages/mobile_input.dart';
import 'pages/homepage.dart';
import 'pages/landing.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hyperloop',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            body1: TextStyle(
                color: Colors.white, fontFamily: 'ProximaNova', fontSize: 20),
          )),
      initialRoute: '/',
      routes: {
        '/': (context) => Landing(),
        '/home': (context) => HomePage(),
        '/mobile_input': (context) => PhoneAuthGetPhone(),
      },
    ));
