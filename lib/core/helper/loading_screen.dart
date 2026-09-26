import 'dart:async';
import 'package:flutter/material.dart';
import 'loading_screen_controller.dart';
import 'overlay_animated_spinner.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  // The route whose screen showed the overlay. The overlay sits above every
  // route, and the BlocListener that would hide it goes away with that screen,
  // so leaving the screen mid-request left the spinner up for good.
  Route<dynamic>? _owner;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      _owner = ModalRoute.of(context);
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    controller?.close();
    controller = null;
    _owner = null;
  }

  /// Hides the overlay if [route], which is leaving the navigator, showed it.
  /// Runs after the navigator finishes the pop, so a loader the next screen
  /// shows in the meantime is left alone.
  void routeGone(Route<dynamic>? route) {
    if (route == null || !identical(route, _owner)) return;
    scheduleMicrotask(() {
      if (identical(route, _owner)) hide();
    });
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    //final renderBox = context.findRenderObject() as RenderBox;
    //final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const OverLayAnimatedSpinner(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    state?.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}

/// Hides the loading overlay when the screen that showed it leaves before its
/// request finishes, e.g. back from Products, Orders or the profile.
class LoadingScreenObserver extends NavigatorObserver {
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      LoadingScreen().routeGone(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      LoadingScreen().routeGone(route);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      LoadingScreen().routeGone(oldRoute);
}
