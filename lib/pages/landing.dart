import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'images/ctu.jpg',
                fit: BoxFit.cover,
              ),
              Image.asset(
                'images/logo.png',
                height: 150,
              ),
              SizedBox(height: 6,),
              Center(
                child: Text(
                  'Welcomes You',
                  style: TextStyle(
                      color: Colors.lightBlueAccent, fontSize: 18.0, fontWeight: FontWeight.bold,letterSpacing: 2.0),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/mobile_input');
        },
        child: Icon(
          Icons.navigate_next,
          size: 40,
        ),
      ),
    );
  }
}
