import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/pages/homepage.dart';
import 'package:hyperloop/pages/nearby.dart';
import 'package:hyperloop/pages/payment.dart';
import 'package:hyperloop/pages/ticket.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class HyperloopDrawer extends StatefulWidget {
  final TabCallback onTabSelect;

  HyperloopDrawer({this.onTabSelect});

  @override
  _HyperloopDrawerState createState() => _HyperloopDrawerState();
}

class _HyperloopDrawerState extends State<HyperloopDrawer> {
  FirebaseUser user;
  FirebaseDatabase db = FirebaseDatabase();
  int money = 0;

  Future<void> logout() async {
    _asyncConfirmDialog(context).then((value) {
      print(value);
    });
  }

  void _getUser() async {
    await FirebaseAuth.instance.currentUser().then((user) {
      db
          .reference()
          .child('users')
          .child(user.uid)
          .once()
          .then((DataSnapshot snapshot) {
        money = snapshot.value == null ? 0 : snapshot.value["money"];
        this.user = user;
      });
    });
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Logout?'),
            content: const Text('You will be logged out of this device.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();

    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: backgroundColor),
            accountName: Text("Nirmaljot Singh"),
            accountEmail: Text("nsbhasincool@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white70,
              child: Text(
                "NS",
                style: TextStyle(color: backgroundColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 0, 0),
            child: Text(
              user == null ? "Loading.." : "Wallet: \₹ $money",
              style: TextStyle(color: overlayColor),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.place),
            title: Text('Nearby'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Nearby()));
            },
          ),
          ListTile(
            leading: Icon(Icons.account_balance_wallet),
            title: Text('My Wallet'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentWidget()));
            },
          ),
          ListTile(
            leading: Icon(Icons.view_headline),
            title: Text('My Tickets'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Ticket()));
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('My reminders'),
            onTap: () {
              widget.onTabSelect('My reminders');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions),
            title: Text('Plan a trip'),
            onTap: () {
              widget.onTabSelect('Plan a trip');
              Navigator.pop(context);
            },
          ),
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              widget.onTabSelect('Settings');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              final ConfirmAction value = await _asyncConfirmDialog(context);
              if (value == ConfirmAction.ACCEPT) {
                Navigator.pushReplacementNamed(context, '/');
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            title: Text('Help'),
            onTap: () {
              widget.onTabSelect('Help');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Send feedback'),
            onTap: () {
              widget.onTabSelect('Send feedback');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

typedef TabCallback = void Function(String selectedTab);
