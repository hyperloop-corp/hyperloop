import 'package:flutter/material.dart';
import 'package:hyperloop/app/utils/constants.dart';
import 'package:hyperloop/app/widgets/stretchable_button.dart';

class GoogleSignInButton extends StatelessWidget {
  final String text;
  final bool darkMode;
  final double borderRadius;
  final VoidCallback onPressed;

  GoogleSignInButton(
      {this.onPressed,
      this.text = 'Sign in with Google',
      this.darkMode = false,
      this.borderRadius = defaultBorderRadius,
      Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: darkMode ? Color(0xFF4285F4) : Colors.white,
      borderRadius: borderRadius,
      onPressed: onPressed,
      buttonPadding: 0.0,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            height: 38.0,
            width: 38.0,
            decoration: BoxDecoration(
              color: darkMode ? Colors.white : null,
              borderRadius: BorderRadius.circular(this.borderRadius),
            ),
            child: Center(
              child: Image(
                image: AssetImage(Resources.googleLogo),
                height: 18.0,
                width: 18.0,
              ),
            ),
          ),
        ),
        SizedBox(width: 14.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500,
              color: darkMode ? Colors.white : Colors.black.withOpacity(0.54),
            ),
          ),
        ),
      ],
    );
  }
}
