import 'package:flutter/material.dart';
import 'package:hyperloop/drawer.dart';
import 'package:hyperloop/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyperloop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        drawer: HyperloopDrawer(onTabSelect: (selectedTab) {
          setState(() {
            this.title = selectedTab;
          });
        }),
        body: Stack(children: <Widget>[HyperLoopMap()]));
  }
}
