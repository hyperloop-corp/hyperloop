import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/data_models/stop.dart';
import 'package:hyperloop/services/getStops.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class BusTimeline extends StatefulWidget {
  BusTimeline({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BusTimelineState createState() => _BusTimelineState();
}

class _BusTimelineState extends State<BusTimeline> {
  List<Stop> stops;

  @override
  void initState() {
    super.initState();
    getStops().then((stopsQuery) {
      if (!mounted) return;
      setState(() {
        stops = stopsQuery;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(widget.title),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: backgroundColor,
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Code: 123-A\nFrom: Mohali Railway Station\nTo: PGI",
                style: TextStyle().copyWith(fontSize: 16),
              ),
              stops == null
                  ? Center(
                      child: Text("Loading..."),
                    )
                  : Expanded(
                      child: timelineModel(TimelinePosition.Center),
                    )
            ],
          ),
        ));
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      lineColor: Colors.white60,
      itemBuilder: centerTimelineBuilder,
      itemCount: stops.length,
      physics: BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final stop = stops[i];
    final textTheme = Theme.of(context).textTheme;
    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          color: Colors.white60,
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 8.0,
                ),
                Text("11:00 AM", style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  stop.stopName,
                  style: TextStyle().copyWith(
                      color: backgroundColor, fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == 7,
        iconBackground: overlayColor,
        icon: Icon(
          Icons.directions_bus,
          size: 30,
          color: Colors.white70,
        ));
  }
}
