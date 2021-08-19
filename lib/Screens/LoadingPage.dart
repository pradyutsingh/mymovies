import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Loading",
      home: Scaffold(
        body: Center(
          child: Container(
            child: Text("Loading..."),
          ),
        ),
      ),
    );
  }
}
