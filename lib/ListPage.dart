import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoplistingapp/LoginRegisterPage.dart';
import 'package:shoplistingapp/ShopDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:isolate';

Isolate isolate;
ReceivePort timeTravel;

void start() async {
  timeTravel = ReceivePort();
  timeTravel.listen((data) async {
    firestore.collection('ShopsList').document(shopEmail).setData({
      'email': shopEmail,
      'name': shopName,
      'address': shopAddress,
      'contact': shopContactNumber,
      'longitude': shopLongitude,
      'latitude': shopLatitude,
      'gstin': shopGSTIN,
      'database': shopDatabase
    });
    lastUpdatedDateTime = data;
    shopDetails = await SharedPreferences.getInstance();
    shopDetails.setString('lastUpdatedDateTime', lastUpdatedDateTime);
  });
  isolate = await Isolate.spawn(entryPoint, timeTravel.sendPort);
}

void entryPoint(SendPort timeTravel) {
  timeTravel.send(DateTime.now().toString()); // to set initial time
  int hour;
  int updateHour = 6;
  Timer.periodic(Duration(hours: 1), (timer) {
    DateTime temp = DateTime.now();
    hour = temp.hour;
    if (hour == updateHour) {
      timeTravel.send(temp.toString());
    } //just to trigger the database update
  });
}

void stop() {
  timeTravel.close();
  isolate.kill(priority: Isolate.immediate);
}

class ListPage extends StatefulWidget {
  static String id = 'ListPage';

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String newTask;
  int quantity;
  TextEditingController controllerNewItem = TextEditingController();
  TextEditingController controllerQuantity = TextEditingController();

  void stateUpdater() {
    setState(() {});
  }

  void initState() {
    super.initState();
    start();
  }

  Widget build(BuildContext context) {
    firestore = Firestore();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            shopName,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Color(0xff5981f6),
          leading: Icon(
            Icons.store,
            color: Colors.black,
            size: 25,
          ),
          actions: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.power_settings_new,
                color: Colors.black,
                size: 25,
              ),
              onTap: () async {
                stop();
                firestore.collection('ShopsList').document(shopEmail).setData({
                  'email': shopEmail,
                  'name': shopName,
                  'address': shopAddress,
                  'contact': shopContactNumber,
                  'longitude': shopLongitude,
                  'latitude': shopLatitude,
                  'gstin': shopGSTIN,
                  'database': shopDatabase
                });
                setState(() {
                  shopName = 'Please LoginIn';
                  shopEmail = null;
                  shopDatabase.clear();
                  Navigator.pushNamed(context, LoginRegisterPage.id);
                });
                await FirebaseAuth.instance.signOut();
                await shopDetails.clear();
                shopDatabase.clear();
                await deleteDatabase(path);
              },
            ),
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
                size: 25,
              ),
              onTap: () {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            elevation: 0,
                            child: Container(
                              height: 280,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Horizon'),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Last Updated: ',
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Horizon'),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: lastUpdatedDateTime.substring(
                                                11, 19)),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Horizon'),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                '${lastUpdatedDateTime.substring(8, 10)}-${lastUpdatedDateTime.substring(5, 7)}-${lastUpdatedDateTime.substring(0, 4)}'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Horizon'),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Next Scheduled Update:'),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontFamily: 'Horizon'),
                                      children: <TextSpan>[
                                        TextSpan(text: '06:00 - 07:00'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      });
                });
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xff5981f6),
          elevation: 0,
          disabledElevation: 0,
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 35,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  elevation: 0,
                  child: Container(
                    height: 280,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Add Item',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Horizon'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: TextField(
                            onChanged: (value) {
                              newTask = value;
                            },
                            controller: controllerNewItem,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              labelText: 'Add New Item',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              quantity = int.parse(value);
                            },
                            controller: controllerQuantity,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5)),
                              labelText: 'Quantity',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        OutlineButton(
                          child: Text(
                            'ADD',
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),
                          padding: EdgeInsets.all(10),
                          borderSide:
                              BorderSide(color: Color(0xff5981f6), width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () async {
                            userDatabase = await openDatabase(path, version: 1);
                            await userDatabase.insert('item_table',
                                {'item': newTask, 'quantity': quantity});
                            userDatabase.close();
                            setState(() {
                              if (newTask != null && quantity != null) {
                                shopDatabase.add(
                                    {'item': newTask, 'quantity': quantity});
                                controllerQuantity.clear();
                                controllerNewItem.clear();
                                Navigator.pop(context);
                                newTask = null;
                                quantity = null;
                              }
                            });
                          },
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return Dismissible(
                        background: Padding(
                          padding:
                              EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.red,
                                  style: BorderStyle.solid,
                                  width: 2.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                          ),
                        ),
                        key: Key(shopDatabase[index]['item']),
                        onDismissed: (direction) {
                          setState(() {
                            ListViewUnit(
                              taskName: shopDatabase[index]['item'],
                              quantity: shopDatabase[index]['quantity'],
                            ).deleteFromDatabase();
                            shopDatabase.removeAt(index);
                          });
                        },
                        child: ListViewUnit(
                          taskName: shopDatabase[index]['item'],
                          quantity: shopDatabase[index]['quantity'],
                        ));
                  },
                  itemCount: shopDatabase.length,
                ),
              ),
            ),
            SizedBox(
              height: 0,
            ),
          ],
        ),
      ),
    );
  }
}

class ListViewUnit extends StatefulWidget {
  final String taskName;
  final int quantity;

  ListViewUnit({this.taskName, this.quantity});

  void deleteFromDatabase() async {
    userDatabase = await openDatabase(path, version: 1);
    await userDatabase
        .delete('item_table', where: "item = ?", whereArgs: [taskName]);
    userDatabase.close();
  }

  @override
  _ListViewUnitState createState() =>
      _ListViewUnitState(quantity: quantity, taskName: taskName);
}

class _ListViewUnitState extends State<ListViewUnit> {
  bool isChecked = false;
  bool isSelected = false;
  int quantity;
  String taskName;
  _ListViewUnitState({this.taskName, this.quantity});

  void updateQuantitiesInDatabase(int newQuantity) async {
    userDatabase = await openDatabase(path, version: 1);
    await userDatabase.update(
        'item_table', {'item': taskName, 'quantity': newQuantity},
        where: 'item = ?', whereArgs: [taskName]);
    shopDatabase =
        List.from(await userDatabase.query('item_table'), growable: true);
    userDatabase.close();
  }

  @override
  Widget build(BuildContext context) {
    firestore = Firestore.instance;
    return Padding(
      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey, style: BorderStyle.solid, width: 2.0),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
            leading: Icon(Icons.reorder,
                color: quantity > 5 ? Colors.blue : Colors.red),
            contentPadding: EdgeInsets.all(5),
            title: Text(
              taskName,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Horizon'),
            ),
            subtitle: Text(quantity > 5 ? "Instock" : "Reorder"),
            trailing: Container(
              height: 50,
              width: 130,
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    height: 70,
                    child: GestureDetector(
                      child: Icon(
                        Icons.add_circle_outline,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          quantity = quantity + 1;
                        });
                        updateQuantitiesInDatabase(quantity);
                      },
                    ),
                  )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              width: 2.0),
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          controller: TextEditingController(
                            text: quantity.toString(),
                          ),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(border: InputBorder.none),
                          style: TextStyle(
                              color: Colors.black, fontFamily: 'Horizon'),
                          onChanged: (value) {
                            setState(() {
                              if (value != null) {
                                quantity = int.parse(value);
                                updateQuantitiesInDatabase(quantity);
                              } else {
                                quantity = 0;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 70,
                    child: GestureDetector(
                      child: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        setState(() {
                          quantity = quantity - 1;
                        });
                        updateQuantitiesInDatabase(quantity);
                      },
                    ),
                  )),
                ],
              ),
            )),
      ),
    );
  }
}
