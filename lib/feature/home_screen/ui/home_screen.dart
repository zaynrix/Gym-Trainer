import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' as utilsSize;
import 'package:gym_app/feature/home_screen/models/goal_model.dart';
import 'package:gym_app/feature/home_screen/providers/home_provider.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/category_List_Widget.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/custom_grid_view.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/header_section_widget.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/populer_exercise_widget.dart';
import 'package:gym_app/logic/firebase_constant.dart';
import 'package:gym_app/logic/localData/shared_pref.dart';
import 'package:gym_app/sheared/widget/CustomeSvg.dart';
import 'package:gym_app/sheared/widget/custom_button.dart';
import 'package:gym_app/sheared/widget/main_container.dart';
import 'package:gym_app/utils/extensions/sized_box.dart';
import 'package:gym_app/utils/extensions/time_of_day.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';
import 'package:gym_app/utils/resources/icons_constant.dart';
import 'package:gym_app/utils/resources/images_constant.dart';
import 'package:gym_app/utils/resources/sizes_in_app.dart';
import 'package:gym_app/utils/resources/strings_in_app.dart';
import 'package:gym_app/utils/resources/style_manger.dart';
import 'package:provider/provider.dart';

import '../../../service_locator.dart';
import '../../../utils/resources/font_size.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List iconsGrid = [
    AppIcons.today,
    AppIcons.scan,
    AppIcons.myWorkOut,
    AppIcons.classes,
  ];
  List titleGrid = [
    AppStrings.seaToday,
    AppStrings.dailyAttendance,
    AppStrings.myWorkouts,
    AppStrings.classes,
  ];
  List subTitleGrid = [
    AppStrings.shouldersLegs,
    AppStrings.daysStraight,
    AppStrings.daysCompleted,
    AppStrings.activeClasses,
  ];

  List titleButton = [
    AppStrings.letsDoIt,
    AppStrings.attendNow,
    AppStrings.Continue,
    AppStrings.discover,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = TimeOfDay.now();
    final greeting = currentTime.getGreeting();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        title: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: "${sl<FirebaseAuth>().currentUser?.photoURL}",
                      placeholder: (context, url) => Image.asset(
                        ImageApp.backgroundImageSecond,
                        fit: BoxFit.cover,
                        height: 44,
                        width: 44,
                      ), // Placeholder widget while loading
                      errorWidget: (context, url, error) => Image.asset(ImageApp
                          .backgroundImageSecond), // Display default image on error
                    ),
                  ),
                  backgroundColor: ColorManager.primary,
                ),
                15.addHorizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hello, $greeting ",
                        style: StyleManger.headline4().copyWith(
                            fontSize: FlutterSizes(12).sp,
                            color: ColorManager.white)),
                    Text(
                      "${sl<SharedPrefController>().getUserData().name} !",
                      style: TextStyle(
                          fontSize: FontSize.s20,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.white),
                    ),
                  ],
                ),
              ],
            ),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.10),
            ),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
            CircleAvatar(
              radius: 120,
              backgroundColor: Colors.white.withOpacity(0.1),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              child: CustomSvgAssets(
                path: AppIcons.search,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(left: 8, right: 33),
              child: CustomSvgAssets(
                path: AppIcons.notification,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingHorizontal,
              vertical: AppSizes.paddingVertical,
            ),
            children: [
              HeaderSectionWidget(
                onTap: () {},
                title: AppStrings.selectGoal,
                trailing: AppStrings.seeAll,
              ),
              13.addVerticalSpace,
              SizedBox(
                  height: 35,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: sl<FirebaseFirestore>()
                        .collection(FirebaseConstant.goalsCollection)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.separated(
                        separatorBuilder: (context, index) => SizedBox(
                          width: 13.w,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final goal = GoalModel.fromDocumentSnapshot(
                            snapshot.data!.docs[index],
                          );

                          return GestureDetector(
                            onTap: () {
                              homeProvider.updateUserGoal(goal.id);
                              homeProvider.setSelectedGoal(goal.id);
                              // sl<SharedPrefController>().getUserData()
                              // homeProvider.updateSelectedGoals(goalsData);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: sl<SharedPrefController>()
                                            .getUserData()
                                            .selectedGoal ==
                                        goal.id
                                    ? Colors.black // Highlight selected goal
                                    : ColorManager.greyButton,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  goal.name,
                                  style: TextStyle(
                                      color: sl<SharedPrefController>()
                                                  .getUserData()
                                                  .selectedGoal ==
                                              goal.id
                                          ? ColorManager.whiteText
                                          : ColorManager.black,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )),
              const SizedBox(height: 30),
              HeaderSectionWidget(
                onTap: () {},
                title: AppStrings.category,
                trailing: AppStrings.seeAll,
              ),
              15.addVerticalSpace,
              homeProvider.selectedGoalIdList == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 100.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: sl<FirebaseFirestore>()
                            .collection(FirebaseConstant.categoriesCollection)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final categoryDocs = snapshot.data!.docs;
                          final resultList =
                              homeProvider.filterCategoriesByGoal(categoryDocs,
                                  homeProvider.goalModel!.categorieList);

                          return CategoryListWidget(
                            categoryList: resultList,
                          );
                        },
                      ),
                    ),
              Divider(),
              10.addVerticalSpace,
              HeaderSectionWidget(
                onTap: () {},
                title: AppStrings.popularExercise,
                trailing: AppStrings.seeAll,
              ),
              10.addVerticalSpace,
              StreamBuilder<QuerySnapshot>(
                stream: sl<FirebaseFirestore>()
                    .collection(FirebaseConstant.exercisesCollection)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final categoryDocs = snapshot.data!.docs;
                  final resultList = homeProvider.filterExerciseByGoal(
                      categoryDocs, homeProvider.goalModel!.id);

                  return ListView.separated(
                      itemCount: resultList.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => Divider(),
                      itemBuilder: (context, index) {
                        return PopularExerciseWidget(
                          exerciseModel: resultList[index],
                          // exerciseModel:
                        );
                      });
                },
              ),
              const SizedBox(height: 10),
              CustomGridView(
                image: ImageApp.imageHome,
                title: AppStrings.mountainClimbers,
                subTitle: 'Rounds: 10',
                text: 'Repeats: 10, 8, 8',
                fontWeightToText: FontWeight.w500,
              ),
              const SizedBox(height: 18),
              Text(AppStrings.discoverNewWorkouts,
                  style: StyleManger.headline1()),
              const SizedBox(height: 10),
              CustomGridView(
                image: ImageApp.imageHomes,
                title: 'Cardio',
                subTitle: '🏃🏻‍♂️ 10 Exercises',
                text: '⌛️ 50 Minutes',
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      MainContainer(
                        height: 236,
                        horizontal: AppSizes.paddingContainer,
                        vertical: AppSizes.paddingContainer,
                        child: Column(
                          children: [
                            const Spacer(
                              flex: 3,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppStrings.months,
                                  style: StyleManger.headline2(
                                      color: ColorManager.white),
                                ),
                                Text(
                                  '\$99,99',
                                  style: StyleManger.headline2(
                                      color: ColorManager.white),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.check,
                                    color: ColorManager.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Point Number 1',
                                  style: StyleManger.headline4(
                                      color: ColorManager.white),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Row(
                              children: [
                                const Icon(Icons.check,
                                    color: ColorManager.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Point Number 2',
                                  style: StyleManger.headline4(
                                      color: ColorManager.white),
                                ),
                              ],
                            ),
                            const Spacer(
                              flex: 2,
                            ),
                            CustomButtonWidget(
                              title: AppStrings.moreDetails,
                              onPressed: () {},
                              textColor: ColorManager.primary,
                              fontWeight: FontWeight.w700,
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style
                                  ?.copyWith(
                                    maximumSize: const MaterialStatePropertyAll(
                                        Size(double.infinity, 50)),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            ColorManager
                                                .backGroundButtonSecondary),
                                  ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: MainContainer(
                        width: 153,
                        height: 35,
                        alignment: Alignment.center,
                        color: ColorManager.orange,
                        child: Text(
                          AppStrings.daysStraight,
                          style: StyleManger.bodyText(),
                        )),
                  )
                ],
              ),
              const SizedBox(height: 20)
            ],
          );
        },
      ),
    );
  }
}
