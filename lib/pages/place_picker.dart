import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hyperloop/BLOC_streams/streams.dart';
import 'package:hyperloop/data_models/place.dart';
import 'package:location/location.dart';

class PlacePicker extends StatefulWidget {
  final String selectedAddress;
  final Function(Place, bool) onSelected;
  final bool _isFromAddress;

  PlacePicker(this.selectedAddress, this.onSelected, this._isFromAddress);

  @override
  State<StatefulWidget> createState() {
    return _PlacePickerState();
  }
}

class _PlacePickerState extends State<PlacePicker> {
  var _addressController;
  var placeBloc = PlaceBloc();

  String hintText;

  _PlacePickerState();

  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(30.7673, 76.7870),
    zoom: 17.0,
  );



  @override
  void initState() {
    _addressController = TextEditingController(text: "");
    hintText = widget._isFromAddress == true
        ? "Search Source Stop"
        : "Search Destination Stop";
    super.initState();
    initPlatformState();
  }

  Location _locationService = new Location();
  bool _permission = false;
  bool _isFirstLaunch = true;
  String error;
  StreamSubscription<LocationData> _locationSubscription;
  CameraPosition _currentCameraPosition;
  LocationData _startLocation;
  LocationData _currentLocation;
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
              final GoogleMapController controller = await _controller.future;
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
  void dispose() {
    placeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: _cameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                    leading: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x88999999),
                              offset: Offset(0, 5),
                              blurRadius: 5.0)
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 50,
                            child: FlatButton(
                              onPressed: () {},
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
                                        child: Icon(Icons.search),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 42.0, top: 2),
                                          child: TextField(
                                            style: TextStyle(fontSize: 16),
                                            controller: _addressController,
                                            textInputAction:
                                                TextInputAction.search,
                                            onChanged: (str) {
                                              placeBloc.searchPlace(str);
                                            },
                                            decoration: InputDecoration.collapsed(
                                                hintText: hintText),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: StreamBuilder(
                        stream: placeBloc.placeStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data == "start") {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            List<Place> places = snapshot.data;
                            return Container(
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x88999999),
                                            offset: Offset(0, 5),
                                            blurRadius: 5.0)
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        places.elementAt(index).name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        places.elementAt(index).address,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        widget.onSelected(places.elementAt(index),
                                            widget._isFromAddress);
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) => Divider(
                                  height: 4,
                                  color: Colors.transparent,
                                ),
                                itemCount: places.length,
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
