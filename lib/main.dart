import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resources/app_config.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.of(context).appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: AppConfig.of(context).appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platform = const MethodChannel("sample.flutter.dev/message");
  String _message = "No message yet!";
  TextEditingController _controller = TextEditingController();
  bool loading = false;

  Future<String> _sendMessage() async {
    var sendMap = <String, String>{
      "from": "Android",
    };
    String message;
    try {
      message = await platform.invokeMethod("sendMessage", sendMap);
    } catch (e) {
      debugPrint(e.message);
    }
    return message;
  }

  @override
  void initState() {
    _sendMessage().then((String message) {
      setState(() {
        _message = message;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Center(
              child: Text(_message),
            ),
            Center(
              child: Text("You are running ${AppConfig.of(context).buildFlavor} flavor."),
            ),
            TextField(
              controller: _controller,
            ),
            RaisedButton(
              child: Text("Add to Firestore"),
              onPressed: _addToFireStore,
            )
          ],
        ),
      ),
    );
  }

  _addToFireStore() async {
      if(_controller.text.isEmpty) return;
      setState(() {
          loading = true;
      });

      await Firestore.instance.collection("my_coll").add({"string" : _controller.text});

      _controller.text = "";

      setState(() {
        loading = false;
      });
  }
}
