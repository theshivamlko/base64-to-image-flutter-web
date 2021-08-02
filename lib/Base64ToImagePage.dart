import 'dart:convert' as convert;
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_to_base64/AppConstant.dart';

import 'EncodeDecode.dart';

class Base64ToImagePage extends StatefulWidget {
  const Base64ToImagePage({Key? key}) : super(key: key);

  @override
  _Base64ToImagePageState createState() => _Base64ToImagePageState();
}

class _Base64ToImagePageState extends State<Base64ToImagePage> {
  html.TextAreaElement base64TextAreaElement = html.TextAreaElement();
  html.TextAreaElement cssTextAreaElement = html.TextAreaElement();
  html.TextAreaElement htmlTextAreaElement = html.TextAreaElement();
  html.TextAreaElement dartTextAreaElement = html.TextAreaElement();
  html.FileUploadInputElement fileUploadInputElement = html.FileUploadInputElement();

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Enter Base64 String to Convert',
                      style: TextStyle(color: textColor, fontSize: 20),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Divider(),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Base64 String',
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            downloadTextFile(base64TextAreaElement.value!);
                          },
                          icon: Icon(
                            Icons.cloud_download_sharp,
                            color: accentIconColor,
                          )),
                      IconButton(
                          onPressed: () {
                            base64TextAreaElement.select();
                            html.document.execCommand("copy");
                          },
                          icon: Icon(
                            Icons.copy,
                            color: accentIconColor,
                          )),
                    ],
                  ),
                ],
              ),
              Container(height: 300, child: HtmlElementView(viewType: base64TextAreaElement.name)),
              Padding(padding: EdgeInsets.all(10)),
              StreamBuilder<Uint8List>(
                  stream: EncodeDecode.base64ToImageStream.stream,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              height: 50,
                              color: buttonColor,
                              onPressed: () async {
                                output();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cached,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "Generate Image",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(20)),
                            Container(
                              decoration:
                                  BoxDecoration(color: Colors.white, border: Border.all(color: accentTextColor)),
                              child: MaterialButton(
                                height: 50,
                                color: Colors.white,
                                onPressed: () {
                                  if(snapshot.hasData)
                                  downloadImage(snapshot.data!);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: accentTextColor,
                                    ),
                                    Padding(padding: EdgeInsets.all(5)),
                                    Text(
                                      "Download Image",
                                      style: TextStyle(color: accentTextColor, fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(10)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (snapshot.hasData)
                              Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Image.memory(
                                  snapshot.data!,
                                  height: 300,
                                ),
                              )
                            else
                              Container(
                                alignment: Alignment.topCenter,
                                height: 300,
                                width: 300,
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      color: accentColor,
                                      size: 200,
                                    ),
                                    Text(
                                      'Image Preview',
                                      style: TextStyle(color: textColor, fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                          ],
                        )
                      ],
                    );
                  }),
              Padding(padding: EdgeInsets.all(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void downloadImage(Uint8List image) {

    html.AnchorElement anchor = html.document.createElement('a') as html.AnchorElement
      ..href = 'data:image/jpeg;base64,${base64TextAreaElement.value}'
      ..style.display = 'none'
      ..download = 'image.png';
    html.document.body!.children.add(anchor);

    anchor.click();

// cleanup
    html.document.body!.children.remove(anchor);

  }

  void downloadTextFile(String text) async {
    if (text.isNotEmpty)
      html.AnchorElement()
        ..href = '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: convert.utf8)}'
        ..download = 'image-to-base64-navoki.com.txt'
        ..style.display = 'none'
        ..click();
  }

  void output() {
    print('start convert');
    if (base64TextAreaElement.value!.trim().isNotEmpty) EncodeDecode.base64ToImage(base64TextAreaElement.value!);
  }

  void init() {
    base64TextAreaElement = html.TextAreaElement()..required = true;
    base64TextAreaElement.name = 'base64String';

    base64TextAreaElement.onInput.listen((event) {
      output();
    });

    fileUploadInputElement.name = 'file-upload';

    ui.platformViewRegistry.registerViewFactory(htmlTextAreaElement.name, (int id) => htmlTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(cssTextAreaElement.name, (int id) => cssTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(base64TextAreaElement.name, (int id) => base64TextAreaElement);
    ui.platformViewRegistry.registerViewFactory(fileUploadInputElement.name!, (int id) => fileUploadInputElement);
    ui.platformViewRegistry.registerViewFactory(dartTextAreaElement.name, (int id) => dartTextAreaElement);
  }

  @override
  void dispose() {
    print('dispose Base64ToImagePage.dart');
    EncodeDecode.base64ToImageStream.close();
    base64TextAreaElement.remove();
    super.dispose();
  }
}
