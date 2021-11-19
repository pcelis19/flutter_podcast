import 'package:flutter/material.dart';
import 'package:flutter_podcast/main.dart';
import 'package:flutter_podcast/services/theme_service.dart';
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
                      context.push(FlutterPodcastMainRouter.signInName),
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
                        builder: (_) => const SimpleDialog(
                          title: Text(
                            'About Flutter Podcast',
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            Text(
                              'Flutter Podcast is a Podcast application built with Flutter',
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                      child: const Text(
                        'Learn More',
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          context.push(FlutterPodcastMainRouter.signUpName),
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
              ThemeService.enableDarkTheme();
            } else {
              ThemeService.enableLightTheme();
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
