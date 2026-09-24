import 'package:flutter/material.dart';
import '../../common/vertical_space.dart';

import '../core/config/app_constants.dart';
import '../core/config/colors.dart';

class CommonDropdownButtonFormFieldView extends StatelessWidget {
  final String? labelText;
  final String? valueText;
  final String hintText;
  final String? errorText;
  final bool isAllowTopTitleView;
  final EdgeInsetsGeometry padding;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final double textFieldBoxHeight;
  final Function(String?) onChanged;

  const CommonDropdownButtonFormFieldView({
    Key? key,
    this.labelText,
    this.valueText,
    this.hintText = '',
    this.padding = const EdgeInsets.only(),
    required this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.isAllowTopTitleView = true,
    this.errorText,
    this.textFieldBoxHeight = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null ? Text(labelText!,style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),):Container(),
          const VerticalSpace(smallSpace),
          Container(
            height: textFieldBoxHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: DropdownButtonFormField(
                  value: valueText!.isNotEmpty ? valueText:null,
                  iconSize: 0.0,
                  onChanged: onChanged,
                  style: const TextStyle(color: AppColors.plantextBlacColor,fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                      fontSize: 19),
                  decoration: InputDecoration(
                    hintText: hintText,
                    //contentPadding: const EdgeInsets.only(left: 10),
                    suffixIcon: suffixIcon,
                    prefixIcon: prefixIcon,
                    labelText: null,
                    labelStyle: const TextStyle(color: Colors.grey,fontFamily: 'Inter',
                        fontWeight: FontWeight.w400, fontSize: 19),
                    hintStyle: const TextStyle(color: Colors.grey,fontFamily: 'Inter',
                        fontWeight: FontWeight.w400, fontSize: 19),
                    border: InputBorder.none,
                  ),
                  items: <String>['State 1', 'State 2', 'State 3', 'State 4']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: AppColors.plantextBlacColor,fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                        fontSize: 19),),
                  );
                }).toList(),
                ),
              ),
            ),
          ),
          if (errorText != null && errorText != '')
            Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 16, top: 4, bottom: 4),
              child: Text(
                errorText ?? "",
                style: TextStyle(
                  color: Colors.red.shade200,
                  fontSize: 14,
                ),
              ),
            )
        ],
      ),
    );
  }
}
