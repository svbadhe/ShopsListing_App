import 'package:flutter/material.dart';
import 'package:shoplistingapp/LoginPage.dart';
import 'package:shoplistingapp/RegisterPage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class LoginRegisterPage extends StatelessWidget {
  static String id = 'LoginRegisterPage';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'text',
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 50,
                      fontFamily: 'Horizon'),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'S', style: TextStyle(color: Color(0xff5981f6))),
                    TextSpan(text: 'hops'),
                    TextSpan(
                        text: 'L', style: TextStyle(color: Color(0xff5981f6))),
                    TextSpan(text: 'isting'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TypewriterAnimatedTextKit(
              text: ['Build your shop\'s online presence NOW!'],
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Agne"),
              speed: Duration(microseconds: 10000),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginPage.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff5981f6),
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Color(0x225981f6),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Center(
                            child: Text('LOGIN',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      height: 40.0,
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xff5981f6),
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Color(0x225981f6),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Center(
                            child: Text('REGISTER',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        )),
      ),
    );
  }
}
