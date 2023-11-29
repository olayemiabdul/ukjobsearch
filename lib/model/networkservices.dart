import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';

class ApiServices {
  List<Result> abcJob = [];

  Future<List<Result>> getFilesApi(String title, String town) async {
    String Username = 'd9b1179f-f620-4742-a5cc-ece469c24d00';
    String Password = '';

    String basicAuth = 'Basic ' +
        base64.encode(
          utf8.encode('$Username:$Password'),
        );
    try {
      final String url1 =
          "https://www.reed.co.uk/api/1.0/search?keywords=$title&location=$town";
      try {
        final result = await InternetAddress.lookup(url1);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
        }
      } on SocketException catch (_) {
        print('not connected');
      }
      final response = await http.get(Uri.parse(url1),
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
    } catch (e) {
      print('error is : $e');
    }
    return [];
  }

  List<Job> cvlibraryjob = [];
  bool isRefresh = false;

  int offsetNumber =
      0; //must be 0 because search using jobtitle and location might return zero or less than 25 jobs
  int totalPage = 400000;

  Future<List<Job>> getCvLibraryJob(String cvtitle, String cvlocation) async {
    try {
      final String url =
          'https://www.cv-library.co.uk/search-jobs-json?key=zkM61g6mb,9z-byL&q=job&perpage=25&offset=$offsetNumber&title=$cvtitle&geo=$cvlocation&description_limit=4000&applyurl';
      try {
        final result = await InternetAddress.lookup(url);
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          print('connected');
        }
      } on SocketException catch (_) {
        print('not connected');
      }
      final cvResponse = await http.get(Uri.parse(url));

      print(cvResponse.body);

      if (cvResponse.statusCode == 200) {
        //var encodecvresponse = jsonEncode(cvResponse.body);
        Map<String, dynamic> json = jsonDecode(cvResponse.body);

        //try and catch for null return forEach method

        json['jobs'].forEach((element) {
          // ignore: unnecessary_null_comparison
          if (cvlibraryjob.length < 400000) {
            cvlibraryjob.add(Job.fromJson(element));
            offsetNumber + 25;
            //cvlibraryjob = <Job>[];
          }
        });

        totalPage = cvlibraryjob.length;
        return cvlibraryjob;
      } else {
        throw Exception('check network');
      }
    } catch (e) {
      print('catched error: $e');
    }
    //return [];
    return cvlibraryjob;
  }
}
