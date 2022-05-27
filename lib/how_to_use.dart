import 'package:flutter/material.dart';
import 'painting_screen.dart';

class HowToUsePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How To Use ?'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 200.0,
            height: 100.0,
            child: ElevatedButton(
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
                //_launchURL;
              },
              child: Text('GIF LINK'),
            ),
          ),
          SizedBox(
            width: 50.0,
            height: 50.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'In This Application, you need to select a photo from library. There are a lot of templates.',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 22.5)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'After you select the template, every area will be selected by hand then in that selected area you are going to think a color and that color will be painted.',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 22.5)),
          ),
        ],
      ),
    );
  }
}
