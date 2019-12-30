import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/templates/travelTicket.dart';

class Ticket extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  final String title = 'My Tickets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/home");
            }),
      ),
      backgroundColor: backgroundColor,
      body: PageView(
          controller: controller,
          physics: BouncingScrollPhysics(),
          children: [
            TravelTicket(
                from: 'Phase 11',
                to: 'PGI',
                distance: 14.40,
                fare: 30.00,
                ttl: 30.00,
                eta: 75.00,
                route: '39-Down'),
            TravelTicket(
                from: 'ISBT-43',
                to: 'New OPD',
                distance: 10.00,
                fare: 25.00,
                ttl: 0.00,
                eta: 10.00,
                route: '39-Up'),
          ]),
    );
  }
}
