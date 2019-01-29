import 'package:flutter/material.dart';
import './rich_link_preview_model.dart';

class RichLinkPreviewView extends RichLinkPreviewModel {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              height: 100.0,
              decoration: new BoxDecoration (
                color: Colors.green,
                borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
            ),
            child: buildRichLinkPreview(context)
          )
        ]
      )
    );
  }
}