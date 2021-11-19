import 'package:flutter/material.dart';

const duration600ms = Duration(milliseconds: 600);
const h32SizedBox = SizedBox(height: 32);
const h8SizedBox = SizedBox(height: 8);
const w16SizedBox = SizedBox(width: 16);
const w8SizedBox = SizedBox(width: 8);
const borderRadius40 = BorderRadius.all(Radius.circular(40));
const borderRadius20 = BorderRadius.all(Radius.circular(20));
const borderRadius10 = BorderRadius.all(Radius.circular(10));

/// value so that a material transition is returned on every platform
const pageTransitionTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.fuchsia: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
    TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
  },
);
