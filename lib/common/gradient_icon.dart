import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  const GradientIcon(
      this.icon, {
        required this.gradient,
      });

  final Icon icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: icon,
    );
  }
}