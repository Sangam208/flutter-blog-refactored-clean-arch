import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/core/theme/app_palette.dart';
import 'package:my_app/core/utils/calculate_reading_time.dart';

class BlogCard extends StatelessWidget {
  final String username;
  final String imageUrl;
  final String title;
  final String content;
  final int index;
  const BlogCard({
    super.key,
    required this.username,
    required this.imageUrl,
    required this.title,
    required this.content,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: index % 3 == 0
          ? AppPalette.appColor1
          : index % 3 == 1
              ? AppPalette.appColor2
              : AppPalette.appColor3,
      child: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(
          top: 3.0,
          bottom: 3.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 3.0,
          children: [
            Row(
              children: [
                Text(
                  username,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.blue.shade100),
                ),
                const Spacer(),
                Text(
                  '• ${calculateReadingTime(content)} min',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              spacing: 10.0,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(12.0),
                  child: SizedBox(
                    height: 80,
                    width: 100,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 28),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
