import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {

  Future<void> navigateToNextScreen() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      String route;
      route = await _auth.currentUser().then((user){
        if(user != null){
          return 'home';
        }
        else{
          return 'mobile_input';
        }
      });
      assert(route != null);
      Navigator.pushReplacementNamed(context, '/$route');
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

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
        onPressed: () async {
          await navigateToNextScreen();
        },
        child: Icon(
          Icons.navigate_next,
          size: 40,
        ),
      ),
    );
  }
}
