import 'package:flutter/material.dart';
import 'package:hyperloop/constants/colors.dart';
import 'package:hyperloop/data_models/place.dart';
import 'package:hyperloop/pages/place_picker.dart';

class StopSelectWidget extends StatefulWidget {
  final Function(Place, bool) onSelected;

  StopSelectWidget(this.onSelected);

  _StopSelectWidgetState createState() => _StopSelectWidgetState();
}

class _StopSelectWidgetState extends State<StopSelectWidget> {
  Place fromAddress;
  Place toAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: overlayColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Color(0x88999999), offset: Offset(0, 5), blurRadius: 5.0)
        ],
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlacePicker(
                              fromAddress == null ? "" : fromAddress.name,
                              (place, isFrom) {
                            fromAddress = place;
                            widget.onSelected(place,isFrom);
//                          _plotMarker(place, isFrom);
                            setState(() {});
                          }, true)));
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4)
                            .copyWith(top: 8),
                        child: Icon(
                          Icons.subdirectory_arrow_right,
                          color: Colors.orangeAccent,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 50.0, right: 50.0, top: 8),
                        child: Text(
                          fromAddress == null
                              ? "Source Bus Stop"
                              : fromAddress.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: fromAddress == null
                                  ? Colors.white70
                                  : Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white70,
            thickness: 1.5,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 50,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          PlacePicker(toAddress == null ? '' : toAddress.name,
                              (place, isFrom) {
                            toAddress = place;
                            widget.onSelected(place,isFrom);
//                          _plotMarker(place, isFrom);
                            setState(() {});
                          }, false)));
                },
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.subdirectory_arrow_left,
                          color: Colors.greenAccent,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Text(
                          toAddress == null
                              ? "Destination Bus Stop"
                              : toAddress.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              color: toAddress == null
                                  ? Colors.white70
                                  : Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
