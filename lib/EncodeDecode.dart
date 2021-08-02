import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class EncodeDecode {
  static StreamController<String> imageToBase64Stream = StreamController<String>();
  static StreamController<Uint8List> base64ToImageStream = StreamController<Uint8List>();

  static Future<String?> imageToBase64(Uint8List image) async {
    try {
      String result = base64.encode(image); // returns base64 string
      imageToBase64Stream.add('');
      return result;
    } catch (e) {

      imageToBase64Stream.addError("Error! Failed to convert");
      throw (e);
    }
  }

  static Future<Uint8List?> base64ToImage(String base64String) async {
    try {
      Uint8List result = base64.decode(base64String); // returns base64 string
      base64ToImageStream.add(result);

    } catch (e) {
      print('base64ToImage $e');
      base64ToImageStream.addError("Error! Failed to convert");
      throw (e);
    }
  }
}
