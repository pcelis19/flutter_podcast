import 'package:flutter/material.dart';

class GlobalPlayer extends StatelessWidget {
  const GlobalPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('AudioPlayer')],
    );
  }
}
