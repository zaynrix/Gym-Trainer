import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_app/feature/home_screen/models/exercise_model.dart';
import 'package:gym_app/feature/home_screen/providers/home_provider.dart';
import 'package:gym_app/feature/home_screen/ui/widgets/horizontal_exercise_widget.dart';
import 'package:gym_app/logic/firebase_constant.dart';
import 'package:gym_app/utils/resources/strings_in_app.dart';
import 'package:provider/provider.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) =>
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(FirebaseConstant.exercisesCollection)
            .where(
              FirebaseConstant.title,
              isGreaterThanOrEqualTo: value.searchData,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Fixed const
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Center(
                child: Text('${noItems.tr()}( ${value.searchData} )'),
              ),
            ); // Fixed Container to SizedBox
          }

          final docs = snapshot.data!.docs;

          return value.searchData.trim().isEmpty || value.searchData.isEmpty
              ? const SizedBox.shrink() // Added const
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.transparent,
                    ), // Added const
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final exercise = ExerciseModel.fromDocumentSnapshot(doc);

                      return GestureDetector(
                        onTap: () {
                          // Add navigation logic here if needed
                        },
                        child: HorizontalExerciseWidget(
                          exerciseModel: exercise,
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
