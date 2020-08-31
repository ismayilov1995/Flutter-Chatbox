import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chatbox/common_widget/platform_alert_widget.dart';

class ResponsiveAlertDialog extends PlatformResponseWidget {
  final String title;
  final String content;
  final String allowBtn;
  final String cancelBtn;

  ResponsiveAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.allowBtn,
      this.cancelBtn});

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _getDialogButtons(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _getDialogButtons(context),
    );
  }

  List<Widget> _getDialogButtons(BuildContext context) {
    final buttons = <Widget>[];
    if (Platform.isIOS) {
      if (cancelBtn != null) {
        buttons.add(CupertinoDialogAction(
          child: Text(cancelBtn),
          onPressed: () => Navigator.pop(context),
        ));
      }
      buttons.add(CupertinoDialogAction(
        child: Text(allowBtn),
        onPressed: () => Navigator.pop(context),
      ));
    } else {
      if (cancelBtn != null) {
        buttons.add(FlatButton(
          child: Text(cancelBtn),
          onPressed: () => Navigator.pop(context),
        ));
      }
      buttons.add(FlatButton(
        child: Text(allowBtn),
        onPressed: () => Navigator.pop(context),
      ));
    }

    return buttons;
  }
}
