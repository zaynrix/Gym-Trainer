import 'package:easy_localization/easy_localization.dart';
import 'package:gym_app/utils/resources/images_constant.dart';

class PageViewModel {
  final String? imagePath;

  final String title;

  final String bodyText;

  PageViewModel(
      {required this.imagePath, required this.title, required this.bodyText});

  static List<PageViewModel> data = [
    PageViewModel(
      imagePath: ImageApp.backgroundImageFirst,
      title: "headerToOnBoarding1".tr(),
      bodyText: "onBoarding1".tr(),
    ),
    PageViewModel(
      imagePath: ImageApp.backgroundImageSecond,
      title: "headerToOnBoarding2".tr(),
      bodyText: "onBoarding2".tr(),
    ),
    PageViewModel(
      imagePath: ImageApp.backgroundImageThird,
      title: "headerToOnBoarding3".tr(),
      bodyText: "onBoarding2".tr(),
    )
  ];
}
