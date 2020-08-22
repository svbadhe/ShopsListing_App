import 'package:flutter/material.dart';
import 'package:shoplistingapp/LoginRegisterPage.dart';
class WelcomePage extends StatelessWidget {
  static String id = 'WelcomePage';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IconButton(
            iconSize: 300,
            onPressed: () {
              Navigator.pushNamed(context, LoginRegisterPage.id);
            },
            icon: Icon(
              Icons.list,
              color: Color(0xff5981f6),
            ),
          ),
        ),
      ),
    );
  }
}
