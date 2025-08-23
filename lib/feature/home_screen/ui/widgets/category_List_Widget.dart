import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/feature/home_screen/models/categorie_model.dart';
import 'package:gym_app/routes/app_router.dart';
import 'package:gym_app/routes/screen_name.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/utils/resources/font_size.dart';
import 'package:gym_app/utils/resources/style_manger.dart';

class CategoryListWidget extends StatelessWidget {
  final List<CategoryModel> categoryList;

  const CategoryListWidget({Key? key, required this.categoryList}) : super(key: key); // Added const and key

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(
        width: 13,
      ), // Added const
      itemCount: categoryList.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final categoryData = categoryList[index];
        return GestureDetector(
          onTap: () {
            sl<AppRouter>().goTo(
                screenName: ScreenName.fullExercisesScreen,
                object: categoryList[index].id);
          },
          child: Column(
            children: [
              SizedBox( // Changed Container to SizedBox for better performance
                width: 61,
                height: 61,
                child: ClipOval(
                  child: Hero(
                    tag: categoryData,
                    child: CachedNetworkImage(
                      imageUrl: categoryData.image,
                      placeholder: (context, url) =>
                      const CircularProgressIndicator(), // Added const
                      errorWidget: (context, url, error) => const Icon(Icons.error), // Added const
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(categoryData.name,
                    style: StyleManger.bodyText(fontSize: FontSize.s14)),
              ),
            ],
          ),
        );
      },
    );
  }
}
