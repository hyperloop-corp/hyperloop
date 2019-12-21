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

const double minHeight = 180;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String title = 'Hyperloop';

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
//    _controller.repeat(reverse: true);
//    _controller.forward();
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
                ? SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.5, 0.0),
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: Curves.elasticIn,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            if (fromAddress == null || toAddress == null) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(Duration(milliseconds: 500),
                                        () {
                                      Navigator.of(context).pop(true);
                                    });
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0))),
                                      title: Container(
                                          child: Text(
                                              'Kindly Select Stops first!')),
                                    );
                                  });
                            } else {
                              Navigator.pushNamed(context, '/busesShow');
                            }
                          },
                          label: Text('Search for Buses'),
                          icon: Icon(Icons.youtube_searched_for),
                          backgroundColor: overlayColor,
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ])),
    );
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

      this._controllerMap.future.then((controller) {
        controller.animateCamera(u2);
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

//    _plotMarker(mkId, place);
//    addPolyline();
  }
}
