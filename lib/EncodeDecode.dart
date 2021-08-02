import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class EncodeDecode {
  static StreamController<String> resultStream = StreamController<String>();

  static Future<String?> imageToBase64(Uint8List image) async {
    try {
      String result = base64.encode(image); // returns base64 string
      resultStream.add('');
      return result;
    } catch (e) {
      print('$e');
      resultStream.addError("Error! Failed to convert");
      throw (e);
    }
  }

  static Future<Uint8List?> base64ToImage(String base64String) async {
    try {
      Uint8List result = base64.decode(base64String); // returns base64 string
      resultStream.add('');
      return result;
    } catch (e) {
      print('$e');
      resultStream.addError("Error! Failed to convert");
      throw (e);
    }
  }
}
