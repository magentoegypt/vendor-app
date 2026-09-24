
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'edit_product_info_widget.dart';

class PasswordController extends StatefulWidget {
  final controller;
  final String label;

  const PasswordController({super.key, this.controller,required this.label});

  @override
  State<PasswordController> createState() => _PasswordControllerState();
}

class _PasswordControllerState extends State<PasswordController> {
  bool isObscure = true;

  void _updateObsucure() {
    isObscure = !isObscure;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return EditProductInfoWidget(
      key: const Key('vendorAdminResetPasswordPassword'),
      label: widget.label,
      fontSize: 12.0,
      controller: widget.controller,
      isObscure: isObscure,
      suffixIcon: GestureDetector(
          onTap: _updateObsucure,
          child: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: Theme.of(context).iconTheme.color,
          )),
    );
  }
}