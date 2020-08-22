import 'package:flutter/material.dart';
import 'package:shoplistingapp/WelcomePage.dart';


class LanguageSelectionPage extends StatelessWidget {
  static String id = 'LanguageSelectionPage';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: IconButton(
            iconSize: 300,
            onPressed: () {
              Navigator.pushNamed(context, WelcomePage.id);
            },
            icon: Icon(
              Icons.list,
              color: Color(0x775981f6),
            ),
          ),
        ),
      ),
    );
  }
}