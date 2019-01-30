import 'package:flutter/material.dart';
import './rich_link_preview_view.dart';

class RichLinkPreview extends StatefulWidget {
  RichLinkPreview({
      this.link,
      this.height
  });

  final String link;
  final double height;

  @override
  RichLinkPreviewView createState() => RichLinkPreviewView();

}