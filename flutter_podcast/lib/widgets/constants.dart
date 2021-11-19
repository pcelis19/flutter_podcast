import 'package:flutter/material.dart';
import 'package:flutter_podcast/utils/theme_utils.dart';

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
