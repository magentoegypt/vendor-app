import 'package:flutter/material.dart';
import '../core/config/colors.dart';

class AppButtonLarge extends StatefulWidget {
  final String? text;
  final Function? press;
  final Color color, textColor;
  final bool busy;

  const AppButtonLarge({
    Key? key,
    this.text,
    this.press,
    this.color = AppColors.black,
    this.textColor = Colors.white,
    this.busy = false,
  }) : super(key: key);

  @override
  State<AppButtonLarge> createState() => _AppButtonLargeState();
}

class _AppButtonLargeState extends State<AppButtonLarge> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.press as void Function()?,
      child: Container(
        color: widget.color,
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: !widget.busy
            ? Center(
                child: Text(
                  widget.text!,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.textColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              ),
      ),
    );
  }
}
