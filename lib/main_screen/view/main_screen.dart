import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixaby_image_app/image_model.dart';
import 'package:pixaby_image_app/image_view_screen.dart';
import 'package:pixaby_image_app/main_screen/main_screen_bloc/main_screen_bloc.dart';

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
      appBar: AppBar(
        title: const Text('Pixabay Image Gallery'),
      ),
      body: BlocBuilder<MainScreenBloc, MainScreenState>(
        buildWhen: (previous, current) =>
            previous.imageList != current.imageList,
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnsCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: state.imageList.length,
            itemBuilder: (BuildContext context, int index) {
              Hits image = state.imageList[index];
              return GestureDetector(
                onTap: () => _navigateToImageDetail(context, image),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        image.userImageURL.toString(),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Center(child: Text('No Image Found')),
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
        },
      ),
    );
  }

  void _navigateToImageDetail(BuildContext context, Hits image) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(Icons.favorite),
                const SizedBox(width: 4),
                Text("${image.likes}")
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Icon(Icons.visibility),
                SizedBox(width: 4),
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
