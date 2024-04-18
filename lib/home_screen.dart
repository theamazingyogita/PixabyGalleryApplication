import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pixaby_image_app/api_key.dart';
import 'package:pixaby_image_app/image_model.dart';
import 'package:pixaby_image_app/image_view_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    int columnsCount = 3;

    if (ResponsiveUtils.isMobile(context)) {
      columnsCount = 2;
    } else if (ResponsiveUtils.isDesktop(context)) {
      columnsCount = 4;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pixabay Image Gallery'),
        ),
        body: FutureBuilder<ImageModel>(
          future: _fetchNetworkCall(), // async work
          builder: (BuildContext context, AsyncSnapshot<ImageModel> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsCount,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data?.hits?.length,
                    itemBuilder: (BuildContext context, int index) {
                      Hits image = snapshot.data?.hits?[index] ?? Hits();
                      return GestureDetector(
                        onTap: () => _navigateToImageDetail(context, image),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                image.userImageURL.toString(),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Text('No Image Found')),
                              ),
                            ),
                            _buildImageInfoRow(image),
                          ],
                        ),
                      );
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  );
                }
            }
          },
        ));
  }

  Future<ImageModel> _fetchNetworkCall() async {
    http.Response response = await http.get(Uri.parse(
        'https://pixabay.com/api/?key=$pixabyApiKey&q=yellow+flowers&image_type=photo&pretty=true'));
    if (response.statusCode == 200) {
      ImageModel imageModel = ImageModel.fromJson(jsonDecode(response.body));
      return imageModel;
    }
    return ImageModel();
  }

  void _navigateToImageDetail(BuildContext context, Hits image) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
            ),
            child: FadeTransition(
              opacity: animation,
              child: ImageViewScreen(
                imageTitle: image.user.toString(),
                imageUrl: image.userImageURL.toString(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageInfoRow(Hits image) {
    return Container(
      width: double.infinity,
      color: Colors.white.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.favorite),
                const SizedBox(width: 4),
                Text("${image.likes}")
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.visibility),
                const SizedBox(width: 4),
                Text(
                  "${image.views}",
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ResponsiveUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600 &&
      MediaQuery.of(context).size.width <= 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > 1200;
}
