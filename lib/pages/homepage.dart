import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyperloop/utils/drawer.dart';
import 'package:hyperloop/utils/map.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title = 'Hyperloop';

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