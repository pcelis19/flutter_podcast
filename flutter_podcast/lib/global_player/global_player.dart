import 'package:flutter/material.dart';

class GlobalPlayer extends StatelessWidget {
  const GlobalPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).accentColor.withOpacity(.8),
            Theme.of(context).primaryColor.withOpacity(.8),
          ],
        ),
      ),
      child: Center(
        child: ListTile(
          leading: CircleAvatar(
            child: FlutterLogo(),
          ),
          title: Text(
            'All About Widgets!',
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(Icons.play_arrow),
          ),
        ),
      ),
    );
  }
}
