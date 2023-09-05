import 'package:flutter/material.dart';
import 'package:gym_app/feature/profile/provider/profile_provider.dart';
import 'package:gym_app/feature/profile/ui/widget/cardInProfileWidget.dart';
import 'package:gym_app/feature/profile/ui/widget/profileCardPrimaryWidget.dart';
import 'package:gym_app/routes/app_router.dart';
import 'package:gym_app/routes/screen_name.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/sheared/widget/bottomSheetDedailsWidget.dart';
import 'package:gym_app/sheared/widget/customAppBar.dart';
import 'package:gym_app/sheared/widget/main_container.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';
import 'package:gym_app/utils/resources/sizes_in_app.dart';
import 'package:gym_app/utils/resources/strings_in_app.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ProfileProvider>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.yourProfile,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: AppSizes.paddingVertical,
            horizontal: AppSizes.paddingHorizontal,
          ),
          children: [
            ProfileCardPrimaryWidget(),
            const SizedBox(height: 16),
            MainContainer(
              vertical: 8,
              color: ColorManager.white,
              child: Column(
                children: [
                  CardInProfileWidget(
                    title: AppStrings.memberShipPlan,
                    onTap: () {
                      sl<AppRouter>().goTo(
                          screenName: ScreenName.comingSoonScreen,
                          object: true);
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.unitsOfMeasure,
                    onTap: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          context: context,
                          builder: (context) => BottomSheetDetailsWidget());
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.attendanceHistory,
                    onTap: () {
                      showModalBottomSheet(
                          useSafeArea: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          context: context,
                          builder: (context) => BottomSheetDetailsWidget());
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            MainContainer(
              vertical: 8,
              color: ColorManager.white,
              child: Column(
                children: [
                  CardInProfileWidget(
                    title: AppStrings.myPaymentMethods,
                    onTap: () {
                      sl<AppRouter>().goTo(
                        screenName: ScreenName.comingSoonScreen,
                        object: false,
                      );
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.changeLanguage,
                    onTap: () {
                      sl<AppRouter>()
                          .goTo(screenName: ScreenName.languageScreen);
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.notificationsSettings,
                    onTap: () {
                      sl<AppRouter>().goTo(
                          screenName: ScreenName.notificationSettingScreen);
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.termsConditions,
                    onTap: () {
                      sl<AppRouter>().goTo(
                          screenName: ScreenName.termsAndConditionsScreen);
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.fAQsConditions,
                    onTap: () {
                      sl<AppRouter>().goTo(screenName: ScreenName.fAQScreen);
                    },
                  ),
                  CustomDivider(),
                  CardInProfileWidget(
                    title: AppStrings.logout,
                    onTap: () async {
                      await sl<ProfileProvider>().logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      thickness: 1,
      endIndent: 16,
      indent: 16,
      color: ColorManager.dividerColor,
    );
  }
}
