import 'package:flutter/material.dart';
import 'package:hyperloop/app/utils/constants.dart';
import 'package:hyperloop/app/widgets/auth_widgets.dart';
import 'package:hyperloop/app/widgets/email_signin_button.dart';
import 'package:hyperloop/app/widgets/facebook_signin_button.dart';
import 'package:hyperloop/app/widgets/google_signin_button.dart';
import 'package:hyperloop/app/widgets/phone_signin_button.dart';

class LoginMainCard extends StatefulWidget {
  final cardBackgroundColor = 0xFF6874C2;

  final Function onInvokeGoogleSignIn;
  final Function onInvokeFacebookSignIn;
  final Function onInvokePhoneSignIn;
  final Function onInvokeEmailSignIn;
  final Function onBackPress;

  const LoginMainCard(
      {Key key,
      @required this.onInvokeGoogleSignIn,
      @required this.onInvokeFacebookSignIn,
      @required this.onInvokePhoneSignIn,
      @required this.onInvokeEmailSignIn,
      @required this.onBackPress})
      : super(key: key);

  @override
  _LoginMainCardState createState() => _LoginMainCardState();
}

class _LoginMainCardState extends State<LoginMainCard> {
  double _height, _width, _fixedPadding;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _fixedPadding = _height * 0.025;

    return Card(
      color: Color(widget.cardBackgroundColor),
      elevation: 2.0,
      child: Container(
        height: _height * 9 / 10,
        width: _width * 9 / 10,
        child: _getCardContent(context),
      ),
    );
  }

  Widget _getCardContent(BuildContext context) {
    return Container(
      height: _height * 9 / 10,
      width: _width * 9 / 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(_fixedPadding * 3.5,
                _fixedPadding * 3.5, _fixedPadding * 3.5, _fixedPadding * 1.5),
            child: AuthWidgets.getLogo(
                logoPath: Resources.hyperloopLogo, height: _height * 0.2),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: _fixedPadding * 1.5),
                GoogleSignInButton(
                    onPressed: () {
                      widget.onInvokeGoogleSignIn();
                    },
                    darkMode: false),
                SizedBox(height: _fixedPadding * 1.5),
                FacebookSignInButton(onPressed: () {
                  widget.onInvokeFacebookSignIn();
                }),
                SizedBox(height: _fixedPadding * 1.5),
                PhoneSignInButton(onPressed: () {
                  widget.onInvokePhoneSignIn();
                }),
                SizedBox(height: _fixedPadding * 1.5),
                EmailSignInButton(onPressed: () {
                  widget.onInvokeEmailSignIn();
                }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
