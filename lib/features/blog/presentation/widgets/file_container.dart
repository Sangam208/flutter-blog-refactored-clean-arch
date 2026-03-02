import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:my_app/core/utils/pick_file.dart';

class FileContainer extends StatefulWidget {
  const FileContainer({super.key});

  @override
  State<FileContainer> createState() => _FileContainerState();
}

class _FileContainerState extends State<FileContainer> {
  PlatformFile? selectedFile;
  File? file;

  void pickFile() async {
    final selectedFile = await selectFile();
    if (selectedFile != null) {
      setState(() {
        file = selectedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickFile(),
      child: file != null
          ? ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: SizedBox(
                width: double.infinity,
                height: 30,
                child: Image.file(
                  file!,
                  fit: BoxFit.cover,
                ),
              ),
            )
          : DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [20, 20],
              strokeWidth: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Upload a file",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black54,
                          ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
