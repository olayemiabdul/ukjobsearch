// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';

class FavouritesJob extends ChangeNotifier {
  List<Result> favouritejobs = [];
   List<Job> cvfavouritejobs = [];

  List<Result> get olaye => favouritejobs;
  List<Job> get cvApply => cvfavouritejobs;

  toggleFavourite(Result likedJob) {
    final isLiked = favouritejobs.contains(likedJob);

    // isLiked != null
    //     ? favouritejobs.remove(likedJob)
    //     : favouritejobs.add(likedJob);
    if (isLiked) {
      favouritejobs.remove(likedJob);
    } else {
      favouritejobs.add(likedJob);
    }
    notifyListeners();
  }

  cvtoggleFavourite(Job likedJob) {
    final isLiked = cvfavouritejobs.contains(likedJob);

    // isLiked != null
    //     ? favouritejobs.remove(likedJob)
    //     : favouritejobs.add(likedJob);
    if (isLiked) {
      cvfavouritejobs.remove(likedJob);
    } else {
      cvfavouritejobs.add(likedJob);
    }
    notifyListeners();
  }

  bool likedjobs(Result likedJob) {
    final isLiked = favouritejobs.contains(likedJob);
    return isLiked;
  }
 bool cvlikedjobs(Job likedJob) {
    final isLiked = cvfavouritejobs.contains(likedJob);
    return isLiked;
  }
  clearLikedJob(Result clear) {
    favouritejobs.removeAt(0);
    notifyListeners();
  }
   cvclearLikedJob(Job clear) {
    cvfavouritejobs.removeAt(0);
    notifyListeners();
  }

  appliedJob(Result applied) {
    // ignore: sdk_version_since
    final isapplied = favouritejobs.indexed;
    isapplied;
    notifyListeners();
  }

  cvappliedJob(Job applied) {
    // ignore: sdk_version_since
    final isapplied = cvfavouritejobs.indexed;
    isapplied;
    notifyListeners();
  }
}
