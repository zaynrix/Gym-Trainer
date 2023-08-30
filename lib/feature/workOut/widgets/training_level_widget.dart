import 'package:flutter/material.dart';
import 'package:gym_app/feature/home_screen/models/exercise_model.dart';
import 'package:gym_app/feature/workOut/providers/training_provider.dart';
import 'package:gym_app/utils/resources/colors_manger.dart';
import 'package:provider/provider.dart';

class TrainingLevelWidget extends StatelessWidget {
  final Level? level;
  const TrainingLevelWidget({
    this.level,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TrainingProvider>(
      builder: (context, trainingProvider, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: trainingProvider.selectedLevel == level?.index.toString()
              ? Colors.black // Highlight selected goal
              : ColorManager.greyButton,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${level?.name}",
            style: TextStyle(
                color: trainingProvider.selectedLevel == level?.index.toString()
                    ? ColorManager.white
                    : ColorManager.black,
                fontSize: 14),
          ),
        ),
      ),
    );
  }
}