import 'package:flutter/material.dart';
import '../config/colors.dart';

class OverLayAnimatedSpinner extends StatefulWidget {
  const OverLayAnimatedSpinner({Key? key}) : super(key: key);

  @override
  State<OverLayAnimatedSpinner> createState() => _OverLayAnimatedSpinnerState();
}

class _OverLayAnimatedSpinnerState extends State<OverLayAnimatedSpinner>
    with TickerProviderStateMixin {
  AnimationController? anim;

  @override
  void initState() {
    super.initState();

    anim =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  dispose() {
    anim!.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    anim!.forward();
    return Center(
      child: SizedBox(
        // width: 440,
        // height: 440,
        child: FadeTransition(
          opacity: Tween<double>(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(parent: anim!, curve: Curves.easeInOut)),
          child: SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(0.0, 0.25), end: const Offset(0.0, 0.0))
                .animate(
                    CurvedAnimation(parent: anim!, curve: Curves.easeInOut)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.black.withOpacity(0.3)),
                      strokeWidth: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
