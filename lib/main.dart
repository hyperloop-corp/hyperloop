import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  String title = '';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: Drawer(
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
                  setState(() {
                    widget.title = 'Nearby';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.star),
                title: Text('Starred stops'),
                onTap: () {
                  widget.title = 'Starred stops';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.alarm),
                title: Text('My reminders'),
                onTap: () {
                  widget.title = 'My reminders';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.directions),
                title: Text('Plan a trip'),
                onTap: () {
                  widget.title = 'Plan a trip';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.payment),
                title: Text('Pay my fare'),
                onTap: () {
                  widget.title = 'Pay my fare';
                  Navigator.pop(context);
                },
              ),
              Divider(
                thickness: 1.0,
              ),
              ListTile(
                title: Text('Settings'),
                onTap: () {
                  widget.title = 'Settings';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Help'),
                onTap: () {
                  widget.title = 'Help';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Send feedback'),
                onTap: () {
                  widget.title = 'Send feedback';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.my_location),
                ),
              ),
            )
          ],
        ));
  }
}
