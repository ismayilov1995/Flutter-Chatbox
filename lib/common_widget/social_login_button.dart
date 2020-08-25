import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double height;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key key,
      @required this.buttonText,
      this.buttonColor: Colors.purple,
      this.textColor: Colors.white,
      this.radius: 8.0,
      this.height: 50.0,
      this.buttonIcon,
      @required this.onPressed})
      : assert(buttonText != null, onPressed != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      child: SizedBox(
        height: height,
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Spreads, Collection-if, Collection-For
              if (buttonIcon != null) ...[
                buttonIcon,
                Text(
                  buttonText,
                  style: TextStyle(color: textColor),
                ),
                Opacity(
                  opacity: 0,
                  child: buttonIcon,
                )
              ],
              if (buttonIcon == null) ...[
                Container(),
                Text(
                  buttonText,
                  style: TextStyle(color: textColor),
                ),
                Container(),
              ]
            ],
          ),
          color: buttonColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// Old but gold
/*
buttonIcon != null ? buttonIcon : Center(),
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              buttonIcon != null
                  ? Opacity(
                      opacity: 0,
                      child: buttonIcon,
                    )
                  : Center(),
 */
