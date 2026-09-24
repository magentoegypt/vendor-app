import 'package:flutter/material.dart';
import '../core/config/app_constants.dart';
import '../core/config/colors.dart';

class SmallButton extends StatelessWidget {
  const SmallButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: switchbuttonHeight,
      width: 102,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              isSelected ? AppColors.kPrimaryColor : AppColors.white,
          shape:getborder(),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'LondrinaSolid',
            fontWeight: FontWeight.w400,
            fontSize: 19,
            color: isSelected ? AppColors.white : AppColors.tabUnselectTextColor,
          ),
        ),
      ),
    );
  }

  RoundedRectangleBorder getborder(){
    if(title == "Annualy" && isSelected){
      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)));
    }else if(title == "Monthly" && !isSelected){
      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)));
    }else if(title == "Monthly" && isSelected){
      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)));
    }else{
      return RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)));
    }
  }
}
