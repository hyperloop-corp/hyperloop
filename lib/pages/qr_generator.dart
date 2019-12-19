import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGeneratorWidget extends StatefulWidget {
  final sourceLat;
  final sourceLong;
  final destinationLat;
  final destinationLong;
  final price;
  var message;

  QrCodeGeneratorWidget(
      {Key key,
      this.sourceLat,
      this.destinationLong,
      this.price,
      this.sourceLong,
      this.destinationLat})
      : super(key: key);

  _QrCodeGeneratorState createState() => _QrCodeGeneratorState();
}

class _QrCodeGeneratorState extends State<QrCodeGeneratorWidget> {
  FirebaseUser user;

  void _getUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        widget.message = {
          'sourceLat': '${widget.sourceLat}',
          'sourceLong': '${widget.sourceLong}',
          'destinationLat': '${widget.destinationLat}',
          'destinationLong': '${widget.destinationLong}',
          'price': '${widget.price}',
          'user_id': '${user.uid}'
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[

          Expanded(
            child: Center(
              child: Container(
                width: 280,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 5.0),
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white70),
                child: QrImage(
                  data: widget.message.toString(),
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                  foregroundColor: Color(0xff03291c),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: FlatButton(
              splashColor: Colors.transparent,
              color: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.close, color: Colors.white,),
                  SizedBox(width: 5,),
                  Text("CLOSE", style: TextStyle(color: Colors.white70, fontSize: 22),),
                ],
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
