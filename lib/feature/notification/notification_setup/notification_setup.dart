import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/feature/notification/notification_setup/local_notification_service.dart';
import 'package:gym_app/logic/firebase_constant.dart';
import 'package:gym_app/logic/localData/shared_pref.dart';
import 'package:gym_app/routes/app_router.dart';
import 'package:gym_app/routes/screen_name.dart';
import 'package:gym_app/service_locator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  final _sharedPref = sl<SharedPrefController>();

  void oneSignalService() {
    final String? userId = _sharedPref.getUserData().uid;

    // Set debug log level
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);

    // Initialize OneSignal with your app ID
    OneSignal.initialize("f991108f-b663-444a-b789-2060ad99f6b6");

    // Set external user ID if available
    if (userId != null && userId.isNotEmpty) {
      OneSignal.login(userId);
      debugPrint("This is userId ======>>>>>> $userId \n \n \n \n");
    }

    // Request notification permission
    OneSignal.Notifications.requestPermission(true).then((accepted) {
      debugPrint("Accepted permission: $accepted");
    });

    // Handle notifications received in foreground
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("This is in Notification Foreground  =====>>>>>>>>> \n");

      // Create local notification
      createLocalNotification(
          title: event.notification.title ?? "Notification",
          body: event.notification.body ?? "You have a new notification");

      // Save to Firestore
      String timeFormat = DateFormat("hh:mm a").format(DateTime.now());
      int createUniqueId() {
        return DateTime.now().millisecondsSinceEpoch.remainder(100000);
      }

      sl<FirebaseFirestore>()
          .collection(FirebaseConstant.notifications)
          .doc(createUniqueId().toString())
          .set({
        'uId': userId ?? 'anonymous',
        'title': event.notification.title,
        'body': event.notification.body,
        'time': timeFormat,
      });

      // Display the notification
      event.notification.display();
    });

    // Handle notification clicks
    OneSignal.Notifications.addClickListener((event) {
      debugPrint(
          "This is data notification =====>>>>> \n${event.notification.additionalData}");
      sl<AppRouter>().goTo(screenName: ScreenName.notificationScreen);
    });

    // Add permission observer
    OneSignal.Notifications.addPermissionObserver((state) {
      debugPrint("Has permission: $state");
    });

    // Add push subscription observer
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint(
          "Push subscription state: ${state.current.jsonRepresentation()}");
    });
  }

  void disposeOneSignal() {
    // Logout the current user
    OneSignal.logout();
  }

  Future<String?> getUserTokenId() async {
    try {
      // Get the OneSignal user ID
      String? onesignalId = await OneSignal.User.getOnesignalId();
      if (onesignalId != null) {
        debugPrint("OneSignal ID: $onesignalId");
        return onesignalId;
      }

      // Alternatively, get push subscription token
      String? pushToken = OneSignal.User.pushSubscription.token;
      if (pushToken != null) {
        debugPrint("Push Token: $pushToken");
        return pushToken;
      }

      return null;
    } catch (e) {
      debugPrint("Error getting user token: $e");
      return null;
    }
  }

  Future<void> handleSendNotification({
    required String playerId,
    required String title,
    required String desc,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Note: Direct notification sending from client is not recommended for security
      // This should typically be done from your backend server
      debugPrint("Sending notification to player: $playerId");
      debugPrint("Title: $title, Body: $desc");

      // For client-side sending, you would need to use OneSignal's REST API
      // or implement this on your backend server for security
    } catch (e) {
      debugPrint("Error sending notification: $e");
    }
  }

  // Add tags to user
  void addTag(String key, String value) {
    OneSignal.User.addTagWithKey(key, value);
  }

  // Add multiple tags
  void addTags(Map<String, String> tags) {
    OneSignal.User.addTags(tags);
  }

  // Remove tag
  void removeTag(String key) {
    OneSignal.User.removeTag(key);
  }

  // Get all tags
  Future<Map<String, dynamic>> getTags() async {
    return await OneSignal.User.getTags();
  }

  // Set user email
  void setEmail(String email) {
    OneSignal.User.addEmail(email);
  }

  // Remove user email
  void removeEmail(String email) {
    OneSignal.User.removeEmail(email);
  }

  // Set user language
  void setLanguage(String languageCode) {
    OneSignal.User.setLanguage(languageCode);
  }

  // Opt in to push notifications
  void optIn() {
    OneSignal.User.pushSubscription.optIn();
  }

  // Opt out of push notifications
  void optOut() {
    OneSignal.User.pushSubscription.optOut();
  }
}
