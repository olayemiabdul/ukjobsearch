
import 'package:flutter/material.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';



class FavouritesJob extends ChangeNotifier {
  List<Result> favouriteJobs = [];
   List<Job> cvFavouriteJobs = [];

  List<Result> get reedJobs => favouriteJobs;
  List<Job> get cvApply => cvFavouriteJobs;

  toggleFavourite(Result likedJob) {
    final reedTLiked = favouriteJobs.contains(likedJob);

    // isLiked != null
    //     ? favouritejobs.remove(likedJob)
    //     : favouritejobs.add(likedJob);
    if (reedTLiked) {
      favouriteJobs.remove(likedJob);
    } else {
      favouriteJobs.add(likedJob);
    }
    notifyListeners();
  }

  cvtoggleFavourite(Job cvlikedJob) {
    final libraryLiked = cvFavouriteJobs.contains(cvlikedJob);

    // isLiked != null
    //     ? favouritejobs.remove(likedJob)
    //     : favouritejobs.add(likedJob);
    if (libraryLiked) {
      cvFavouriteJobs.remove(cvlikedJob);
    } else {
      cvFavouriteJobs.add(cvlikedJob);
    }
    notifyListeners();
  }

  bool likedJobs(Result rlikedJob) {
    final reedIsLiked = favouriteJobs.contains(rlikedJob);

    return reedIsLiked;

  }
 bool cvlikedjobs(Job clikedJob) {
    final cvLiked = cvFavouriteJobs.contains(clikedJob);
    return cvLiked;
    notifyListeners();
  }
  clearLikedJob(int clear) {
    favouriteJobs.removeAt(clear);
    notifyListeners();
  }
   cvClearLikedJob(int clear) {
    cvFavouriteJobs.removeAt(clear);
    notifyListeners();
  }

  // appliedJob(Result applied) {
  //
  //   final isApplied = favouriteJobs.indexed;
  //   isApplied;
  //   notifyListeners();
  // }
  //
  // cvappliedJob(Job applied) {
  //
  //   final isapplied = cvFavouriteJobs.indexed;
  //   isapplied;
  //   notifyListeners();
  // }
  welcomeProfile(Widget profile ){
    final isProfile=cvFavouriteJobs.indexed;
    notifyListeners();
  }
}
