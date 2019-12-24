import 'package:flutter/material.dart';
import 'package:hyperloop/app/utils/constants.dart';
import 'package:hyperloop/app/widgets/stretchable_button.dart';

class FacebookSignInButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double borderRadius;

  FacebookSignInButton({
    this.onPressed,
    this.borderRadius = defaultBorderRadius,
    this.text = 'Continue with Facebook',
    Key key,
  })  : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StretchableButton(
      buttonColor: Color(0xFF4267B2),
      borderRadius: borderRadius,
      onPressed: onPressed,
      buttonPadding: 8.0,
      children: <Widget>[
        Image(
          image: AssetImage(Resources.facebookLogo),
          height: 24.0,
          width: 24.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 14.0, right: 10.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
