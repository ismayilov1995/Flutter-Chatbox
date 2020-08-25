import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double height;
  final double width;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key key,
      this.buttonText,
      this.buttonColor = Colors.purple,
      this.textColor = Colors.white,
      this.radius = 8.0,
      this.height,
      this.width,
      this.buttonIcon,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        buttonText,
        style: TextStyle(color: textColor),
      ),
      color: buttonColor,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      onPressed: onPressed,
    );
  }
}
