import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hyperloop/utils/qr_generator.dart';

class TravelTicket extends StatelessWidget {
  final String from, to, route;
  final double distance, fare, ttl, eta;

  TravelTicket(
      {this.from,
      this.to,
      this.route,
      this.distance,
      this.fare,
      this.ttl,
      this.eta});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 60),
      child: FlutterTicketWidget(
        width: 10.0,
        height: 100.0,
        color: Colors.grey[350],
        child: Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Flexible(
                  child: SingleChildScrollView(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'images/logo.png',
                              height: 100,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'From',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    from,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'To',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    to,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Distance in Km',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    distance.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 7.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Route',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    route,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Fare in Rs',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    fare.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'ETA in min',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    eta.toString(),
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Ticket Expiry in',
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                Flexible(
                                  child: Text(
                                    ttl > 0 ? '$ttl minutes' : 'Expired!',
                                    style: TextStyle(
                                        color: Colors.grey[900],
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        ttl > 0
                            ? RawMaterialButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      child: QrCodeGeneratorWidget());
                                },
                                splashColor: Colors.blue,
                                fillColor: Colors.blueAccent,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5),
                                  child: Text("Get QR Code"),
                                )),
                              )
                            : SizedBox.shrink(),
                      ]),
                    ],
              ),
                  ),
                )],
            ),
          ),
        ),
      ),
    );
  }
}

class FlutterTicketWidget extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;
  final Color color;

  FlutterTicketWidget({
    this.width,
    this.height,
    this.child,
    this.color,
  });

  @override
  _FlutterTicketWidgetState createState() => _FlutterTicketWidgetState();
}

class _FlutterTicketWidgetState extends State<FlutterTicketWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(),
      child: AnimatedContainer(
        duration: Duration(seconds: 3),
        width: widget.width,
        height: widget.height,
        child: widget.child,
        decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.grey[900], width: 3.0),
            borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
        Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 20.0));
    path.addOval(Rect.fromCircle(
        center: Offset(size.width, size.height / 2), radius: 20.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
