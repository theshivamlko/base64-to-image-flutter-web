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
    print(html.document.domain);
    print(html.document.baseUri);
    Uri url = Uri.parse(html.document.baseUri!);
    print(url.authority);
    print(url.fragment);
    print(url.pathSegments);
    print(url.path);
    print(url.data);
    print(url.query);
    print(url.hasScheme);

    return MaterialApp(
        title: 'Base64 Encoder | Navoki.com',
        theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'OpenSans'),

        onGenerateRoute: (settings) {
          print('onGenerateRoute');
          print(settings.arguments);
          print(settings.name);
          // Handle '/'
          if (settings.name == '/base64-to-image-online') {
            return MaterialPageRoute(builder: (context) => Base64ToImagePage());
          } else if (settings.name == '/image-to-base64-online') {
            return MaterialPageRoute(builder: (context) => ImageToBase64Page());
          }
          return MaterialPageRoute(builder: (context) => HtmlElementView(viewType: Error404Page.create().tagName));
        });
  }
}
