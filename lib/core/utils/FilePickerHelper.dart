import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class FilePickerHelper {
  static Future<PlatformFile?> pickFile(List<String> allowedExtensions) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      return result?.files.first;
    } catch (e) {
      debugPrint('File picker error: $e');
      return null;
    }
  }
}