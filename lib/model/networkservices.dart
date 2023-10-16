import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:ukjobsearch/model/jobdescription.dart';

class ApiServices {
  List<Result> abcJob = [];

  Future<List<Result>> getFilesApi(String title, String town) async {
    String Username = 'd9b1179f-f620-4742-a5cc-ece469c24d00';
    String Password = '';

    String basicAuth = 'Basic ' +
        base64.encode(
          utf8.encode('$Username:$Password'),
        );

    final response = await http.get(
        Uri.parse(
            "https://www.reed.co.uk/api/1.0/search?keywords=$title&location=$town"),
        headers: <String, String>{'authorization': basicAuth});

    //var data = jsonDecode(response.body).toList();

    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      json['results'].forEach((element) {
        if (abcJob.length < 30000) {
          abcJob.add(Result.fromJson(element));
        }
      });

      return abcJob;
    } else {
      throw Exception('Failed to load album');
    }
  }

//   Future<ReedJob> getJobApi() async {
//   String Username = 'd9b1179f-f620-4742-a5cc-ece469c24d00';
//     String Password = '';

//     String basicAuth = 'Basic ' +
//         base64.encode(
//           utf8.encode('$Username:$Password'),
//         );

//     final response = await http.get(
//         Uri.parse(
//             "https://www.reed.co.uk/api/1.0/search"),
//         headers: <String, String>{'authorization': basicAuth});
//   var data = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     return ReedJob.fromJson(data);
//   } else {
//     return ReedJob.fromJson(data);
//   }
// }
}
