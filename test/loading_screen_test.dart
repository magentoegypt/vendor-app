import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_vendor/core/helper/loading_screen.dart';
import 'package:multi_vendor/core/helper/overlay_animated_spinner.dart';

/// Shows the loading overlay as soon as it opens and never hides it, like
/// Products, Orders or the profile while their request is still running.
class _LoadingPage extends StatefulWidget {
  const _LoadingPage();

  @override
  State<_LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<_LoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => LoadingScreen().show(context: context, text: 'Please wait'));
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Text('products'));
}

void main() {
  Future<NavigatorState> openDashboard(WidgetTester tester) async {
    final key = GlobalKey<NavigatorState>();
    await tester.pumpWidget(MaterialApp(
      navigatorKey: key,
      navigatorObservers: [LoadingScreenObserver()],
      home: const Scaffold(body: Text('dashboard')),
    ));
    return key.currentState!;
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
  }

  group('Menu screens loading overlay (14zb93nuzur)', () {
    testWidgets('back while the screen is loading removes its spinner',
        (tester) async {
      final navigator = await openDashboard(tester);
      navigator.push(MaterialPageRoute(builder: (_) => const _LoadingPage()));
      await settle(tester);
      expect(find.byType(OverLayAnimatedSpinner), findsOneWidget);

      navigator.pop();
      await settle(tester);
      expect(find.text('dashboard'), findsOneWidget);
      expect(find.byType(OverLayAnimatedSpinner), findsNothing);
    });

    testWidgets('closing a dialog keeps the screen\'s own spinner',
        (tester) async {
      final navigator = await openDashboard(tester);
      navigator.push(MaterialPageRoute(builder: (_) => const _LoadingPage()));
      await settle(tester);
      navigator.push(DialogRoute<void>(
          context: navigator.context, builder: (_) => const Text('dialog')));
      await settle(tester);
      navigator.pop();
      await settle(tester);
      expect(find.byType(OverLayAnimatedSpinner), findsOneWidget);

      LoadingScreen().hide();
      await settle(tester);
    });
  });
}
