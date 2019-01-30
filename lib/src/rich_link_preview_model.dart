import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_graph_parser/open_graph_parser.dart';
import './rich_link_preview.dart';

abstract class RichLinkPreviewModel extends State<RichLinkPreview>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;
  String _link;
  double _height;
  Map _ogData;

  getOGData() async {
    var data = await OpenGraphParser.getOpenGraphData(_link).then((data) {
      setState(() {
        _ogData = data;
        print(_ogData);
      });

      controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 750));
      position = Tween<Offset>(begin: Offset(0.0, 4.0), end: Offset.zero)
          .animate(
              CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

      controller.forward();
    });
  }

  @override
  void initState() {
    super.initState();
    _link = widget.link ?? '';
    _height = widget.height ?? 100.0;
    getOGData();
  }

  void _onLinkChange(String link) {}

  Widget buildRichLinkPreview(BuildContext context) {
    if (_ogData == null) {
      return (null);
    } else {
      return (SlideTransition(
          position: position,
          child: Container(
              height: _height,
              decoration: new BoxDecoration(
                color: Colors.green,
                borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0)),
              ),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                                child: new ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                    child: Image.network(
                                        _ogData['image:secure_url'],
                                        width: 120.0,
                                        height: _height,
                                        fit: BoxFit.fill)))
                          ],
                        )),
                    Expanded(
                        flex: 5,
                        child: _buildRichLinkPreviewBody(context, _ogData)),
                  ]))));
    }
  }

  Widget _buildRichLinkPreviewBody(BuildContext context, Map _ogData) {
    return (Container(
        height: _height,
        color: Colors.yellow,
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(1.0),
                  child: new Text(_ogData['title'])),
              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: new Text(
                    _ogData['description'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )),
              Padding(
                  padding: EdgeInsets.all(2.0),
                  child: new Text(
                    _ogData['url'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ))
            ])));
  }
}
