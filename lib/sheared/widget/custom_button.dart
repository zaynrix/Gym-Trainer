import 'package:flutter/material.dart';
import 'package:gym_app/sheared/widget/CustomSvg.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';

class CustomButtonWidget extends StatelessWidget {
  const CustomButtonWidget({
    required this.title,
    required this.onPressed,
    super.key,
    this.textColor = ColorManager.white,
    this.isLoading = false,
    this.showIcon = false,
    this.fontSize = 16,
    this.fontWeight,
    this.style,
    this.icon,
    this.loadingColor = Colors.white,
    this.isDisabled = false, // Default value is false
  });

  final void Function() onPressed;
  final String title;
  final Color textColor;
  final Color loadingColor;
  final bool isLoading;
  final bool showIcon;
  final double fontSize;
  final FontWeight? fontWeight;
  final ButtonStyle? style;
  final String? icon;
  final bool isDisabled; // New parameter

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: isLoading || isDisabled
          ? null
          : onPressed, // Disable button if isLoading or isDisabled is true
      child: isLoading
          ? Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: loadingColor),
              ),
            )
          : showIcon
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      if (icon != null) // Ensure icon is not null
                        CustomSvgAssets(
                          path: icon!,
                        ),
                      const Spacer(),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                          fontWeight: fontWeight,
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: fontWeight,
                  ),
                ),
    );
  }
}
