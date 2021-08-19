import 'package:flutter/material.dart';

class ServerDownPage extends StatelessWidget {
  const ServerDownPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Server Down, try again later"),
        ),
      ),
    );
  }
}
