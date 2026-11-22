import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> retrieveLostImage() async {
  try {
    final response = await ImagePicker().retrieveLostData();
    final files = response.files;
    return files == null || files.isEmpty ? null : File(files.first.path);
  } catch (e) {
    debugPrint('Restoring selected image failed: $e');
    return null;
  }
}

Future<File?> selectFile() async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return image == null ? null : File(image.path);
  } catch (e) {
    debugPrint('Image selection failed: $e');
    return null;
  }
}
