import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/pages/bus_timeline.dart';
import 'package:hyperloop/pages/buses_show.dart';
import 'package:hyperloop/pages/mobile_input.dart';
import 'package:hyperloop/pages/nearby.dart';
import 'package:hyperloop/pages/ticket.dart';

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
      initialRoute: '/bustimeline',
      routes: {
        '/': (context) => Landing(),
        '/home': (context) => HomePage(),
        '/mobile_input': (context) => PhoneAuthGetPhone(),
        '/tickets': (context) => Ticket(),
        '/nearby': (context) => Nearby(),
        '/busesShow': (context) => BusesShowWidget(),
        '/bustimeline' : (context) => BusTimeline(title: "Bus Timeline",),
      },
    ));
