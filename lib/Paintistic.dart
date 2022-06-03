import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'PaintingTestScreen.dart';
import 'StorePageTest.dart';
import 'painting_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'select_from_store2.dart';
import 'store_page.dart';
import 'how_to_use.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MyApp extends StatelessWidget {
  final BluetoothDevice server;

  const MyApp({Key? key, required this.server}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PAINTISTIC',
      theme: ThemeData(primaryColor: Colors.black, primarySwatch: Colors.grey),
      home: MyHomePage(title: 'PAINTISTIC', server: server),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final BluetoothDevice server;
  const MyHomePage({Key? key, required this.title, required this.server})
      : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/paintistic logo.jpg'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.amber;
                  return null; // Defer to the widget's default.
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {
                _navigateToStorePage(context);
              },
              child: Text('Select a Photo From Store'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.red;
                  return null; // Defer to the widget's default.
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {
                _navigateToHowToUsePage(context);
              },
              child: Text('How To Use ?'),
            ),
            SizedBox(
              width: 50,
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.red;
                  return null; // Defer to the widget's default.
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {
                _navigateToPaintingTestPage(context, 'path');
              },
              child: Text('Test Mode'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.red;
                  return null; // Defer to the widget's default.
                }),
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.disabled))
                    return Colors.blue;
                  return null; // Defer to the widget's default.
                }),
              ),
              onPressed: () {
                _navigateToStorePage2(context);
              },
              child: Text('Select from store - Multiple color mode'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToStorePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StorePage(server: widget.server)));
  }

  void _navigateToStorePage2(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => StorePage2(server: widget.server)));
  }

  void _navigateToHowToUsePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => HowToUsePage()));
  }

  void _navigateToPaintingTestPage(BuildContext context, String path) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PaintingTestScreen(b: 'title', server: widget.server)));
  }
}
