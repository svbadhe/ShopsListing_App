import 'package:flutter/material.dart';
import 'package:shoplistingapp/RegisterPage.dart';
import 'package:shoplistingapp/ListPage.dart';
import 'package:shoplistingapp/ShopDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    auth = FirebaseAuth.instance;
    firestore = Firestore.instance;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                    child: Hero(
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
                            text: 'S',
                            style: TextStyle(color: Color(0xff5981f6))),
                        TextSpan(text: 'hops'),
                        TextSpan(
                            text: 'L',
                            style: TextStyle(color: Color(0xff5981f6))),
                        TextSpan(text: 'isting'),
                      ],
                    ),
                  ),
                )),
              ),
              Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff5981f6)))),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff5981f6)))),
                        obscureText: true,
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(top: 15.0, left: 20.0),
                        child: InkWell(
                          onTap: () {
                            print('Forgot password');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 0.0),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              child: SpinKitWave(
                                color: Color(0xff5981f6),
                                duration: Duration(seconds: 1),
                              ),
                            );
                            AuthResult result =
                                await auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            shopUser = result.user;
                            var database = await firestore
                                .collection('ShopsList')
                                .document(shopUser.email)
                                .get();
                            //get data and set it to currentUser specifications
                            shopEmail = database['email'];
                            shopPassword = database['password'];
                            shopName = database['name'];
                            shopAddress = database['address'];
                            shopContactNumber = database['contact'];
                            shopLatitude = database['latitude'];
                            shopLongitude = database['longitude'];
                            shopGSTIN = database['gstin'];
                            shopDatabase =
                                List.from(database['database'], growable: true);
                            Navigator.pushNamed(context, ListPage.id);
                            shopDetails = await SharedPreferences.getInstance();
                            shopDetails.setString('shopEmail', shopEmail);
                            shopDetails.setString('shopName', shopName);
                            shopDetails.setString('shopAddress', shopAddress);
                            shopDetails.setString(
                                'shopContactNumber', shopContactNumber);
                            shopDetails.setDouble('shopLatitude', shopLatitude);
                            shopDetails.setDouble(
                                'shopLongitude', shopLongitude);
                            shopDetails.setString('shopGSTIN', shopGSTIN);

                            if (await File(path).exists()) {
                              userDatabase =
                                  await openDatabase(path, version: 1);
                            } else {
                              userDatabase =
                                  await openDatabase(path, version: 1, onCreate:
                                      (Database db, int newVersion) async {
                                await db.execute(
                                    'CREATE TABLE item_table(id INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT, quantity INTEGER)');
                              });
                            }
                            for (int i = 0; i < shopDatabase.length; i++) {
                              await userDatabase.insert('item_table', {
                                'item': shopDatabase[i]['item'],
                                'quantity': shopDatabase[i]['quantity']
                              });
                            }
                            userDatabase.close();
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
                    ],
                  )),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'New to ShopsListing? --->',
                  ),
                  SizedBox(width: 5.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(RegisterPage.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 0.0),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
