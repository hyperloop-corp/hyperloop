import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';

class PaymentWidget extends StatefulWidget {
  PaymentWidgetState createState() => PaymentWidgetState();
}

class PaymentWidgetState extends State<PaymentWidget> {
  FirebaseUser user;
  final _formKey = new GlobalKey<FormState>();
  String amount;
  FirebaseAuth auth;
  FirebaseDatabase db = FirebaseDatabase();

  void _getUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      this.user = user;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        FirebaseAuth.instance.currentUser().then((user) {
          db
              .reference()
              .child('users')
              .child(user.uid)
              .once()
              .then((DataSnapshot snapshot) {
            int oldValue = snapshot.value == null? 0: snapshot.value["money"];
            db
                .reference()
                .child('users')
                .child(user.uid)
                .child('money')
                .set(oldValue + int.parse(amount));
          });
        });

        setState(() {
          _formKey.currentState.reset();
        });

        var dial = AlertDialog(
          title: Text("Money Added"),
          content: Text(amount + " rupees has been added to your account"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );

        showDialog(context: context, child: dial);

      } catch (e) {
        print(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Wallet"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        backgroundColor: backgroundColor,
        body: ListView(
          children: [
            Container(
                height: 300,
                color: backgroundColor,
                child: Center(
                    child: CircleAvatar(
                      child: Image.asset("assets/images/wallet-icon-13.png"),
                      radius: 60,
                    ))),
            Container(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                  child: Text(
                    "Enter Amount",
                    style: TextStyle(fontSize: 18),
                  )),
            ),
            Container(
              child: new Form(
                key: _formKey,
                child: new ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child: new TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.white70,
                        autofocus: false,
                        style: new TextStyle(color: Colors.white),
                        decoration: new InputDecoration(
                            hintText: 'Minimum 10 Rupees',
                            hintStyle: TextStyle(color: Colors.white30),
                            icon: new Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                            )),
                        validator: (value) {
                          String returnVal =
                          value.isEmpty ? "Value can't be empty" : null;

                          if (returnVal != null) return returnVal;

                          int val = int.parse(value);

                          if (val < 10) {
                            returnVal = "Amount should be atleast 10";
                          } else
                            returnVal = null;

                          return returnVal;
                        },
                        onSaved: (value) => amount = value.trim(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                          child: SizedBox(
                            height: 40.0,
                            child: new RaisedButton(
                              elevation: 5.0,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)),
                              color: Colors.white60,
                              child: new Text("Add Money",
                                  style: new TextStyle(
                                      fontSize: 20.0, color: Colors.white)),
                              onPressed: validateAndSubmit,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
