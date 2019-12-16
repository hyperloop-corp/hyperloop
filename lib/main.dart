import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MaterialApp(
  title: 'Hyperloop',
  theme: ThemeData(
    primarySwatch: Colors.blue,
  ),
  initialRoute: '/',
  routes: {
    '/': (context) => HomePage(),
  },
));


