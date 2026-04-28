import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileHelper {
  static Future<String> downloadFile(String url, String filename) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$filename';

      // Download the file using Dio
      await Dio().download(url, filePath);

      return filePath;
    } catch (e) {
      print("Error downloading file: $e");
      return "";
    }
  }
}
