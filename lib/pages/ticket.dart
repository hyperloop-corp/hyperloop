import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyperloop/templates/travelTicket.dart';
import 'package:hyperloop/utils/drawer.dart';

class Ticket extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  String title = 'My Tickets';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      drawer: HyperloopDrawer(onTabSelect: (selectedTab) {}),
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
