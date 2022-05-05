import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:floodfill_image/floodfill_image.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PAINTISTIC',
      theme: ThemeData(
  
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'PAINTISTIC',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


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
            Image.asset('assets/zyro-image.jpg'),
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
              onPressed:() {
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
              onPressed: (){
                _navigateToHowToUsePage(context);
              },
              child: Text('How To Use ?'),
            ),
          ],
        ),
      ), 
    );
  }
  void _navigateToStorePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => StorePage()));
  }
  void _navigateToHowToUsePage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HowToUsePage()));
  }
}
class StorePage extends StatelessWidget {
  List a = [
    "assets/kopek.png",
    "https://cdn.pixabay.com/photo/2016/05/05/02/37/sunset-1373171_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/02/01/22/02/mountain-landscape-2031539_960_720.jpg",
    "https://cdn.pixabay.com/photo/2014/09/14/18/04/dandelion-445228_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/08/09/21/54/yellowstone-national-park-1581879_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/07/11/15/43/pretty-woman-1509956_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/02/13/12/26/aurora-1197753_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/11/08/05/26/woman-1807533_960_720.jpg",
    "https://cdn.pixabay.com/photo/2013/11/28/10/03/autumn-219972_960_720.jpg",
    "https://cdn.pixabay.com/photo/2017/12/17/19/08/away-3024773_960_720.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Selecting From Store'),centerTitle: true),
      body:  ListView.builder(
        itemBuilder: (BuildContext ctx, int index) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              shape:Border.all(width: 5, ),
              elevation: 20,
              color: Colors.black,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/kopek.png'),
                  SizedBox(height: 10,),  
                  new IconButton(
                    icon: new Icon(Icons.favorite),
                    color: Colors.yellow,
                    iconSize: 40,

                    onPressed: () {
                      _navigateToPaintingPage(context,a[index]);
                    },
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: a.length,
      ),
    ); 
  }
  void _navigateToPaintingPage(BuildContext context,String a) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaintingScreen(a)));
  }
}
class HowToUsePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('How To Use ?'),centerTitle: true,),
      body:
        
        Column(
          
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
                onPressed:() {
                  _launchURL;
                },
                child: Text('GIF LINK'),
              ),
            ),
            SizedBox(
              width: 50.0,
              height: 50.0,
            ),
            Text('In This Application, you need to select a photo from library. There are a lot of templates.',style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black.withOpacity(0.6),fontSize: 22.5)), 
            Text('After you select the template, every area will be selected by hand then in that selected area you are going to think a color and that color will be painted.',style:TextStyle(fontStyle: FontStyle.italic,color: Colors.black.withOpacity(0.6),fontSize: 22.5)),
          ],
        ),
     
    );
  }
}
_launchURL() async {
  const url = 'https://flutter.io';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
class PaintingScreen extends StatefulWidget {
  late String b;
  PaintingScreen(String a){
    this.b=a;
  }

  @override
  State<PaintingScreen> createState() => _PaintingScreenState();
}

class _PaintingScreenState extends State<PaintingScreen> {
  Color _fillColor = Colors.amber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PAINTING"),
        centerTitle:true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloodFillImage(
                imageProvider: AssetImage('assets/kopek.png'),
                fillColor: _fillColor,
                avoidColor: [Colors.transparent, Colors.black],
                tolerance: 10,
                width:350 ,
                height:350,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fillColor = Colors.brown;
                      });
                    },
                    child: Text("Brown",style: TextStyle(color: Colors.black),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.brown)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fillColor = Colors.amber;
                      });
                    },
                    child: Text("Amber",style: TextStyle(color: Colors.black),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _fillColor = Colors.cyan;
                      });
                    },
                    child: Text("Cyan",style: TextStyle(color: Colors.black),),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}