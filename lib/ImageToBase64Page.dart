import 'dart:convert' as convert;
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_to_base64/AppConstant.dart';

import 'EncodeDecode.dart';

class ImageToBase64Page extends StatefulWidget {
  const ImageToBase64Page({Key? key}) : super(key: key);

  @override
  _ImageToBase64PageState createState() => _ImageToBase64PageState();
}

class _ImageToBase64PageState extends State<ImageToBase64Page> {
  html.TextAreaElement base64TextAreaElement = html.TextAreaElement();
  html.TextAreaElement cssTextAreaElement = html.TextAreaElement();
  html.TextAreaElement htmlTextAreaElement = html.TextAreaElement();
  html.TextAreaElement dartTextAreaElement = html.TextAreaElement();
  html.FileUploadInputElement fileUploadInputElement = html.FileUploadInputElement();

  Uint8List image = Uint8List.fromList([]);

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Select Your Image to Convert',
                      style: TextStyle(color: textColor, fontSize: 20),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.only(left: 20),
                    child: MaterialButton(
                      height: 50,
                      color: buttonColor,
                      onPressed: ()  {
                        uploadFile();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload,
                            color: Colors.white,
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Divider(),
              Padding(padding: EdgeInsets.all(20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image.length > 0)
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Image.memory(
                        image,
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
                  Padding(padding: EdgeInsets.all(20)),
                  Flexible(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.height / 2,
                      child: Column(
                        children: [
                          Column(
                            children: [
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
                                            downloadFile(base64TextAreaElement.value!);
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
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Flutter/Dart code',
                                      style: TextStyle(color: textColor, fontSize: 18),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            downloadFile(dartTextAreaElement.value!);
                                          },
                                          icon: Icon(
                                            Icons.cloud_download_sharp,
                                            color: accentIconColor,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            dartTextAreaElement.select();
                                            html.document.execCommand("copy");
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: accentIconColor,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              Container(height: 300, child: HtmlElementView(viewType: dartTextAreaElement.name)),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'HTML <img> code',
                                      style: TextStyle(color: textColor, fontSize: 18),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            downloadFile(htmlTextAreaElement.value!);
                                          },
                                          icon: Icon(
                                            Icons.cloud_download_sharp,
                                            color: accentIconColor,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            htmlTextAreaElement.select();
                                            html.document.execCommand("copy");
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: accentIconColor,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              Container(height: 300, child: HtmlElementView(viewType: htmlTextAreaElement.name)),
                            ],
                          ),
                          Padding(padding: EdgeInsets.all(10)),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'CSS Background Source',
                                      style: TextStyle(color: textColor, fontSize: 18),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            downloadFile(cssTextAreaElement.value!);
                                          },
                                          icon: Icon(
                                            Icons.cloud_download_sharp,
                                            color: accentIconColor,
                                          )),
                                      IconButton(
                                          onPressed: () {
                                            cssTextAreaElement.select();
                                            html.document.execCommand("copy");
                                          },
                                          icon: Icon(
                                            Icons.copy,
                                            color: accentIconColor,
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              Container(height: 300, child: HtmlElementView(viewType: cssTextAreaElement.name)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
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

  Future<void> uploadFile()async {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      html.File file = uploadInput.files!.first;
      html.FileReader reader = html.FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoadEnd.listen((event) {}).onData((data) {
        image = reader.result as Uint8List;
        output();
      });
    });
  }

  Future<void> output() async {
    String? base64 = await EncodeDecode.imageToBase64(image).catchError((error) {});
    base64TextAreaElement.value = base64;
    htmlTextAreaElement.value = """<img src='data:image/png;base64,$base64'/>""";
    cssTextAreaElement.value = """background-image: url(data:image/png;base64,$base64)""";
    dartTextAreaElement.value = """
    import 'dart:convert';
    import 'dart:typed_data';
    
    String base64String='$base64';
    
    Uint8List image = base64.decode(base64String);
    
    return Image.memory(image,
    height: 300);
                              
    """;

    setState(() {});
  }

  void downloadFile(String text) async {
    if (text.isNotEmpty)
      html.AnchorElement()
        ..href = '${Uri.dataFromString(text, mimeType: 'text/plain', encoding: convert.utf8)}'
        ..download = 'image-to-base64-navoki.com.txt'
        ..style.display = 'none'
        ..click();
  }

  void init() {
    cssTextAreaElement = html.TextAreaElement()..required = true;
    cssTextAreaElement.name = 'css-code';

    base64TextAreaElement = html.TextAreaElement()..required = true;
    base64TextAreaElement.name = 'base64String';

    htmlTextAreaElement = html.TextAreaElement()..required = true;
    htmlTextAreaElement.name = 'html-code';

    dartTextAreaElement = html.TextAreaElement()..required = true;
    dartTextAreaElement.name = 'dart-code';

    fileUploadInputElement.name = 'file-upload';

    ui.platformViewRegistry.registerViewFactory(htmlTextAreaElement.name, (int id) => htmlTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(cssTextAreaElement.name, (int id) => cssTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(base64TextAreaElement.name, (int id) => base64TextAreaElement);
    ui.platformViewRegistry.registerViewFactory(fileUploadInputElement.name!, (int id) => fileUploadInputElement);
    ui.platformViewRegistry.registerViewFactory(dartTextAreaElement.name, (int id) => dartTextAreaElement);
  }

  @override
  void dispose() {
    print('dispose ImageToBase64Page.dart');
    EncodeDecode.imageToBase64Stream.close();
    base64TextAreaElement.remove();
    htmlTextAreaElement.remove();
    dartTextAreaElement.remove();
    cssTextAreaElement.remove();
    super.dispose();
  }
}
