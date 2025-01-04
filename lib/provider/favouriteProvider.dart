
import 'package:flutter/material.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';



class FavouritesJob extends ChangeNotifier {
  List<ReedResult> favouriteJobs = [];
   List<CvJobs> cvFavouriteJobs = [];
  final List<CvJobs> _savedCvJobs = [];
  final List<ReedResult> _savedReedJobs = [];
  final List<CvJobs> _appliedCvJobs = [];
  final List<ReedResult> _appliedReedJobs = [];

  List<ReedResult> get reedJobs => favouriteJobs;
  List<CvJobs> get cvApply => cvFavouriteJobs;
  List<CvJobs> get savedCvJobs => _savedCvJobs;
  List<ReedResult> get savedReedJobs => _savedReedJobs;
  List<CvJobs> get appliedCvJobs => _appliedCvJobs;
  List<ReedResult> get appliedReedJobs => _appliedReedJobs;



  toggleFavourite(ReedResult likedJob) {
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

  cvtoggleFavourite(CvJobs cvlikedJob) {
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

  bool likedJobs(ReedResult rlikedJob) {
    final reedIsLiked = favouriteJobs.contains(rlikedJob);

    return reedIsLiked;

  }
 bool cvlikedjobs(CvJobs clikedJob) {
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


  welcomeProfile(Widget profile ){
    final isProfile=cvFavouriteJobs.indexed;
    notifyListeners();
  }
  void saveCvJob(CvJobs job) {
    if (!_savedCvJobs.contains(job)) {
      _savedCvJobs.add(job);
      notifyListeners();
    }
  }

  void saveReedJob(ReedResult job) {
    if (!_savedReedJobs.contains(job)) {
      _savedReedJobs.add(job);
      notifyListeners();
    }
  }
  void deleteSavedCvJob(CvJobs job) {
    _savedCvJobs.remove(job);
    notifyListeners();
  }

  void deleteSavedReedJob(ReedResult job) {
    _savedReedJobs.remove(job);
    notifyListeners();
  }

  void clearAllSavedJobs() {
    _savedCvJobs.clear();
    _savedReedJobs.clear();
    notifyListeners();
  }
// Save applied CV job
  void saveAppliedCvJob(CvJobs job) {
    if (!_appliedCvJobs.contains(job)) {
      _appliedCvJobs.add(job);
      notifyListeners();
    }
  }

  // Save applied Reed job
  void saveAppliedReedJob(ReedResult job) {
    if (!_appliedReedJobs.contains(job)) {
      _appliedReedJobs.add(job);
      notifyListeners();
    }
  }

  // Clear all applied jobs (both CV and Reed)
  void clearAllAppliedJobs() {
    _appliedCvJobs.clear();
    _appliedReedJobs.clear();
    notifyListeners();
  }

  // Remove a specific applied CV job
  void removeAppliedCvJob(CvJobs job) {
    _appliedCvJobs.remove(job);
    notifyListeners();
  }

  // Remove a specific applied Reed job
  void removeAppliedReedJob(ReedResult job) {
    _appliedReedJobs.remove(job);
    notifyListeners();
  }
}
