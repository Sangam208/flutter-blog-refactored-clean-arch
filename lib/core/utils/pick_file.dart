import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> selectFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      debugPrint('Selected file: ${result.files.single.path}');
      return File(result.files.single.path!);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> selectImage() async {
  try {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      return File(xfile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
