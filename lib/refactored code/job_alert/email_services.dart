
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseFunctions functions = FirebaseFunctions.instance;
  final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();


  Future<void> initialize() async {

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await localNotifications.initialize(initializationSettings);
  }


  Future<void> processJobAlerts(List<dynamic> newJobs) async {
    final alertsSnapshot = await fireStore.collection('jobAlerts').get();

    for (var doc in alertsSnapshot.docs) {
      final alert = doc.data();
      final matchingJobs = findMatchingJobs(newJobs, alert);

      if (matchingJobs.isNotEmpty) {
        if (alert['emailNotification']) {
          await triggerEmailNotification(alert, matchingJobs);
        }
        if (alert['appNotification']) {
          await sendAppNotification(alert, matchingJobs);
        }
      }
    }
  }


  List<dynamic> findMatchingJobs(List<dynamic> jobs, Map<String, dynamic> alert) {
    final titleFilter = alert['jobTitle']?.toLowerCase() ?? '';
    final locationFilter = alert['location']?.toLowerCase() ?? '';

    return jobs.where((job) {
      final title = job['jobTitle']?.toLowerCase() ?? '';
      final location = job['location']?.toLowerCase() ?? '';
      return title.contains(titleFilter) && location.contains(locationFilter);
    }).toList();
  }

  // Trigger email notification through Cloud Functions
  Future<void> triggerEmailNotification(
      Map<String, dynamic> alert,
      List<dynamic> matchingJobs,
      ) async {


    try {
      final HttpsCallable result = await FirebaseFunctions.instance
          .httpsCallable('sendJobAlerts'); // Call the Cloud Function
      final response = await result.call(<String, dynamic>{
        'alert': alert,
        'matchingJobs': matchingJobs,
      });

      if (response.data['success']) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Email notification sent successfully'),
        //   ),
        // );
      } else {
        // final errorMessage = response.data['message'];
        // ScaffoldMessenger.showSnackBar(
        //   SnackBar(
        //     content: Text('Error sending email: $errorMessage'),
        //   ),
        // );
      }
    } catch (e) {
      // Handle errors that occur during the function call
      print('Error calling Cloud Function: $e');
    }
  }

  // Send local app notification
  Future<void> sendAppNotification(
      Map<String, dynamic> alert,
      List<dynamic> matchingJobs,
      ) async {
    const androidDetails = AndroidNotificationDetails(
      'job_alerts_channel',
      'Job Alerts',
      channelDescription: 'Notifications for new job matches',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await localNotifications.show(
      DateTime.now().millisecond,
      'New Job Matches',
      'Found ${matchingJobs.length} new jobs matching your alert',
      details,
    );
  }

  // Update notification preferences
  Future<void> updateNotificationPreferences({
    required String alertId,
    required String userId,
    required bool emailEnabled,
    required bool appEnabled,
  }) async {
    try {
      // First verify that the alert exists and belongs to the user
      final alertDoc = await fireStore.collection('jobAlerts').doc(alertId).get();

      if (!alertDoc.exists) {
        throw Exception('Alert not found');
      }

      final alertData = alertDoc.data() as Map<String, dynamic>;
      if (alertData['userId'] != userId) {
        throw Exception('Unauthorized access');
      }

      // If verification passes, update the preferences
      await fireStore.collection('jobAlerts').doc(alertId).update({
        'emailNotification': emailEnabled,
        'appNotification': appEnabled,
      });
    } catch (e) {
      debugPrint('Error updating notification preferences: $e');
      throw Exception('Failed to update notification preferences: ${e.toString()}');
    }
  }

}
// class NotificationServiceProvider extends StatefulWidget {
//   // using
//   const NotificationServiceProvider({super.key});
//
//   @override
//   State<NotificationServiceProvider> createState() => _NotificationServiceProviderState();
//
// }
//
// class _NotificationServiceProviderState extends State<NotificationServiceProvider> {
//   final FirebaseFirestore fireStore = FirebaseFirestore.instance;
//   final FirebaseFunctions functions = FirebaseFunctions.instance;
//   final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }
//
//
//
//   Future<void> initialize() async {
//     const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const initializationSettingsIOS = DarwinInitializationSettings();
//     const initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//     await localNotifications.initialize(initializationSettings);
//   }
//
//   Future<void> processJobAlerts(List<dynamic> newJobs) async {
//     final alertsSnapshot = await fireStore.collection('jobAlerts').get();
//
//     for (var doc in alertsSnapshot.docs) {
//       final alert = doc.data();
//       final matchingJobs = findMatchingJobs(newJobs, alert);
//
//       if (matchingJobs.isNotEmpty) {
//         if (alert['emailNotification']) {
//           await triggerEmailNotification(alert, matchingJobs);
//         }
//         if (alert['appNotification']) {
//           await sendAppNotification(alert, matchingJobs);
//         }
//       }
//     }
//   }
//
//
//   List<dynamic> findMatchingJobs(List<dynamic> jobs, Map<String, dynamic> alert) {
//     final titleFilter = alert['jobTitle']?.toLowerCase() ?? '';
//     final locationFilter = alert['location']?.toLowerCase() ?? '';
//
//     return jobs.where((job) {
//       final title = job['jobTitle']?.toLowerCase() ?? '';
//       final location = job['location']?.toLowerCase() ?? '';
//       return title.contains(titleFilter) && location.contains(locationFilter);
//     }).toList();
//   }
//
//   // Trigger email notification through Cloud Functions
//   Future<void> triggerEmailNotification(
//       Map<String, dynamic> alert,
//       List<dynamic> matchingJobs,
//       ) async {
//
//
//     try {
//       final HttpsCallable result = await FirebaseFunctions.instance
//           .httpsCallable('sendJobAlerts'); // Call the Cloud Function
//       final response = await result.call(<String, dynamic>{
//         'alert': alert,
//         'matchingJobs': matchingJobs,
//       });
//
//       if (response.data['success']) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Email notification sent successfully'),
//           ),
//         );
//       } else {
//         final errorMessage = response.data['message'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error sending email: $errorMessage'),
//           ),
//         );
//       }
//     } catch (e) {
//       // Handle errors that occur during the function call
//       print('Error calling Cloud Function: $e');
//     }
//   }
//
//   // Send local app notification
//   Future<void> sendAppNotification(
//       Map<String, dynamic> alert,
//       List<dynamic> matchingJobs,
//       ) async {
//     const androidDetails = AndroidNotificationDetails(
//       'job_alerts_channel',
//       'Job Alerts',
//       channelDescription: 'Notifications for new job matches',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const iosDetails = DarwinNotificationDetails();
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
//
//     await localNotifications.show(
//       DateTime.now().millisecond,
//       'New Job Matches',
//       'Found ${matchingJobs.length} new jobs matching your alert',
//       details,
//     );
//   }
//
//   // Update notification preferences
//   Future<void> updateNotificationPreferences({
//     required String alertId,
//     required String userId,
//     required bool emailEnabled,
//     required bool appEnabled,
//   }) async {
//     try {
//       // First verify that the alert exists and belongs to the user
//       final alertDoc = await fireStore.collection('jobAlerts').doc(alertId).get();
//
//       if (!alertDoc.exists) {
//         throw Exception('Alert not found');
//       }
//
//       final alertData = alertDoc.data() as Map<String, dynamic>;
//       if (alertData['userId'] != userId) {
//         throw Exception('Unauthorized access');
//       }
//
//       // If verification passes, update the preferences
//       await fireStore.collection('jobAlerts').doc(alertId).update({
//         'emailNotification': emailEnabled,
//         'appNotification': appEnabled,
//       });
//     } catch (e) {
//       debugPrint('Error updating notification preferences: $e');
//       throw Exception('Failed to update notification preferences: ${e.toString()}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
