import 'package:flutter/material.dart';
import 'package:open_graph_parser/open_graph_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import './rich_link_preview.dart';

abstract class RichLinkPreviewModel extends State<RichLinkPreview>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> position;
  String _link;
  double _height;
  Color _borderColor;
  Color _backgroundColor;
  Color _textColor;
  bool _appendToLink;
  bool _isLink;
  Map _ogData;
  Widget _richLinkPreview;

  Widget buildRichLinkPreviewWidget(BuildContext context) {
    if(_richLinkPreview == null) {
      _richLinkPreview = buildRichLinkPreview(context);
    }

    return _richLinkPreview;
  }

  void getOGData() async {
    Map data = await OpenGraphParser.getOpenGraphData(_link);
    if (data != null) {
      if (this.mounted) {
        setState(() {
          _ogData = data;
        });

        controller = AnimationController(
            vsync: this, duration: Duration(milliseconds: 750));
        position = Tween<Offset>(begin: Offset(0.0, 4.0), end: Offset.zero)
            .animate(
            CurvedAnimation(parent: controller, curve: Curves.bounceInOut));

        controller.forward();
      }
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
    _textColor = widget.textColor ?? Color(0xFF000000);
    _backgroundColor = widget.backgroundColor ?? Color(0xFFE0E0E0);
    _appendToLink = widget.appendToLink ?? false;

    _fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
    if(this.mounted) {
      setState(() {
        _link = oldWidget.link != widget.link ? widget.link : '';
      });
    }
    _fetchData();
  }

  void _fetchData() {
    if (isValidUrl(_link) == true) {
      getOGData();
      _isLink = true;
    } else {
      if(this.mounted) {
        setState(() {
          _ogData = null;
        });
      }
      _isLink = false;
    }
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildRichLinkPreview(BuildContext context) {
    if (_ogData == null) {
      return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: 8, child: _buildUrl(context)),
          ]);
    } else {
      if (_appendToLink == true) {
        return _buildPreviewRow(context);
      } else {
        return (SlideTransition(
            position: position,
            child: Container(
                height: _height,
                decoration: new BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(2.0)),
                    ),
                child: _buildPreviewRow(context))));
      }
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
            ]));
  }

  Widget _buildPreviewRow(BuildContext context) {
    if (_ogData['image'] != null) {
      return Column(
          children: <Widget>[
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                            child: new ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(3.0),
                                    ),
                                child: Image.network(_ogData['image'],
                                    width: 120.0,
                                    height: _height,
                                    fit: BoxFit.fill)))
                      ],
                      )),
              Expanded(
                  flex: 5, child: _buildRichLinkPreviewBody(context, _ogData)),
            ]),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Expanded(flex: 8, child: _buildUrl(context)),
            ])
          ],
          );
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
          child: new Text(
              _ogData['title'],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
              ));
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _buildDescription(BuildContext context) {
    if (_ogData != null && _ogData['description'] != null) {
      return Padding(
          padding: EdgeInsets.all(2.0),
          child: new Text(_ogData['description'],
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: TextStyle(color: _textColor)));
    } else {
      return Container(width: 0, height: 0);
    }
  }

  Widget _buildUrl(BuildContext context) {
    if (_link != '' && _appendToLink == true) {
      return Container(
          decoration: BoxDecoration(
              color: _backgroundColor,
              ),
          child: Padding(
              padding: EdgeInsets.all(5.0),
              child: _isLink == true
                  ? InkWell(
                  child: Text(_link,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: _textColor)),
                  onTap: () => _launchURL(_link))
                  : Text(_link,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(color: _textColor))));
    } else {
      return Container(width: 0, height: 0);
    }
  }
}
