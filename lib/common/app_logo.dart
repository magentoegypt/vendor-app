import 'package:flutter/material.dart';

import '../core/config/app_constants.dart';
import 'flux_image.dart';

/// The Hub Market logo on Login, Register and Seller Profile, at 38% of the
/// screen width as in QA's example (DEV15). The box keeps the height the
/// larger logo had, so the logo shrinks in place and nothing under it moves.
class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return FluxImage(
      imageUrl: kAppLogo,
      fit: BoxFit.contain,
      width: width * 0.38,
      height: width * 0.3,
    );
  }
}
