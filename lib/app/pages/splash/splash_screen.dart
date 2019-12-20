import 'package:flutter/material.dart';
import 'package:hyperloop/app/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 32.0,
                ),
                Image.asset(
                  Resources.background,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 32.0,
                ),
                Image.asset(
                  Resources.logo,
                  height: 150,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Text(
                    'Welcomes You',
                    style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
