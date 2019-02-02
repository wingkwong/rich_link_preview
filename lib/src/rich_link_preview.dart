import 'package:flutter/material.dart';
import './rich_link_preview_view.dart';

class RichLinkPreview extends StatefulWidget {
  RichLinkPreview({
      this.link,
      this.height,
      this.borderColor,
      this.backgroundColor
  });

  final String link;
  final double height;
  final Color borderColor;
  final Color backgroundColor;

  @override
  RichLinkPreviewView createState() => RichLinkPreviewView();

}