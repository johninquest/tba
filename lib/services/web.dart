import 'package:flutter/material.dart';
import 'package:tba/shared/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';

class WebService {
  Future<void> openUrl(String _url, context) async {
    if (!await launch(_url)) showDialog(context: context, builder: (_) => ErrorDialog('Could not launch $_url'));
  }
}
