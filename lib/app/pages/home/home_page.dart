import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hyperloop/app/bloc/location_bloc/bloc.dart';
import 'package:hyperloop/app/pages/home/home_drawer.dart';
import 'package:hyperloop/domain/entities/place.dart';
import 'package:hyperloop/injection_container.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Place fromAddress;
  Place toAddress;

  List<Marker> markers = [];
  List<Polyline> routes = [];

  AnimationController _controller;
  Completer<GoogleMapController> _controllerMap = Completer();

  static final CameraPosition _initialCamera = CameraPosition(
    target: LatLng(36.4848, 78.3488347),
    zoom: 4,
  );

  CameraPosition _currentCameraPosition;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocationBloc>()..add(InvokeLocationServices()),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: HomeDrawer(),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: Set<Marker>.of(markers),
              compassEnabled: false,
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
                                    Future.delayed(
                                        Duration(milliseconds: 500), () {
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
                          backgroundColor: Color.fromRGBO(64, 75, 96, .9),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
