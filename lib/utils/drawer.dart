import 'package:flutter/material.dart';
import 'package:hyperloop/ticket.dart';

class HyperloopDrawer extends StatelessWidget {
  final TabCallback onTabSelect;

  HyperloopDrawer({this.onTabSelect});

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
              onTabSelect('Nearby');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Starred stops'),
            onTap: () {
              onTabSelect('Starred stops');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_headline),
            title: Text('My Tickets'),
            onTap: () {
              onTabSelect('My Tickets');
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Ticket()));
            },
          ),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text('My reminders'),
            onTap: () {
              onTabSelect('My reminders');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.directions),
            title: Text('Plan a trip'),
            onTap: () {
              onTabSelect('Plan a trip');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pay my fare'),
            onTap: () {
              onTabSelect('Pay my fare');
              Navigator.pop(context);
            },
          ),
          Divider(
            thickness: 1.0,
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              onTabSelect('Settings');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Help'),
            onTap: () {
              onTabSelect('Help');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Send feedback'),
            onTap: () {
              onTabSelect('Send feedback');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

typedef TabCallback = void Function(String selectedTab);
