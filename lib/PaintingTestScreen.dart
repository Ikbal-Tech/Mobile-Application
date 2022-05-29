import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:floodfill_image/floodfill_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:firebase_database/firebase_database.dart';

class PaintingTestScreen extends StatefulWidget {
  late String b;
  late String file;
  late final BluetoothDevice server;
  //final FirebaseApp app;

  PaintingTestScreen(
      {required this.b, required this.file, required this.server});

  PaintingScreen(String a, String file, BluetoothDevice device) {
    this.b = a;
    this.file = file;
    this.server = device;
  }

  @override
  State<PaintingTestScreen> createState() =>
      _PaintingTestScreenState(file_inner: file);
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _PaintingTestScreenState extends State<PaintingTestScreen> {
  Color _fillColor = Colors.amber;
  late String file_inner;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseDatabase referencedatabase = FirebaseDatabase(
      databaseURL:
          'https://bt-without-chat-default-rtdb.europe-west1.firebasedatabase.app/');

  List array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
  List<String> thoughts = List<String>.empty(growable: true);

  late String data_text = "";
  _PaintingTestScreenState({required this.file_inner});

  static final clientID = 0;
  BluetoothConnection? connection;

  List<_Message> messages = List<_Message>.empty(growable: true);
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => (connection?.isConnected ?? false);

  bool isDisconnecting = false;

  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();

    thoughts.clear();
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection!.input!.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref = referencedatabase.refFromURL(
        'https://bt-without-chat-default-rtdb.europe-west1.firebasedatabase.app/');

    final List<Row> list = messages.map((_message) {
      return Row(
        children: <Widget>[
          Container(
            child: Text(
                (text) {
                  return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
                }(_message.text.trim()),
                style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.all(12.0),
            margin: EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
            width: 222.0,
            decoration: BoxDecoration(
                color:
                    _message.whom == clientID ? Colors.blueAccent : Colors.grey,
                borderRadius: BorderRadius.circular(7.0)),
          ),
        ],
        mainAxisAlignment: _message.whom == clientID
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Select color and think, then if it is OK,send data to firebase"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloodFillImage(
                imageProvider: AssetImage(file_inner),
                fillColor: _fillColor,
                avoidColor: [Colors.transparent, Colors.black],
                tolerance: 10,
                width: 350,
                height: 350,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _fillColor = Colors.red;
                        });
                      },
                      child: Text(
                        "Red",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _fillColor = Colors.green;
                        });
                      },
                      child: Text(
                        "Green",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.green)),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _fillColor = Colors.blue;
                        });
                      },
                      child: Text(
                        "Blue",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  send_data_to_firebase();
                },
                child: Text(
                  "Send data to firebase",
                  style: TextStyle(color: Colors.black),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan)),
              ),
              SizedBox(
                width: 50,
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data_text,
                  style: TextStyle(fontSize: 6),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void send_data_to_firebase() {
    if (_fillColor != Colors.amber) {
      int col = 0;
      if (_fillColor.hashCode == Colors.red.hashCode) {
        col = 0;
      }
      if (_fillColor.hashCode == Colors.green.hashCode) {
        col = 1;
      }
      if (_fillColor.hashCode == Colors.blue.hashCode) {
        col = 2;
      }
      //send to firebase, but parse it first

      for (int i = 0; i < thoughts.length; i++) {
        var arr = thoughts[i].split('-');
        for (int k = 0; k < 15; k++) {
          array[k] = int.parse(arr[k]);
        }
        String? key = ref.child('FIRST TRY').push().key;

        ref.child('FIRST TRY').child(key!).set({
          'id': key,
          'N1': array[0],
          'N1': array[0],
          'N2': array[1],
          'N3': array[2],
          'N4': array[3],
          'N5': array[4],
          'N6': array[5],
          'N7': array[6],
          'N8': array[7],
          'N9': array[8],
          'N10': array[9],
          'N11': array[10],
          'N12': array[11],
          'N13': array[12],
          'N14': array[13],
          'N15': array[14],
          'COLOR': col
        });

        /*
        CollectionReference received_ints = firestore.collection('FIRST_TRY');
        received_ints.add({
          'N1': array[0],
          'N2': array[1],
          'N3': array[2],
          'N4': array[3],
          'N5': array[4],
          'N6': array[5],
          'N7': array[6],
          'N8': array[7],
          'N9': array[8],
          'N10': array[9],
          'N11': array[10],
          'N12': array[11],
          'N13': array[12],
          'N14': array[13],
          'N15': array[14],
          'COLOR': col
        });

        */
      }

      thoughts.clear();
    }
/*
    CollectionReference firstryref = firestore.collection('FIRST_TRY');
    List values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

    firstryref.add({
      'N1': 1,
      'N2': 2,
      'N3': 3,
      'N4': 4,
      'N5': 5,
      'N6': 6,
      'N7': 7,
      'N8': 8,
      'N9': 9,
      'N10': 10,
      'N11': 11,
      'N12': 12,
      'N13': 13,
      'N14': 14,
      'N15': 15,
    });

   */
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);

    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
    setState(() {
      data_text = messages.last.text;
      if (_fillColor != Colors.amber) {
        thoughts.add(data_text);
      }
    });
  }
}
