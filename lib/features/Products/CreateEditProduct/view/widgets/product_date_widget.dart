
import 'package:flutter/material.dart';

import '../../data/ProductAttributeModel.dart';


class EditProductInfoDateWidget extends StatelessWidget {

  final String label;
  final ProductAttributeModel? productAttributeModel;
  final bool isMultiline;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final TextInputType keyboardType;
  final bool? enable;
  final onChanged;
  final onTap;

  EditProductInfoDateWidget({
    super.key,
    required this.label,
     this.productAttributeModel,
    this.isMultiline = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.enable = true,
    this.onChanged,
    this.onTap,
  });

  final TextEditingController? controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(productAttributeModel?.value != null) {
      controller?.text = productAttributeModel?.value;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label.isNotEmpty)
        Padding(
          padding: const EdgeInsets.only(
          //  left: 15,
           // right: 15,
            top: 15,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        if(label.isNotEmpty)
        const SizedBox(height: 5),
        Container(
        //  margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: TextField(
            controller: controller,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000, 1),
                lastDate: DateTime(2070, 12),
              ).then((pickedDate) {
                 if(pickedDate != null) {
                   controller?.text = pickedDate.toString();
                   productAttributeModel?.value = pickedDate.toString();
                 }
              });
            },
            focusNode: AlwaysDisabledFocusNode(),
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
              fillColor: Theme.of(context).primaryColorLight,
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}