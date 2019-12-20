import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hyperloop/data_models/place.dart';
import 'package:hyperloop/pages/place_picker.dart';
import 'package:hyperloop/services/map_route_util.dart';
import 'package:hyperloop/utils/drawer.dart';
import 'package:hyperloop/utils/map.dart';

const double minHeight = 180;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String title = 'Hyperloop';

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AnimationController _controller;

  double get maxHeight => MediaQuery.of(context).size.height - 520;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
  }

  double lerp(double min, double max) =>
      lerpDouble(min, max, _controller.value);

  Place fromAddress;
  Place toAddress;
  List<Marker> markers = [];
  List<Polyline> routes = [];
  MapUtil mapUtil = MapUtil();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        bottomSheet: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Container(
                  width: double.infinity,
                  height: lerp(minHeight, maxHeight),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Plan your today's trip",
                              style: TextStyle().copyWith(
                                  letterSpacing: 1.9,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                            fromAddress == null
                                                ? ""
                                                : fromAddress.name,
                                            (place, isFrom) {
                                          fromAddress = place;
                                          _plotMarker(place, isFrom);
                                          setState(() {});
                                        }, true)));
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40.0,
                                      width: 50.0,
                                      child: Center(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 2),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.orange)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      width: 40,
                                      height: 50,
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 40.0, right: 50.0),
                                      child: Text(
                                        fromAddress == null
                                            ? "Source Bus Stop"
                                            : fromAddress.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.white70,
                          ),
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                            toAddress == null
                                                ? ''
                                                : toAddress.name,
                                            (place, isFrom) {
                                          toAddress = place;
                                          _plotMarker(place, isFrom);
                                          setState(() {});
                                        }, false)));
                              },
                              child: SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: Stack(
                                  alignment: AlignmentDirectional.centerStart,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40.0,
                                      width: 50.0,
                                      child: Center(
                                        child: Container(
                                            margin: EdgeInsets.only(top: 2),
                                            width: 10,
                                            height: 10,
                                            decoration: BoxDecoration(
                                                color: Colors.greenAccent)),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      width: 40,
                                      height: 50,
                                      child: Center(
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 40.0, right: 50.0),
                                      child: Text(
                                        toAddress == null
                                            ? "Destination Bus Stop"
                                            : toAddress.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white70),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          _controller.status == AnimationStatus.completed
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: _builtSubmitButton(),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        appBar: AppBar(
          title: Text(this.title),
        ),
        drawer: HyperloopDrawer(onTabSelect: (selectedTab) {
          setState(() {
            this.title = selectedTab;
          });
        }),
        body: Stack(children: <Widget>[HyperLoopMap(markers, routes)]));
  }

  void _plotMarker(Place place, bool isFrom) {
    String mkId = isFrom == true ? "FromAddress" : "toAddress";

    markers.remove(mkId);

    //_mapController.clearMarkers();

    Marker marker = Marker(
      markerId: MarkerId(mkId),
      draggable: false,
      position: LatLng(place.lat, place.lng),
      infoWindow: InfoWindow(title: mkId),
      icon: (mkId == "FromAddress")
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    setState(() {
      if (mkId == "FromAddress") {
        if (markers.isEmpty) {
          markers.add(marker);
        } else
          markers[0] = (marker);
      } else if (mkId == "toAddress") {
        markers.add(marker);
      }
    });

    addPolyline();
  }

  addPolyline() async {
    //routes.clear();
    if (markers.length > 1) {
      mapUtil
          .getRoutePath(
              LatLng(
                  markers[0].position.latitude, markers[0].position.longitude),
              LatLng(
                  markers[1].position.latitude, markers[1].position.longitude))
          .then((locations) {
        List<LatLng> path = new List();

        locations.forEach((location) {
          path.add(new LatLng(location.latitude, location.longitude));
        });

        final Polyline polyline = Polyline(
          polylineId: PolylineId(markers[1].position.latitude.toString() +
              markers[1].position.longitude.toString()),
          consumeTapEvents: true,
          color: Colors.grey,
          width: 4,
          points: path,
        );

        setState(() {
          routes.add(polyline);
        });
      });

      LatLngBounds bound = LatLngBounds(
          southwest: LatLng(
              markers[0].position.latitude, markers[0].position.longitude),
          northeast: LatLng(
              markers[1].position.latitude, markers[1].position.longitude));
      CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);

      // TODO to move the camera towards Bounds
    }
  }

//  void latLongBoundFunction(){
//    this.mapController.animateCamera(u2).then((void v){
//      check(u2,this.mapController);
//    });
//  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller.value -= details.primaryDelta / maxHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / maxHeight;

    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }

  Widget _builtSubmitButton() {
    return SubmitButton(
      isVisible: _controller.status == AnimationStatus.completed,
      fromAddress: fromAddress,
      toAddress: toAddress,
    );
  }
}

class SubmitButton extends StatelessWidget {
  final bool isVisible;

  final Place fromAddress;
  final Place toAddress;

  SubmitButton({Key key, this.isVisible, this.fromAddress, this.toAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      child: RawMaterialButton(
        onPressed: () {
          if (fromAddress == null || toAddress == null) {
            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(milliseconds: 500), () {
                    Navigator.of(context).pop(true);
                  });
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Container(child: Text('Kindly Select Stops first!')),
                  );
                });
          } else {

              Navigator.pushNamed(context, '/busesShow');
          }
        },
        splashColor: Colors.white,
        fillColor: Colors.orange,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 20),
              child: Text("Search for Buses"),
            ))),
      ),
    );
  }
}
