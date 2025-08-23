// Improved GoalList Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_app/feature/home_screen/models/goal_model.dart';
import 'package:gym_app/feature/home_screen/providers/home_provider.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/goal_widget.dart';
import 'package:provider/provider.dart';

class GoalList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;

  const GoalList({
    required this.snapshot,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text('No goals available'),
      );
    }

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return ListView.separated(
          separatorBuilder: (context, index) => SizedBox(width: 13.w),
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final goal = GoalModel.fromDocumentSnapshot(
              snapshot.data!.docs[index],
            );

            return GestureDetector(
              onTap: homeProvider.isUpdatingGoal
                  ? null // Disable tap while updating
                  : () => homeProvider.updateUserGoal(goal.id),
              child: GoalWidget(
                goal: goal,
                isSelected: homeProvider.selectedGoal == goal.id,
                isUpdating: homeProvider.isUpdatingGoal &&
                    homeProvider.selectedGoal == goal.id,
              ),
            );
          },
        );
      },
    );
  }
}
