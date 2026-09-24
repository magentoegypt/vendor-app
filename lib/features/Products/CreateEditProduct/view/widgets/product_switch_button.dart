import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/ProductAttributeModel.dart';

class ProductInfoSwitchWidget extends StatefulWidget {

  final String label;
  final onChanged;
  final ProductAttributeModel productAttributeModel;

  const ProductInfoSwitchWidget({
    super.key,
    required this.label,
    required this.productAttributeModel,
    this.onChanged,
  });

  @override
  _ProductInfoSwitchWidget createState() => _ProductInfoSwitchWidget();
}

class _ProductInfoSwitchWidget extends State<ProductInfoSwitchWidget> {



  @override
  Widget build(BuildContext context) {
    return  CupertinoListTile(
        title:Text(
          widget.label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: CupertinoSwitch(
          value: widget.productAttributeModel.value ?? false,
          thumbColor: Colors.white,
          activeColor: Colors.deepPurple,
          // trackColor: ,
          onChanged: (value) {
            setState(() =>  widget.productAttributeModel.value = value);

          },
        ));
  }
}