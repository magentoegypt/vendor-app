import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String secmessage;
  final String positiveBtnText;
  final Function onPostivePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    required this.title,
    required this.message,
    required this.secmessage,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    required this.positiveBtnText,
    required this.onPostivePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);


  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    foregroundColor: Colors.black, minimumSize: Size(88, 44),
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    shape:  RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(22.0),),
    ),
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title) : null,
      content: message != null ?  Text.rich(
        TextSpan(
          text: message,
          style: TextStyle(
              fontFamily: 'LondrinaSolid',
              fontWeight: FontWeight.w400,
              fontSize: 16
          ),
          children: <TextSpan>[
            TextSpan(
                text: secmessage,
                style: TextStyle(
                    fontFamily: 'LondrinaSolid',
                    fontWeight: FontWeight.w300,
                    fontSize: 15
                )),
            TextSpan(
                text: '\nPrivacy Policy.',
                recognizer: new TapGestureRecognizer()..onTap = () {

                },
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: 'LondrinaSolid',
                    fontWeight: FontWeight.w300,
                    fontSize: 15
                )), // can add more TextSpans here...
          ],
        ),
      ) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        TextButton(
          style: flatButtonStyle,
          onPressed: () {
            Navigator.of(context, rootNavigator: true)
                .pop(true); // dismisses only the dialog and returns true
          },
          child: Text(positiveBtnText),
        ),
      ],
    );
  }
}