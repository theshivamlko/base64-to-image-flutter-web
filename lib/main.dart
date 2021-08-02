import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'Base64ToImagePage.dart';
import 'Error404Page.dart';
import 'ImageToBase64Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    Uri url = Uri.parse(html.document.baseUri!);

    return MaterialApp(
        title: 'Base64 Encoder | Navoki.com',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),

        onGenerateRoute: (settings) {

          if (settings.name == '/base64-to-image-online') {
            return MaterialPageRoute(builder: (context) => Base64ToImagePage(),settings: settings);
          } else if (settings.name == '/image-to-base64-online') {
            return MaterialPageRoute(builder: (context) => ImageToBase64Page(),settings: settings);
          }
          return MaterialPageRoute(builder: (context) => HtmlElementView(viewType: Error404Page.create().tagName),settings: settings);
        });
  }
}
