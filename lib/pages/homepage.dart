import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Plan you today's trip",
                            style: TextStyle().copyWith(
                                letterSpacing: 1.9,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed: () {
//                            Navigator.of(context).push(MaterialPageRoute(
//                                builder: (context) => RidePickerPage(
//                                    fromAddress == null ? "" : fromAddress.name,
//                                        (place, isFrom) {
//                                      widget.onSelected(place, isFrom);
//                                      fromAddress = place;
//                                      setState(() {});
//                                    }, true)));
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
                                      "Source Bus Stop",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white70),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: FlatButton(
                            onPressed: () {
//                            Navigator.of(context).push(MaterialPageRoute(
//                                builder: (context) =>
//                                    RidePickerPage(toAddress == null ? '' : toAddress.name,
//                                            (place, isFrom) {
//                                          widget.onSelected(place, isFrom);
//                                          toAddress = place;
//                                          setState(() {});
//                                        }, false)));
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
                                      "Destination Bus Stop",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white70),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        _controller.status == AnimationStatus.completed
                            ? Padding(
                              padding: const EdgeInsets.only(top:15.0),
                              child: _builtSubmitButton(),
                            )
                            : Container(),
                      ],
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
        body: Stack(children: <Widget>[HyperLoopMap()]));
  }

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
    );
  }
}

class SubmitButton extends StatelessWidget {
  final bool isVisible;

  const SubmitButton({Key key, this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: Duration(milliseconds: 1000),
      child: RawMaterialButton(
        onPressed: () => {},
        splashColor: Colors.white,
        fillColor: Colors.orange,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Text("Search for Buses"),
            ))),
      ),
    );
  }
}
