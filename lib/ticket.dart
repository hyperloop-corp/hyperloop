import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ticket extends StatelessWidget {
  final controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView(
          controller: controller,
          physics: BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 60),
              child: FlutterTicketWidget(
                width: 10.0,
                height: 100.0,
                color: Colors.blueGrey,
                child: Center(
                  child: Center(child: Text("TICKET")),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 120, horizontal: 60),
              child: FlutterTicketWidget(
                width: 10.0,
                height: 100.0,
                color: Colors.blueGrey,
                child: Center(
                  child: Center(child: Text("TICKET")),
                ),
              ),
            ),
          ]),
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
            color: widget.color, borderRadius: BorderRadius.circular(20.0)),
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
