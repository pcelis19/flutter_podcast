import 'package:flutter/cupertino.dart';

bool isPortrait(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.height > size.width;
}
