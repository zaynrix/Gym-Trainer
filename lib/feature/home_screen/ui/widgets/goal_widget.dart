// Improved GoalWidget
import 'package:flutter/material.dart';
import 'package:gym_app/feature/home_screen/models/goal_model.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget({
    super.key,
    required this.goal,
    required this.isSelected,
    this.isUpdating = false,
  });

  final GoalModel goal;
  final bool isSelected;
  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isSelected ? Colors.black : ColorManager.greyButton,
        border: isUpdating ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              goal.name,
              style: TextStyle(
                color: isSelected ? ColorManager.whiteText : ColorManager.black,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isUpdating) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSelected ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
