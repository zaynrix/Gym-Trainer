import 'package:flutter/material.dart';
import 'package:gym_app/feature/Training/ui/training_screen.dart';
import 'package:gym_app/feature/articles/ui/articles_screen.dart';
import 'package:gym_app/feature/home_screen/ui/home_screen.dart';
import 'package:gym_app/feature/meals_plan/ui/meals_plan_screen.dart';
import 'package:gym_app/feature/profile/ui/profile_screen.dart';
import 'package:gym_app/sheared/widget/CustomSvg.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';
import 'package:gym_app/utils/resources/icons_constant.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BNBUser extends StatelessWidget {
  const BNBUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PersistentTabController controller;
    controller = PersistentTabController(initialIndex: 0);

    List<Widget> _buildScreens() {
      return [
        const HomeScreen(),
        const TrainingScreen(),
        const ArticlesScreen(),
        const MealsPlan(),
        const ProfileScreen(),
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        buildPersistentBottomNavBarItem(
          iconActive: AppIcons.homeSelected,
          iconNonActive: AppIcons.homeUnSelected,
        ),
        buildPersistentBottomNavBarItem(
          iconActive: AppIcons.workOutSelected,
          iconNonActive: AppIcons.workOutUnSelected,
        ),
        buildPersistentBottomNavBarItem(
          iconActive: AppIcons.articles,
          iconNonActive: AppIcons.articles,
        ),
        buildPersistentBottomNavBarItem(
          iconActive: AppIcons.meals,
          iconNonActive: AppIcons.meals,
        ),
        buildPersistentBottomNavBarItem(
          iconActive: AppIcons.profileSelected,
          iconNonActive: AppIcons.profileUnSelected,
        ),
      ];
    }

    return PersistentTabView(
      context,
      controller: controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      handleAndroidBackButtonPress: true, // Default is true.
      resizeToAvoidBottomInset:
          true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
      stateManagement: true, // Default is true.
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: Colors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle:
          NavBarStyle.style3, // Choose the nav bar style with this property
    );
  }

  PersistentBottomNavBarItem buildPersistentBottomNavBarItem({
    required String iconActive,
    required String iconNonActive,
  }) {
    return PersistentBottomNavBarItem(
      icon: CustomSvgAssets(
        path: iconActive,
        color: ColorManager.primary,
      ),
      inactiveIcon: CustomSvgAssets(
        color: Colors.grey,
        path: iconNonActive,
      ),
      activeColorPrimary: ColorManager.primary,
      inactiveColorPrimary: ColorManager.secondary,
    );
  }
}
