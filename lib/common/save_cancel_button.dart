import 'package:flutter/material.dart';
import '../core/config/app_constants.dart';
import '../core/config/colors.dart';
import 'gradient_text.dart';

class SaveCancelButton extends StatelessWidget {
   SaveCancelButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
     this.width,
     this.height,
     this.style
  });
   final TextStyle? style;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;
  double? width;
  double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height != null ? height:buttonHeight,
      width: width != null ? width:MediaQuery.of(context).size.width/2 - 40,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height != null ? height!/2:buttonHeight/2),
          border: Border.all(
            color: isSelected ? Colors.transparent:AppColors.gradient1Color,
            width: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment(-0.95, 0.0),
            end: Alignment(1.0, 0.0),
            colors: isSelected ?  [AppColors.gradient1Color, AppColors.gradient2Color] : [Colors.transparent,Colors.transparent],
            stops: [0.0, 1.0],
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: onTap,
          child: isSelected ? Text(
            title,
            style:  style != null ? style:TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: isSelected ? AppColors.white : AppColors.tabUnselectTextColor,
            ),
          ):GradientText(
            title,
            style: style != null ? style:TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            gradient: LinearGradient(colors: [
              AppColors.gradient1Color, AppColors.gradient2Color
            ]),
          ),
        ),
      ),
    );
  }
}
