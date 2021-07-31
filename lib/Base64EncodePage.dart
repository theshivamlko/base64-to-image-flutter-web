import 'dart:convert' as convert;
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_to_base64/AppConstant.dart';
import 'package:image_to_base64/Base64Encoder.dart';

class Base64EncodePage extends StatefulWidget {
  const Base64EncodePage({Key? key}) : super(key: key);

  @override
  _Base64EncodePageState createState() => _Base64EncodePageState();
}

class _Base64EncodePageState extends State<Base64EncodePage> {
  html.TextAreaElement plainTextAreaElement = html.TextAreaElement();
  html.TextAreaElement encodedTextAreaElement = html.TextAreaElement();
  html.FileUploadInputElement fileUploadInputElement = html.FileUploadInputElement();

  late Uint8List image = Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Enter the text to Base64 Encode',
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                  ),
                  if (image != null) Image.memory(image) else Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            plainTextAreaElement.value = null;
                            encodedTextAreaElement.value = null;
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: accentIconColor,
                          )),
                      IconButton(
                          onPressed: () {
                            plainTextAreaElement.select();
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
              Padding(padding: EdgeInsets.all(20)),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                        height: 50,
                        color: buttonColor,
                        onPressed: () async {

                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.cached,
                              color: Colors.white,
                            ),
                            Text(
                              "Base64 Encode",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: accentTextColor)),
                        child: MaterialButton(
                          height: 50,
                          color: Colors.white,
                          onPressed: () async {
                            html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                            uploadInput.click();

                            uploadInput.onChange.listen((event) {
                              html.File file = uploadInput.files!.first;
                              html.FileReader reader = html.FileReader();
                              reader.readAsArrayBuffer(file);
                              print('File path ${file.name}');
                              print('File path ${file.relativePath}');
                              print('File path ${file.type}');

                              reader.onLoadEnd.listen((event) {}).onData((data) async {
                                print('File path ${reader.result}');
                                print('File path ${reader.result.runtimeType}');
                                image = reader.result as Uint8List;
                                plainTextAreaElement.value = reader.result.toString();
                                encodedTextAreaElement.value =
                                    await Base64Encoder.imageToBase64(image).catchError((error) {});
                                setState(() {});
                              });
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.upload,
                                color: accentTextColor,
                              ),
                              Padding(padding: EdgeInsets.all(5)),
                              Text(
                                "File Upload",
                                style: TextStyle(color: accentTextColor, fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  StreamBuilder<String>(
                      stream: Base64Encoder.resultStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return Text(
                            snapshot.error.toString(),
                            style: TextStyle(color: errorTextColor),
                          );
                        return Container(
                          height: 1,
                          width: 1,
                        );
                      }),
                ],
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Output Text',
                      style: TextStyle(color: textColor, fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            encodedTextAreaElement.select();
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
              Container(height: 300, child: HtmlElementView(viewType: encodedTextAreaElement.name)),
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: accentTextColor)),
                  child: MaterialButton(
                    height: 50,
                    color: Colors.white,
                    onPressed: () async {
                      if (encodedTextAreaElement.value != null)
                        html.AnchorElement()
                          ..href =
                              '${Uri.dataFromString(encodedTextAreaElement.value!, mimeType: 'text/plain', encoding: convert.utf8)}'
                          ..download = 'base64-encode-navoki.com.txt'
                          ..style.display = 'none'
                          ..click();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.cloud_download_sharp,
                          color: accentTextColor,
                        ),
                        Padding(padding: EdgeInsets.all(5)),
                        Text(
                          "Download",
                          style: TextStyle(color: accentTextColor, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void init() {
    plainTextAreaElement = html.TextAreaElement()..required = true;
    plainTextAreaElement.placeholder = 'Enter text to Encode';
    plainTextAreaElement.name = 'text-area';

    encodedTextAreaElement = html.TextAreaElement()..required = true;
    encodedTextAreaElement.placeholder = 'Encoded data';
    encodedTextAreaElement.name = 'encoded-text-area';

    fileUploadInputElement.name = 'file-upload';

    ui.platformViewRegistry.registerViewFactory(plainTextAreaElement.name, (int id) => plainTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(encodedTextAreaElement.name, (int id) => encodedTextAreaElement);
    ui.platformViewRegistry.registerViewFactory(fileUploadInputElement.name!, (int id) => fileUploadInputElement);
  }
}
