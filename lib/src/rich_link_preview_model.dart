import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_graph_parser/open_graph_parser.dart';
import './rich_link_preview.dart';

abstract class RichLinkPreviewModel extends State<RichLinkPreview>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;
  String _link;
  double _height;
  Color _borderColor;
  Color _backgroundColor;
  Map _ogData;

  void getOGData() async {
    Map data = await OpenGraphParser.getOpenGraphData(_link);
    if (data != null) {
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
    } else {
      setState(() {
        _ogData = null;
      });
    }
  }

  @override
  void initState() {
    _link = widget.link ?? '';
    _height = widget.height ?? 100.0;
    _borderColor = widget.borderColor ?? Color(0xFFE0E0E0);
    _backgroundColor = widget.backgroundColor ?? Color(0xFFE0E0E0);

    super.initState();
  }

  bool isValidUrl(link) {
    String regexSource =
        "^(https?)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]";
    final regex = RegExp(regexSource);
    final matches = regex.allMatches(link);
    for (Match match in matches) {
      if (match.start == 0 && match.end == link.length) {
        return true;
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(RichLinkPreview oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _link = oldWidget.link != widget.link ? widget.link : '';
    });

    if (isValidUrl(_link) == true) {
      getOGData();
    } else {
      setState(() {
        _ogData = null;
      });
    }
  }

  Widget buildRichLinkPreview(BuildContext context) {
    if (_ogData == null) {
      return Container(width: 0, height: 0);
    } else {
      return (SlideTransition(
          position: position,
          child: Container(
              //margin: const EdgeInsets.only(bottom: 2.0),
              height: _height,
              decoration: new BoxDecoration(
                //border: new Border.all(color: Colors.blueAccent)
                borderRadius:
                    const BorderRadius.all(const Radius.circular(2.0)),
              ),
              child: _buildPreviewRow(context))));
    }
  }

  Widget _buildRichLinkPreviewBody(BuildContext context, Map _ogData) {
    return Container(
        padding: const EdgeInsets.all(3.0),
        height: _height,
        decoration: BoxDecoration(
          color: _backgroundColor,
          border: Border(
            top: BorderSide(width: 2.0, color: _borderColor),
            left: BorderSide(width: 0.0, color: _borderColor),
            right: BorderSide(width: 2.0, color: _borderColor),
            bottom: BorderSide(width: 2.0, color: _borderColor),
          ),
        ),
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTitle(context),
              _buildDescription(context),
              _buildUrl(context)
            ]));
  }

  Widget _buildPreviewRow(BuildContext context) {
    if (_ogData != null && _ogData['image'] != null) {
      return Row(
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
                                topLeft: Radius.circular(3.0),
                                bottomRight: Radius.circular(3.0)),
                            child: Image.network(_ogData['image'],
                                width: 120.0,
                                height: _height,
                                fit: BoxFit.fill)))
                  ],
                )),
            Expanded(
                flex: 5, child: _buildRichLinkPreviewBody(context, _ogData)),
          ]);
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[_buildRichLinkPreviewBody(context, _ogData)],
      );
    }
  }

  Widget _buildTitle(BuildContext context) {
    if (_ogData != null && _ogData['title'] != null) {
      return Padding(
          padding: EdgeInsets.all(1.0),
          child: new Text(_ogData['title'],
              style: TextStyle(fontWeight: FontWeight.bold)));
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _buildDescription(BuildContext context) {
    if (_ogData != null && _ogData['description'] != null) {
      return Padding(
          padding: EdgeInsets.all(2.0),
          child: new Text(
            _ogData['description'],
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ));
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _buildUrl(BuildContext context) {
    if (_ogData != null && _ogData['url'] != null) {
      return Padding(
          padding: EdgeInsets.all(2.0),
          child: new Text(
            _ogData['url'],
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ));
    } else {
      return Container(width: 0, height: 0);
    }
  }
}
