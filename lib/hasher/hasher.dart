import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';

class QuestionHasher {
  static String encrpter(String text) {
    List<int> stringBytes = utf8.encode(text);
    List<int>? gzipBytes = GZipEncoder().encode(stringBytes);
    String stringEncoded = base64.encode(gzipBytes!);

    return stringEncoded;
  }

  decrypter(String text) {
    Uint8List compressed = base64.decode(text);
    var decrypted = new GZipDecoder().decodeBytes(compressed);

    return utf8.decode(decrypted);
  }
}
