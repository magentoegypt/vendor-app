
import 'package:flutter/material.dart';

import '../../data/ProductAttributeModel.dart';



class ProductInfoDropdownWidget extends StatefulWidget {

  final TextEditingController? controller;
  final String label;
  final ProductAttributeModel productAttributeModel;
  final List<String> list;
  final bool isMultiline;
  final bool isObscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final TextInputType keyboardType;
  final bool? enable;
  //final onChanged;
  final ValueChanged<String>? onChangedCustom;



   ProductInfoDropdownWidget({
    super.key,
    this.controller,
    required this.label,
    required this.productAttributeModel,
    required this.list,
    this.isMultiline = false,
    this.prefixIcon,
    this.suffixIcon,
    this.fontSize,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.enable = true,
    this.onChangedCustom,
  });

  @override
  _ProductInfoDropdownWidget createState() => _ProductInfoDropdownWidget();
}

class _ProductInfoDropdownWidget extends State<ProductInfoDropdownWidget> {



  @override
  Widget build(BuildContext context) {

    // return Container(
    //   decoration: ShapeDecoration(
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(width: 1.0, style: BorderStyle.solid),
    //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //     ),
    //   ),
    //   child: DropdownButton<String>(
    //     items: <String>[
    //       'Category 1',
    //       'Category 2',
    //       'Category 3',
    //       'Category 4'
    //     ].map((String value) {
    //       return DropdownMenuItem<String>(
    //         value: value,
    //         child: Text(value),
    //       );
    //     }).toList(),
    //     hint: Text(_currentSelectedValue.isEmpty
    //         ? 'Category Food'
    //         : _currentSelectedValue),
    //     borderRadius: BorderRadius.circular(10),
    //     underline: SizedBox(),
    //     isExpanded: true,
    //     onChanged: (value) {
    //       if (value != null) {
    //         setState(() {
    //           _currentSelectedValue = value;
    //         });
    //       }
    //     },
    //   ),
    // );
   return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
           // left: 15,
           // right: 15,
            top: 15,
          ),
          child: Text(
            widget.label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 5),
        Container(
        //  margin: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(9.0),
          ),
          child: FormField<String>(
            builder: (FormFieldState<String> state) {
              return InputDecorator(
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
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: widget.suffixIcon,
                ),
                isEmpty: widget.productAttributeModel.value == '',
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: widget.productAttributeModel.value ?? widget.list.first,
                    isDense: true,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        if (widget.onChangedCustom != null) widget.onChangedCustom!(value);
                        setState(() {
                          widget.productAttributeModel.value = value;
                        });
                      }
                    },
                    items: widget.list.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(color: Colors.black, fontSize: 16.0),),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
