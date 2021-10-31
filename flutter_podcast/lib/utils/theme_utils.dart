import 'package:flutter/material.dart';

/// if the given context is in [ThemeMode.light]
bool isLightMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

ThemeData getTheme(BuildContext context) => Theme.of(context);
