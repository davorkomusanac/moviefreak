import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuildPosterImage extends StatelessWidget {
  final String imagePath;
  final double height;
  final double width;
  final String resolution;

  const BuildPosterImage({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.resolution = "w185",
  });

  @override
  Widget build(BuildContext context) => Material(
        elevation: 10,
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: SizedBox(
            height: height,
            width: width,
            child: CachedNetworkImage(
              imageUrl: "https://image.tmdb.org/t/p/$resolution/$imagePath",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.green,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('😢'),
                    SizedBox(height: 5),
                    Text(
                      'No image available',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
