import 'package:flutter/material.dart';

import '../core/config/app_constants.dart';


class EditProductInfoWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool isMultiline;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final TextInputType keyboardType;
  final bool? enable;
  final onChanged;
  final onTap;
  final focusNode;
  final Color? backgroundColor;

  const EditProductInfoWidget({
    super.key,
    this.controller,
    required this.label,
    this.isMultiline = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.enable = true,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.backgroundColor
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 0,
            right: 0,
            top: 15,
          ),
          child: Container(
            alignment: selectedLanguage == "ar" ? Alignment.centerRight:Alignment.centerLeft,
          child:Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          )),
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: TextField(
            controller: controller,
            onTap: onTap,
            focusNode: focusNode,
            autocorrect: false,
            style: TextStyle(
              color: enable! ? Theme.of(context).iconTheme.color
                  : Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 0.5,
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(9.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              fillColor:  backgroundColor ?? Theme.of(context).primaryColorLight,
              filled: true,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
            ),
            obscureText: isObscure,
            maxLines: isMultiline ? 7 : 1,
            keyboardType: keyboardType,
            enabled: enable,
          ),
        ),
      ],
    );
  }
}

