import 'package:flutter/material.dart';
import './rich_link_preview_view.dart';

class RichLinkPreview extends StatefulWidget {
  RichLinkPreview({
      this.link
  });

  final String link;

  @override
  RichLinkPreviewView createState() => RichLinkPreviewView();

}