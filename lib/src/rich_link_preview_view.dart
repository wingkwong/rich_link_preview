import 'package:flutter/material.dart';
import './rich_link_preview_model.dart';

class RichLinkPreviewView extends RichLinkPreviewModel {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: [Container(child: buildRichLinkPreviewWidget(context))]));
  }
}
