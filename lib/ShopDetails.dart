import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

Firestore firestore;
FirebaseAuth auth;
String shopEmail;
String shopPassword;
String shopName;
String shopAddress;
String shopContactNumber;
double shopLatitude;
double shopLongitude;
String shopGSTIN;

String lastUpdatedDateTime;

List shopDatabase;
FirebaseUser shopUser;
String path = '/data/user/0/com.example.shoplistingapp/app_flutter/user_database.db';//database path
SharedPreferences shopDetails;
Database userDatabase;


