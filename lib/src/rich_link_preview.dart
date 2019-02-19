import 'package:flutter/material.dart';
import './rich_link_preview_view.dart';

class RichLinkPreview extends StatefulWidget {
  RichLinkPreview(
      {this.link,
      this.height,
      this.borderColor,
      this.textColor,
      this.backgroundColor,
      this.appendToLink,
      this.launchFromLink});

  final String link;
  final double height;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final bool appendToLink;
  final bool launchFromLink;

  @override
  RichLinkPreviewView createState() => RichLinkPreviewView();
}
