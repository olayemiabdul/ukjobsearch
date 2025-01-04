// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:functions_framework/functions_framework.dart';
// import 'package:mailer/mailer.dart' as mailer;
// import 'package:mailer/smtp_server.dart';
// //ive in Firebase Cloud Functions,
// Future<void> sendJobAlerts(RequestContext context) async {
//   final firestore = FirebaseFirestore.instance;
//
//   // Fetch only relevant alerts
//   final alerts = await firestore
//       .collection('jobAlerts')
//       .where('emailNotification', isEqualTo: true)
//       .get();
//
//   for (var alert in alerts.docs) {
//     final alertData = alert.data();
//     await _sendEmailNotification(alertData);
//   }
// }
//
// Future<void> _sendEmailNotification(Map<String, dynamic> alertData) async {
//   const String username = 'olayemi.abdullahi9585@gmail.com';
//   const password ='ktrrffyquubmrvim';
//   final smtpServer = gmail(username, password);
//   //Create & use App Passwords in gmail
//
//
//   final message = mailer.Message()
//     ..from = const mailer.Address(username, 'Job Alerts')
//     ..recipients.add(alertData['userEmail'])
//     ..subject = 'New Job Matches Found'
//     ..html = _createEmailTemplate(alertData['matchingJobs']);
//
//   try {
//     await mailer.send(message, smtpServer);
//     print('Email sent to ${alertData['userEmail']}');
//   } catch (e) {
//     print('Error sending email: $e');
//   }
// }
//
// String _createEmailTemplate(List<dynamic> matchingJobs) {
//   final jobList = matchingJobs.map((job) => '<li>${job['title']}</li>').join();
//   return '''
//     <html>
//       <body>
//         <h3>New Job Matches for You</h3>
//         <ul>$jobList</ul>
//         <p>Best regards,<br>Job Alerts Team</p>
//       </body>
//     </html>
//   ''';
// }
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

Future<void> sendJobAlerts(HttpsCallableResult result) async {
  final Map<String, dynamic> data = result.data as Map<String, dynamic>;
  final Map<String, dynamic> alert = data['alert'];
  final List<dynamic> matchingJobs = data['matchingJobs'];


  const String username = 'olayemi.abdullahi9585@gmail.com';
  const String password = 'ktrrffyquubmrvim'; //App Password for security

  final smtpServer = gmail(username, password);

  final message = mailer.Message()
    ..from = const mailer.Address(username, 'Job Alerts')
    ..recipients.add(alert['userEmail']) // Assuming userEmail is stored in the alert
    ..subject = 'New Job Matches Found'
    ..html = _createEmailTemplate(matchingJobs);

  try {
    await mailer.send(message, smtpServer);
    print('Email sent to ${alert['userEmail']}');
  } catch (e) {
    print('Error sending email: $e');
    // Handle the error, e.g., log it or retry
  }
}

String _createEmailTemplate(List<dynamic> matchingJobs) {
  final jobList = matchingJobs.map((job) => '<li>${job['title']}</li>').join();
  return '''
    <html>
      <body>
        <h3>New Job Matches for You</h3>
        <ul>$jobList</ul>
        <p>Best regards,<br>Tuned Jobs Team</p>
      </body>
    </html>
  ''';
}
