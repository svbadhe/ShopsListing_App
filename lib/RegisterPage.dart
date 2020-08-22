import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shoplistingapp/ListPage.dart';
import 'package:shoplistingapp/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoplistingapp/ShopDetails.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RegisterPage extends StatefulWidget {
  static String id = 'RegisterPage';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String password;

  Future<LocationData> getCurrentLocation() async {
    Location location = new Location();
    return await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    auth = FirebaseAuth.instance;
    firestore = Firestore();
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
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
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          shopName = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'SHOP\'S NAME',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff5981f6)))),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          shopEmail = value;
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
                      SizedBox(height: 10.0),
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
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          shopContactNumber = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'CONTACT NUMBER',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff5981f6)))),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                shopAddress = value;
                              },
                              decoration: InputDecoration(
                                  labelText: 'ADDRESS',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff5981f6)))),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.my_location,
                                  color: Color(0xff5981f6),
                                ),
                                onPressed: () async {
                                  LocationData temp =
                                      await getCurrentLocation();
                                  shopLatitude = temp.latitude;
                                  shopLongitude = temp.longitude;
                                },
                                tooltip: 'Auto Detect Location',
                              ),
                              Text(
                                'Auto Detect',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontFamily: 'Horizon'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          shopGSTIN = value;
                        },
                        decoration: InputDecoration(
                            labelText: 'GSTIN',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xff5981f6)))),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Container(
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
                            await auth.createUserWithEmailAndPassword(
                                email: shopEmail, password: password);
                        shopUser = result.user;
                        shopDatabase = [];
                        if (shopUser != null) {
                          firestore
                              .collection('ShopsList')
                              .document(shopEmail)
                              .setData({
                            'email': shopEmail,
                            'name': shopName,
                            'address': shopAddress,
                            'contact': shopContactNumber,
                            'longitude': shopLongitude,
                            'latitude': shopLatitude,
                            'gstin': shopGSTIN,
                            'database': shopDatabase
                          });
                          Navigator.pushNamed(context, ListPage.id);

                          shopDetails = await SharedPreferences.getInstance();
                          shopDetails.setString('shopEmail', shopEmail);
                          shopDetails.setString('shopName', shopName);
                          shopDetails.setString('shopAddress', shopAddress);
                          shopDetails.setString(
                              'shopContactNumber', shopContactNumber);
                          shopDetails.setDouble('shopLatitude', shopLatitude);
                          shopDetails.setDouble('shopLongitude', shopLongitude);
                          shopDetails.setString('shopGSTIN', shopGSTIN);

                          if (await File(path).exists()) {
                            userDatabase = await openDatabase(path, version: 1);
                          } else {
                            userDatabase = await openDatabase(path, version: 1,
                                onCreate: (Database db, int newVersion) async {
                              await db.execute(
                                  'CREATE TABLE item_table(id INTEGER PRIMARY KEY AUTOINCREMENT, item TEXT, quantity INTEGER)');
                            });
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xff5981f6),
                                style: BorderStyle.solid,
                                width: 1.0),
                            color: Color(0x225981f6),
                            borderRadius: BorderRadius.circular(5.0)),
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
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already registered to ShopsListing? --->',
                    ),
                    SizedBox(width: 5.0),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed(LoginPage.id);
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
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
    );
  }
}
