import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplistingapp/ListPage.dart';
import 'package:shoplistingapp/LoginPage.dart';
import 'package:shoplistingapp/LoginRegisterPage.dart';
import 'package:shoplistingapp/RegisterPage.dart';
import 'package:shoplistingapp/WelcomePage.dart';
import 'package:shoplistingapp/LanguageSelectionPage.dart';
import 'package:shoplistingapp/ShopDetails.dart';
import 'package:sqflite/sqflite.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  shopDetails = await SharedPreferences.getInstance();
  String tempEmail = shopDetails.getString('shopEmail');
  if (tempEmail != null && await File(path).exists()) { 
    shopEmail = tempEmail;
    shopName = shopDetails.getString('shopName');
    shopAddress = shopDetails.getString('shopAddress');
    shopContactNumber = shopDetails.getString('shopContactNumber');
    shopLatitude = shopDetails.getDouble('shopLatitude');
    shopLongitude = shopDetails.getDouble('shopLongitude');
    shopGSTIN = shopDetails.getString('shopGSTIN');
    lastUpdatedDateTime = shopDetails.get('lastUpdatedDateTime');
    userDatabase = await openDatabase(path, version: 1);
    shopDatabase = List.from(await userDatabase.query('item_table'), growable: true);
  }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:shopEmail == null ? LoginRegisterPage() : ListPage(),
      //home: LoginRegisterPage(),
      routes: {
        
        LanguageSelectionPage.id: (context) => LanguageSelectionPage(),
        WelcomePage.id: (context) => WelcomePage(),
        LoginRegisterPage.id: (context) => LoginRegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        RegisterPage.id: (context) => RegisterPage(),
        ListPage.id: (context) => ListPage(),
      },
    );
  }
}