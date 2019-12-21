import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/data_models/Route_Info.dart';

class BusesShowWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BusesShowWidgetState();
  }
}

final routeSamples = [
  RouteInfo(
      name: "39-D",
      distance: 6,
      from: "Mohali Ph-11",
      to: "PGI",
      fare: 30,
      ETA: 12),
];

class _BusesShowWidgetState extends State<BusesShowWidget> {
  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(RouteInfo route) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.directions_bus, color: Colors.white),
          ),
          title: Text(
            route.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Container(
                      // tag: 'hero',
                      child: LinearProgressIndicator(
                          backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                          value: 1.0,
                          valueColor: AlwaysStoppedAnimation(Colors.green)),
                    )),
                Expanded(
                  flex: 4,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(route.from + " - " + route.to,
                          style: TextStyle(color: Colors.white))),
                ),
              ]),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                            "Fare: Rs." +
                                route.fare.toString() +
                                " | " +
                                route.ETA.toString() +
                                " minutes away",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                  ),
                ],
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/tickets');
          },
        );

    Card makeCard(RouteInfo lesson) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(lesson),
          ),
        );

    final makeBody = Container(
      child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 3)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Fetching.."),
                    SizedBox(
                      height: 20,
                    ),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ],
                ),
              );

            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(routeSamples[index]);
              },
            );
          }),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Colors.blueGrey,
      title: Text("Available Routes"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
