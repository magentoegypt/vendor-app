import 'package:flutter/material.dart';

import '../../core/config/locator.dart';
import '../../main.dart';
import '../auth/api_login_feature/view/login_view.dart';

class LanguageScreen extends StatelessWidget {

  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(
      //   AppLocalizations.of(context)!.changeLanguage,
      //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      //       color: Theme.of(context)
      //           .colorScheme.primary,fontSize: 17),
      // )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // const SizedBox(height: 100),
            Text(
              "اختر اللغة",
              style: TextStyle(
                  fontSize: 30.0, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(
              height: 40.0,
            ),
            SizedBox(
                width: 250, // <-- Your width
                height: 45,
                child:ElevatedButton(
              onPressed: () {
                MainApp.setLocale(context, Locale("en", ""));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInView(),
                    ),
                        (e) => false);
              },
              child: const Text('English'),
            )),
            const SizedBox(
              height: 20.0,
            ),
            SizedBox(
                width: 250, // <-- Your width
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    MainApp.setLocale(context, Locale("ar", ""));
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInView(),
                        ),
                            (e) => false);
                  },
                  child: const Text('عربي'),
                ),
            )
          ],
        ),
      ),
    );
  }
}