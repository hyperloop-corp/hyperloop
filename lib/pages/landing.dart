import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset('images/ctu.jpg'),
                  Text('Welcome to Hyperloop',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30.0,
                        letterSpacing: 2.0
                    ),)
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
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
