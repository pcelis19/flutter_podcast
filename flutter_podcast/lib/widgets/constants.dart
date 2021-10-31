import 'package:flutter/material.dart';
import 'package:flutter_podcast/services/theme_service.dart';

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

class GradientBackground extends StatelessWidget {
  final double opacity;
  final Widget child;
  final BorderRadius? borderRadius;

  /// if true, will see object in the background
  final bool seeThrough;
  const GradientBackground({
    Key? key,
    this.opacity = .2,
    required this.child,
    this.seeThrough = false,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: isLightMode(context) ? Colors.white : Colors.black,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(opacity),
                Theme.of(context).accentColor.withOpacity(opacity),
              ],
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
