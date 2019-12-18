import 'package:flutter/material.dart';
import 'package:hyperloop/pages/ticket.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class HyperloopDrawer extends StatefulWidget {
  final TabCallback onTabSelect;

  HyperloopDrawer({this.onTabSelect});

  @override
  _HyperloopDrawerState createState() => _HyperloopDrawerState();
}

class _HyperloopDrawerState extends State<HyperloopDrawer> {
  Future<void> logout() async {
    _asyncConfirmDialog(context).then((value){
      print(value);
    });
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false, // user must tap button for close dialog!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Logout?'),
            content: const Text(
                'You will be logged out of this device.'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.CANCEL);
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.ACCEPT);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text("Nirmaljot Singh"),
            accountEmail: Text("nsbhasincool@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text("NS"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.place),
            title: Text('Nearby'),
            onTap: () {
              widget.onTabSelect('Nearby');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Starred stops'),
            onTap: () {
              widget.onTabSelect('Starred stops');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_headline),
            title: Text('My Tickets'),
            onTap: () {
              widget.onTabSelect('My Tickets');
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
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pay my fare'),
            onTap: () {
              widget.onTabSelect('Pay my fare');
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
              if(value == ConfirmAction.ACCEPT){
                Navigator.pushReplacementNamed(context, '/');
              }
              else{
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
