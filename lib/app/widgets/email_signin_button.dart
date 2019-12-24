import 'package:flutter/material.dart';
import 'package:hyperloop/app/widgets/stretchable_button.dart';

class EmailSignInButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final VoidCallback onPressed;

  EmailSignInButton(
      {this.onPressed,
      this.text = 'Sign in with Email',
      this.borderRadius = defaultBorderRadius,
      Key key})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: Colors.white,
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
              borderRadius: BorderRadius.circular(this.borderRadius),
            ),
            child: Center(
              child: Icon(
                Icons.email,
                size: 18.0,
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
              color: Colors.black.withOpacity(0.54),
            ),
          ),
        ),
      ],
    );
  }
}
