import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';
import 'package:flutter_podcast/utils/constants.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';
import 'package:flutter_podcast/widgets/constants.dart';
import 'package:go_router/go_router.dart';

import '../router.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SimpleDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to \nFlutter Podcast!',
                  style: getTheme(context).textTheme.headline4,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () =>
                      context.goNamed(FlutterPodcastMainRouter.kSignInName),
                  child: const Text(
                    'Sign in',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => const AboutFlutterPodcastDialog(),
                      ),
                      child: const Text(
                        'Learn More',
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.goNamed(FlutterPodcastMainRouter.kSignUpName),
                      child: const Text(
                        'Sign up',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (isLightMode(context)) {
              ThemeService.instance.enableDarkTheme();
            } else {
              ThemeService.instance.enableLightTheme();
            }
          },
          child: Icon(
            isLightMode(context) ? Icons.brightness_5 : Icons.brightness_3,
          ),
        ),
      ),
    );
  }
}

class AboutFlutterPodcastDialog extends StatelessWidget {
  const AboutFlutterPodcastDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(12),
      title: const Text(
        'About Flutter Podcast',
        textAlign: TextAlign.center,
      ),
      children: [
        const Text(
          '"Flutter Podcast" is an iOS, Android and Web application built on a single code base using Flutter.',
          textAlign: TextAlign.center,
        ),
        TextButton(onPressed: () {}, child: const Text('link to repo'))
      ],
    );
  }
}
