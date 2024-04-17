import 'package:flutter/material.dart';

class ImageViewScreen extends StatelessWidget {
  final String imageUrl;
  final String imageTitle;

  const ImageViewScreen({
    Key? key,
    required this.imageUrl,
    required this.imageTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          imageTitle,
        ),
      ),
      body: Center(
        child: Image.network(imageUrl),
      ),
    );
  }
}
