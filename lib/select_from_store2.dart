import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:paintistic_app/select_modal.dart';
import 'painting_screen.dart';
import 'select_modal2.dart';

class StorePage2 extends StatelessWidget {
  late String path;
  final BluetoothDevice server;

  StorePage2({required this.server});
  List a = [
    "assets/kopek.png",
    "assets/at.png",
    "assets/peng.png",
    "assets/balık.png",
    "assets/sonic.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecting From Store'), centerTitle: true),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: a.length,
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              shape: Border.all(
                width: 5,
              ),
              elevation: 20,
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  Image.asset(a[index]),
                  SizedBox(
                    height: 10,
                  ),
                  new IconButton(
                    icon: new Icon(Icons.favorite),
                    color: Colors.yellow,
                    iconSize: 40,
                    onPressed: () {
                      path = a[index];
                      _navigateToSelectModalPage2(context, path);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToSelectModalPage2(
    BuildContext context,
    String path,
  ) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SelectModal2(path, server)));
  }
}
