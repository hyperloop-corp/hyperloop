import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hyperloop/templates/travelTicket.dart';

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
            TravelTicket(
                from: 'PGI',
                to: 'PEC',
                distance: 1.00,
                fare: 5.00,
                ttl: 30.00,
                eta: 10.00,
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
