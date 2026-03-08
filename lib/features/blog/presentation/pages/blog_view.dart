import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_palette.dart';
import 'package:my_app/core/utils/calculate_reading_time.dart';

class BlogView extends StatelessWidget {
  final String title;
  final String content;
  final String imageUrl;
  final String username;
  final String updatedAt;
  const BlogView({
    super.key,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.username,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 169, 169),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 240, 160, 160),
        title: Text(
          'Discover',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(color: const Color.fromARGB(255, 145, 51, 51)),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12.0),
                child: CachedNetworkImage(
                  width: double.infinity,
                  height: 300,
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '— $username . $updatedAt . ${calculateReadingTime(content)} min',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: AppPalette.appColor1),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                content,
                softWrap: true,
                maxLines: null,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 2,
                    ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
