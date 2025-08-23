import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/routes/app_router.dart';
import 'package:gym_app/routes/screen_name.dart';
import 'package:gym_app/service_locator.dart';
import 'package:gym_app/sheared/widget/CustomSvg.dart';
import 'package:gym_app/sheared/widget/custom_button.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';
import 'package:gym_app/utils/resources/font_size.dart';
import 'package:gym_app/utils/resources/icons_constant.dart';
import 'package:gym_app/utils/resources/sizes_in_app.dart';
import 'package:gym_app/utils/resources/strings_in_app.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({Key? key}) : super(key: key);

  Future<void> _openEmailApp(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '', // You can add a default email address here if needed
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showNoMailAppsDialog(context);
      }
    } catch (e) {
      _showNoMailAppsDialog(context);
    }
  }

  void _showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content:
              const Text("No mail apps available or unable to open mail app"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSizes.paddingHorizontal),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.1,
            ),
            Container(
              height: 38,
              width: 56,
              decoration: BoxDecoration(
                  color: ColorManager.black,
                  borderRadius: BorderRadius.circular(8)),
              child: CustomSvgAssets(
                path: AppIcons.verify,
                width: 46,
                height: 44,
                color: ColorManager.white,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              checkYourMail.tr(),
              style: TextStyle(
                fontSize: FontSize.s22,
                fontWeight: FontWeight.w700,
                color: ColorManager.primaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'We have sent a password recover instructions to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FontSize.s15,
                color: ColorManager.secondaryTextColor,
              ),
            ),
            const SizedBox(height: 24),
            CustomButtonWidget(
              title: openEmail.tr(),
              onPressed: () => _openEmailApp(context),
            ),
            const SizedBox(height: 16),
            CustomButtonWidget(
              title: iConfirmLatter.tr(),
              textColor: ColorManager.gray,
              fontSize: 14,
              onPressed: () {
                sl<AppRouter>()
                    .goToAndRemove(screenName: ScreenName.loginScreen);
              },
            )
          ],
        ),
      ),
    );
  }
}
