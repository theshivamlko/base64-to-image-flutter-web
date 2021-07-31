import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

class Base64Encoder {
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
}
