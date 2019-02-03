import 'package:flutter/material.dart';
import 'package:rich_link_preview/rich_link_preview.dart';

void main() => runApp(RichLinkPreviewExample());

class RichLinkPreviewExample extends StatefulWidget {
  @override
  _RichLinkPreviewExampleState createState() =>
      new _RichLinkPreviewExampleState();
}

class _RichLinkPreviewExampleState extends State<RichLinkPreviewExample> {
  TextEditingController _textController = new TextEditingController();
  String _link;

  @override
  void initState() {
    super.initState();
    _textController.addListener(() {
      setState(() {
        _link = _textController.text;
      });
    });
  }

  void _onTextChange(String val) {
    setState(() {
      _link = _textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.green,
          hintColor: Colors.green,
        ),
        home: Scaffold(
            body: Builder(
          builder: (context) => Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Expanded(child: RichLinkPreview(
                      link: 'https://ourland.hk/detail/72e1aeaf-360b-4f45-a528-ef1c5e4d803c',
                      appendToLink: true,
                 )),
                  RichLinkPreview(
                    link: _link,
                      borderColor: Color(0xFFE0E0E0),
                      backgroundColor: Color(0xFFE0E0E0)
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),),
                    controller: _textController,
                      onChanged: (String val) => _onTextChange(val),
                  )
                ],
              )),
        )));
  }
}
