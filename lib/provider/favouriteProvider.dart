// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:ukjobsearch/model/jobdescription.dart';

class FavouritesJob extends ChangeNotifier {
  List<Result> favouritejobs = [];

  List<Result> get olaye => favouritejobs;
  // Widget screen = JobsearchScreen();
  // Widget get currentScreen => screen;

  // void add(Result jobNo) {
  //   favouritejobs.add(jobNo);
  //   notifyListeners();
  // }

  // void remove(Result jobNo) {
  //   favouritejobs.remove(jobNo);
  //   notifyListeners();
  // }
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

  bool likedjobs(Result likedJob) {
    final isLiked = favouritejobs.contains(likedJob);
    return isLiked;
  }

  clearLikedJob(Result clear) {
    favouritejobs.removeAt(0);
    notifyListeners();
  }

  appliedJob(Result applied) {
    // ignore: sdk_version_since
    final isapplied = favouritejobs.indexed;
    isapplied;
    notifyListeners();
  }
}
