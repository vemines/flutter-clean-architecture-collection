import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CacheImageWidget extends StatelessWidget {
  const CacheImageWidget({super.key, required this.imageUrl, required this.width});
  final String imageUrl;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder:
            (context, imageProvider) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: width,
                  height: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(20),
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
        progressIndicatorBuilder:
            (context, url, downloadProgress) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: width,
                  height: double.maxFinite,
                  decoration: BoxDecoration(color: Colors.black.withAlpha(20)),
                  child: Center(child: const CircularProgressIndicator()),
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Padding(
              padding: const EdgeInsetsDirectional.only(end: 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  width: width,
                  height: double.maxFinite,
                  decoration: BoxDecoration(color: Colors.black.withAlpha(20)),
                  child: const Icon(Icons.error),
                ),
              ),
            ),
      ),
    );
  }
}
