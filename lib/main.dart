import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'Base64EncodePage.dart';
import 'Error404Page.dart';

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
       // initialRoute: '/image_to_base64',
       /* routes: {
          '/image_to_base64': (context) => Base64EncodePage(),
        },*/
        onGenerateRoute: (settings) {
          print('onGenerateRoute');
          print(settings.arguments);
          print(settings.name);
          // Handle '/'
          if (settings.name == '/') {
            print('ERROR');
        //    return MaterialPageRoute(builder: (context) => HtmlElementView(viewType: Error404Page.create().tagName));
            return MaterialPageRoute(builder: (context) => Base64EncodePage());
          }

          print('Base64EncodePage');
       //   return MaterialPageRoute(builder: (context) => HtmlElementView(viewType: Error404Page.create().tagName));
          return MaterialPageRoute(builder: (context) => Base64EncodePage());
        }
        /*     home: html.document.domain!.isNotEmpty
  //    home: html.document.domain==domain
          ? Base64EncodePage()
          : HtmlElementView(viewType: Error404Page.create().tagName),*/
        );
  }
}
