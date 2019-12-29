import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/data_models/place.dart';
import 'package:hyperloop/pages/stop_select.dart';
import 'package:hyperloop/services/map_route_util.dart';
import 'package:hyperloop/utils/drawer.dart';
import 'package:location/location.dart';

import 'buses_show.dart';

const double minHeight = 180;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String title = 'Hyperloop';

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation<double> _translateButton;
  Animation<double> _nameTranslation;

  Curve _curve = Curves.easeOut;
  bool isOpened = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this)
      ..addListener(() {
        setState(() {
          print(_nameTranslation.value);
        });
      });
    ;

    _translateButton = Tween<double>(
      begin: 0.0,
      end: -100.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    _nameTranslation = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0,
        0.75,
        curve: Curves.linear,
      ),
    ));
  }

  Place fromAddress;
  Place toAddress;
  List<Marker> markers = [];
  List<Polyline> routes = [];
  MapUtil mapUtil = MapUtil();
  AnimationController _controller;

  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = new Location();
  bool _permission = false;
  bool _isFirstLaunch = true;
  String error;

  Completer<GoogleMapController> _controllerMap = Completer();

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(36.4848, 78.3488347),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;

  initPlatformState() async {
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 10000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            _currentCameraPosition = CameraPosition(
                target: LatLng(result.latitude, result.longitude), zoom: 16);

            if (_isFirstLaunch) {
              final GoogleMapController controller =
                  await _controllerMap.future;
              controller.animateCamera(
                  CameraUpdate.newCameraPosition(_currentCameraPosition));
              _isFirstLaunch = false;
            }

            if (mounted) {
              setState(() {
                _currentLocation = result;
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          drawer: HyperloopDrawer(onTabSelect: (selectedTab) {
            setState(() {
              this.title = selectedTab;
            });
          }),
          body: Stack(children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: Set<Marker>.of(markers),
              polylines: Set<Polyline>.of(routes),
              initialCameraPosition: _initialCamera,
              onMapCreated: (GoogleMapController controller) {
                _controllerMap.complete(controller);
              },
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: FlatButton(
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: StopSelectWidget(onPlaceSelected),
                  )
                ],
              ),
            ),
            (fromAddress != null && toAddress != null)
                ? Transform(
                    transform: Matrix4.translationValues(
                      _translateButton.value,
                      0.0,
                      0.0,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            animate();
//                              Navigator.push(
//                                  context,
//                                  FadePageRoute(
//                                      builder: (context) => Ticket()));
                          },
                          label: Text(_nameTranslation.value >= 0.8
                              ? "Search for Buses"
                              : "Results"),
                          icon: Icon(Icons.youtube_searched_for),
                          backgroundColor: overlayColor,
                        ),
                      ),
                    ),
                  )
                : Container(),
            (fromAddress != null && toAddress != null )
                ? AnimatedOpacity(
                    duration: Duration(microseconds: 500),
                    opacity: _controller.value,
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 80, left: 15, right: 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(20)),
                              height: 400,
                              child: BusesShowWidget(),
                            ),
                            ClipPath(
                              clipper: TriangleClipper(),
                              child: Container(
                                decoration:
                                    BoxDecoration(color: backgroundColor),
                                height: 40,
                                width: 80,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          ])),
    );
  }

  animate() {
    print(_translateButton.value);
    if (!isOpened) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    isOpened = !isOpened;
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

  void addPolyline() async {
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

      this._controllerMap.future.then((controller) {
        {
          try {
            LatLngBounds bound = LatLngBounds(
                southwest: LatLng(markers[0].position.latitude,
                    markers[0].position.longitude),
                northeast: LatLng(markers[1].position.latitude,
                    markers[1].position.longitude));
            CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 100);
            controller.animateCamera(u2);
          } on Exception catch (e) {
            LatLngBounds bound = LatLngBounds(
                northeast: LatLng(markers[0].position.latitude,
                    markers[0].position.longitude),
                southwest: LatLng(markers[1].position.latitude,
                    markers[1].position.longitude));
            CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 100);
            controller.animateCamera(u2);
          }
        }
      });
    }
  }

  void onPlaceSelected(Place place, bool fromAddressBool) {
    var mkId = fromAddressBool ? "from_address" : "to_address";
    if (fromAddressBool)
      setState(() {
        fromAddress = place;
      });
    else
      setState(() {
        toAddress = place;
      });

    print(fromAddress);
    print(toAddress);

    _plotMarker(place, fromAddressBool);
    addPolyline();
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
