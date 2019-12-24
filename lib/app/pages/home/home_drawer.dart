import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/authentication_event.dart';
import 'package:hyperloop/app/bloc/authentication_bloc/bloc.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class HomeDrawer extends StatefulWidget {
  final TabCallback onTabSelect;

  HomeDrawer({this.onTabSelect});

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  Future<void> logout() async {
    _asyncConfirmDialog(context).then((value) {
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
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
            accountName: Text("Nirmaljot Singh"),
            accountEmail: Text("nsbhasincool@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.white70,
              child: Text(
                "NS",
                style: TextStyle(color: Color.fromRGBO(58, 66, 86, 1.0)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Nearby'),
                  onTap: () {
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
                    Navigator.pop(context);
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
                    final ConfirmAction value =
                        await _asyncConfirmDialog(context);
                    if (value == ConfirmAction.ACCEPT) {
                      BlocProvider.of<AuthenticationBloc>(context)
                          .add(InvokeSignOut());
                      Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}

typedef TabCallback = void Function(String selectedTab);
