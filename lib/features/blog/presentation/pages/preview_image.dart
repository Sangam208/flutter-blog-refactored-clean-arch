import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PreviewImage extends StatelessWidget {
  final String imageUrl;
  const PreviewImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preview',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
        minScale: PhotoViewComputedScale.contained, // minimum zoom scale
        maxScale: PhotoViewComputedScale.covered, // maximum zoom scale
        backgroundDecoration: BoxDecoration(
          color: Colors.black, // Set background to black or any color you want
        ),
      ),
    );
  }
}
