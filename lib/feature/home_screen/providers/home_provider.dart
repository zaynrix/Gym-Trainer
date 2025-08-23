// Improved HomeProvider - Fixed state management issues
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_app/feature/home_screen/models/categorie_model.dart';
import 'package:gym_app/feature/home_screen/models/exercise_model.dart';
import 'package:gym_app/feature/home_screen/models/goal_model.dart';
import 'package:gym_app/feature/registrations/model/user_model.dart';
import 'package:gym_app/logic/firebase_constant.dart';
import 'package:gym_app/logic/localData/shared_pref.dart';
import 'package:gym_app/service_locator.dart';

class HomeProvider extends ChangeNotifier {
  // State variables
  UserModel? _user;
  String? _selectedGoal;
  List<String> _selectedGoalIdList = [];
  GoalModel? _goalModel;
  CategoryModel? _categoryModel;
  bool _isAdditional = false;
  bool _isShow = false;
  String _searchData = "";

  // Exercise related state
  ExerciseModel? _trainingExerciseModel;
  List<ExerciseModel>? _exerciseDetailsList;
  List<ExerciseModel>? _exerciseResult;
  List<ExerciseModel>? _upNextList;
  int _currentIndex = 0;
  final CountDownController _countDownController = CountDownController();

  // Loading states
  bool _isLoadingUserData = false;
  bool _isUpdatingGoal = false;

  // Getters
  UserModel? get user => _user;
  String? get selectedGoal => _selectedGoal;
  List<String> get selectedGoalIdList => _selectedGoalIdList;
  GoalModel? get goalModel => _goalModel;
  CategoryModel? get categoryModel => _categoryModel;
  bool get isAdditional => _isAdditional;
  bool get isShow => _isShow;
  String get searchData => _searchData;
  ExerciseModel? get trainingExerciseModel => _trainingExerciseModel;
  List<ExerciseModel>? get exerciseDetailsList => _exerciseDetailsList;
  List<ExerciseModel>? get exerciseResult => _exerciseResult;
  List<ExerciseModel>? get upNextList => _upNextList;
  int get currentIndex => _currentIndex;
  CountDownController get countDownController => _countDownController;
  bool get isLoadingUserData => _isLoadingUserData;
  bool get isUpdatingGoal => _isUpdatingGoal;

  // Initialize user data
  Future<void> initUserData() async {
    _isLoadingUserData = true;
    notifyListeners();

    try {
      _user = sl<SharedPrefController>().getUserData();
      _selectedGoal = _user?.selectedGoal;

      if (_selectedGoal != null && _selectedGoal!.isNotEmpty) {
        await updateUserGoal(_selectedGoal!);
      }
    } catch (e) {
      debugPrint('Error initializing user data: $e');
    } finally {
      _isLoadingUserData = false;
      notifyListeners();
    }
  }

  // Update user goal with better error handling
  Future<void> updateUserGoal(String newGoalId) async {
    if (newGoalId.isEmpty || _user?.uid == null) {
      debugPrint('Error: newGoalId is empty or user uid is null');
      return;
    }

    _isUpdatingGoal = true;
    notifyListeners();

    try {
      // Update Firestore
      await sl<FirebaseFirestore>()
          .collection(FirebaseConstant.usersCollection)
          .doc(_user!.uid)
          .update({FirebaseConstant.goal: newGoalId});

      // Get goal data
      await getGoalData(newGoalId);

      // Update local user model
      final currentUser = sl<SharedPrefController>().getUserData();
      final updatedUser = currentUser.copyWith(selectedGoal: newGoalId);

      sl<SharedPrefController>().saveUserData(updatedUser);

      _selectedGoal = newGoalId;
      _user = updatedUser;
    } catch (e) {
      debugPrint('Error updating user goal: $e');
      // Could add error state here for UI feedback
    } finally {
      _isUpdatingGoal = false;
      notifyListeners();
    }
  }

  // Get goal data
  Future<void> getGoalData(String goalId) async {
    try {
      final doc = await sl<FirebaseFirestore>()
          .collection(FirebaseConstant.goalsCollection)
          .doc(goalId)
          .get();

      if (doc.exists) {
        _goalModel = GoalModel.fromDocumentSnapshot(doc);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getting goal data: $e');
    }
  }

  // Get category name
  Future<void> getCategoryName(String catId) async {
    try {
      final doc = await sl<FirebaseFirestore>()
          .collection(FirebaseConstant.categoriesCollection)
          .doc(catId)
          .get();

      if (doc.exists) {
        _categoryModel = CategoryModel.fromDocumentSnapshot(doc);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error getting category data: $e');
    }
  }

  // Filter categories by goal
  List<CategoryModel> filterCategoriesByGoal(
      List<DocumentSnapshot> categoryDocs, List<dynamic> goalCategoryList) {
    final categoryList =
        categoryDocs.map((e) => CategoryModel.fromDocumentSnapshot(e)).toList();

    return categoryList
        .where((element) => goalCategoryList.contains(element.id))
        .toList();
  }

  // Filter exercise by goal
  List<ExerciseModel> filterExerciseByGoal(
      List<DocumentSnapshot> exerciseDocs, String? goalId) {
    if (goalId == null) return [];

    final exerciseList =
        exerciseDocs.map((e) => ExerciseModel.fromDocumentSnapshot(e)).toList();

    return exerciseList.where((element) => goalId == element.goalId).toList();
  }

  // Set exercise details list
  void setExerciseDetailsList(List<ExerciseModel> newList) {
    _exerciseDetailsList = List.from(newList);
    // notifyListeners();
  }

  // Filter exercise by goal and category
  List<ExerciseModel> filterExerciseByGoalAndCategory({
    required List<DocumentSnapshot> exerciseDocs,
    required String goalId,
    required String categoryId,
  }) {
    final exerciseList =
        exerciseDocs.map((e) => ExerciseModel.fromDocumentSnapshot(e)).toList();

    return exerciseList
        .where((element) =>
            goalId == element.goalId && categoryId == element.categoryId)
        .toList();
  }

  // Save scroll position
  void saveScrollPosition(double scrollPosition) {
    debugPrint("Scroll position: $scrollPosition");
    sl<SharedPrefController>().setPosition(scrollPosition);
  }

  // Set training exercise
  void setTrainingExercise(ExerciseModel? exerciseModel) {
    _trainingExerciseModel = exerciseModel;
    if (exerciseModel != null) {
      debugPrint("Training exercise: ${exerciseModel.title}");
    }
    notifyListeners();
  }

  // Set exercise list
  void setExerciseList(List<ExerciseModel> newList) {
    _exerciseResult = List.from(newList);
    _upNextList?.clear();
    _currentIndex = 0;

    if (_exerciseResult!.isNotEmpty) {
      _currentIndex = (_currentIndex + 1) % _exerciseResult!.length;
      _upNextList = List.from(_exerciseResult!);
      _upNextList?.removeAt(_currentIndex);
    }
    notifyListeners();
  }

  // Play/Stop countdown
  void playStop() {
    if (_countDownController.isPaused == true) {
      _countDownController.resume();
    } else {
      _countDownController.pause();
    }
    notifyListeners();
  }

  // Next target exercise
  void nextTarget(List<ExerciseModel> exerciseResult) {
    if (exerciseResult.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % exerciseResult.length;
    final nextExercise = exerciseResult[_currentIndex];
    final exerciseTime = int.parse(nextExercise.time ?? '0') * 60;

    _countDownController.restart(duration: exerciseTime);
    _countDownController.pause();

    _upNextList = List<ExerciseModel>.from(exerciseResult)
      ..removeAt(_currentIndex);

    notifyListeners();
  }

  // Toggle search visibility
  void showSearch() {
    _isShow = !_isShow;
    if (!_isShow) {
      _searchData = ""; // Clear search when hiding
    }
    notifyListeners();
  }

  // Update search data
  void showSearchResult(String search) {
    _searchData = search;
    notifyListeners();
  }

  // Change additional flag
  void changeAdditional(bool newValue) {
    _isAdditional = newValue;
    notifyListeners();
  }

  @override
  void dispose() {
    // The CountDownController doesn't have a dispose method
    // but we can dispose its ValueNotifiers to prevent memory leaks
    _countDownController.isStarted.dispose();
    _countDownController.isPaused.dispose();
    _countDownController.isResumed.dispose();
    _countDownController.isRestarted.dispose();
    super.dispose();
  }
}
