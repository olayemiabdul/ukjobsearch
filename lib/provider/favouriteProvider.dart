//
// import 'package:flutter/material.dart';
// import 'package:ukjobsearch/model/cvlibraryJob.dart';
// import 'package:ukjobsearch/model/jobdescription.dart';
//
//
//
// class FavouritesJob extends ChangeNotifier {
//   List<ReedResult> favouriteJobs = [];
//    List<CvJobs> cvFavouriteJobs = [];
//   final List<CvJobs> _savedCvJobs = [];
//   final List<ReedResult> _savedReedJobs = [];
//   final List<CvJobs> _appliedCvJobs = [];
//   final List<ReedResult> _appliedReedJobs = [];
//
//   List<ReedResult> get reedJobs => favouriteJobs;
//   List<CvJobs> get cvApply => cvFavouriteJobs;
//   List<CvJobs> get savedCvJobs => _savedCvJobs;
//   List<ReedResult> get savedReedJobs => _savedReedJobs;
//   List<CvJobs> get appliedCvJobs => _appliedCvJobs;
//   List<ReedResult> get appliedReedJobs => _appliedReedJobs;
//
//
//
//   toggleFavourite(ReedResult likedJob) {
//     final reedTLiked = favouriteJobs.contains(likedJob);
//
//     // isLiked != null
//     //     ? favouritejobs.remove(likedJob)
//     //     : favouritejobs.add(likedJob);
//     if (reedTLiked) {
//       favouriteJobs.remove(likedJob);
//     } else {
//       favouriteJobs.add(likedJob);
//     }
//     notifyListeners();
//   }
//
//   cvtoggleFavourite(CvJobs cvlikedJob) {
//     final libraryLiked = cvFavouriteJobs.contains(cvlikedJob);
//
//     // isLiked != null
//     //     ? favouritejobs.remove(likedJob)
//     //     : favouritejobs.add(likedJob);
//     if (libraryLiked) {
//       cvFavouriteJobs.remove(cvlikedJob);
//     } else {
//       cvFavouriteJobs.add(cvlikedJob);
//     }
//     notifyListeners();
//   }
//
//   bool likedJobs(ReedResult rlikedJob) {
//     final reedIsLiked = favouriteJobs.contains(rlikedJob);
//
//     return reedIsLiked;
//
//   }
//  bool cvlikedjobs(CvJobs clikedJob) {
//     final cvLiked = cvFavouriteJobs.contains(clikedJob);
//     return cvLiked;
//     notifyListeners();
//   }
//   clearLikedJob(int clear) {
//     favouriteJobs.removeAt(clear);
//     notifyListeners();
//   }
//    cvClearLikedJob(int clear) {
//     cvFavouriteJobs.removeAt(clear);
//     notifyListeners();
//   }
//
//
//   welcomeProfile(Widget profile ){
//     final isProfile=cvFavouriteJobs.indexed;
//     notifyListeners();
//   }
//   void saveCvJob(CvJobs job) {
//     if (!_savedCvJobs.contains(job)) {
//       _savedCvJobs.add(job);
//       notifyListeners();
//     }
//   }
//
//   void saveReedJob(ReedResult job) {
//     if (!_savedReedJobs.contains(job)) {
//       _savedReedJobs.add(job);
//       notifyListeners();
//     }
//   }
//   void deleteSavedCvJob(CvJobs job) {
//     _savedCvJobs.remove(job);
//     notifyListeners();
//   }
//
//   void deleteSavedReedJob(ReedResult job) {
//     _savedReedJobs.remove(job);
//     notifyListeners();
//   }
//
//   void clearAllSavedJobs() {
//     _savedCvJobs.clear();
//     _savedReedJobs.clear();
//     notifyListeners();
//   }
// // Save applied CV job
//   void saveAppliedCvJob(CvJobs job) {
//     if (!_appliedCvJobs.contains(job)) {
//       _appliedCvJobs.add(job);
//       notifyListeners();
//     }
//   }
//
//   // Save applied Reed job
//   void saveAppliedReedJob(ReedResult job) {
//     if (!_appliedReedJobs.contains(job)) {
//       _appliedReedJobs.add(job);
//       notifyListeners();
//     }
//   }
//
//   // Clear all applied jobs (both CV and Reed)
//   void clearAllAppliedJobs() {
//     _appliedCvJobs.clear();
//     _appliedReedJobs.clear();
//     notifyListeners();
//   }
//
//   // Remove a specific applied CV job
//   void removeAppliedCvJob(CvJobs job) {
//     _appliedCvJobs.remove(job);
//     notifyListeners();
//   }
//
//   // Remove a specific applied Reed job
//   void removeAppliedReedJob(ReedResult job) {
//     _appliedReedJobs.remove(job);
//     notifyListeners();
//   }
// }

// favouriteProvider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';

class FavouritesJob extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lists for favorite jobs
  List<ReedResult> favouriteJobs = [];
  List<CvJobs> cvFavouriteJobs = [];

  // Lists for saved and applied jobs
  List<CvJobs> _savedCvJobs = [];
  List<ReedResult> _savedReedJobs = [];
  List<CvJobs> _appliedCvJobs = [];
  List<ReedResult> _appliedReedJobs = [];

  // Getters
  List<ReedResult> get reedJobs => favouriteJobs;
  List<CvJobs> get cvApply => cvFavouriteJobs;
  List<CvJobs> get savedCvJobs => _savedCvJobs;
  List<ReedResult> get savedReedJobs => _savedReedJobs;
  List<CvJobs> get appliedCvJobs => _appliedCvJobs;
  List<ReedResult> get appliedReedJobs => _appliedReedJobs;

  // Initialize data from Firebase when app starts for the saved and appplied jobs
  Future<void> initializeData() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _loadSavedJobs();
      await loadAppliedJobs();
    }
  }

  // Original toggle favorite methods
  void toggleFavourite(ReedResult likedJob) {
    final reedTLiked = favouriteJobs.contains(likedJob);
    if (reedTLiked) {
      favouriteJobs.remove(likedJob);
    } else {
      favouriteJobs.add(likedJob);
    }
    notifyListeners();
  }

  void cvtoggleFavourite(CvJobs cvlikedJob) {
    final libraryLiked = cvFavouriteJobs.contains(cvlikedJob);
    if (libraryLiked) {
      cvFavouriteJobs.remove(cvlikedJob);
    } else {
      cvFavouriteJobs.add(cvlikedJob);
    }
    notifyListeners();
  }

  // Original liked jobs check methods
  bool likedJobs(ReedResult rlikedJob) {
    return favouriteJobs.contains(rlikedJob);
  }

  bool cvlikedjobs(CvJobs clikedJob) {
    return cvFavouriteJobs.contains(clikedJob);
  }

  // Original clear methods
  void clearLikedJob(int clear) {
    favouriteJobs.removeAt(clear);
    notifyListeners();
  }

  void cvClearLikedJob(int clear) {
    cvFavouriteJobs.removeAt(clear);
    notifyListeners();
  }

  // Firebase integration methods for saved jobs
  Future<void> _loadSavedJobs() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final savedJobsDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .get();

        _savedCvJobs = savedJobsDoc.docs
            .where((doc) => doc.data()['type'] == 'cv')
            .map((doc) => CvJobs.fromJson(doc.data()['jobData']))
            .toList();

        _savedReedJobs = savedJobsDoc.docs
            .where((doc) => doc.data()['type'] == 'reed')
            .map((doc) => ReedResult.fromJson(doc.data()['jobData']))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      print('Error loading saved jobs: $e');
    }
  }

  // Firebase integration methods for applied jobs
  Future<void> loadAppliedJobs() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final appliedJobsDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .get();

        _appliedCvJobs = appliedJobsDoc.docs
            .where((doc) => doc.data()['type'] == 'cv')
            .map((doc) => CvJobs.fromJson(doc.data()['jobData']))
            .toList();

        _appliedReedJobs = appliedJobsDoc.docs
            .where((doc) => doc.data()['type'] == 'reed')
            .map((doc) => ReedResult.fromJson(doc.data()['jobData']))
            .toList();

        notifyListeners();
      }
    } catch (e) {
      print('Error loading applied jobs: $e');
    }
  }

  // Save jobs methods with Firebase
  Future<void> saveCvJob(CvJobs job) async {
    try {
      final user = _auth.currentUser;
      if (user != null && !_savedCvJobs.contains(job)) {
        final docRef = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .add({
          'type': 'cv',
          'jobData': job.toJson(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        _savedCvJobs.add(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error saving CV job: $e');
    }
  }

  Future<void> saveReedJob(ReedResult job) async {
    try {
      final user = _auth.currentUser;
      if (user != null && !_savedReedJobs.contains(job)) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .add({
          'type': 'reed',
          'jobData': job.toJson(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        _savedReedJobs.add(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error saving Reed job: $e');
    }
  }

  // Delete saved jobs methods
  Future<void> deleteSavedCvJob(CvJobs job) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .where('type', isEqualTo: 'cv')
            .where('jobData.id', isEqualTo: job.id)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        _savedCvJobs.remove(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting saved CV job: $e');
    }
  }

  Future<void> deleteSavedReedJob(ReedResult job) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .where('type', isEqualTo: 'reed')
            .where('jobData.jobId', isEqualTo: job.jobId)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        _savedReedJobs.remove(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting saved Reed job: $e');
    }
  }

  // Apply for jobs methods with Firebase
  Future<void> applyForCvJob(CvJobs job) async {
    try {
      final user = _auth.currentUser;
      if (user != null && !_appliedCvJobs.contains(job)) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .add({
          'type': 'cv',
          'jobData': job.toJson(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        _appliedCvJobs.add(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error applying for CV job: $e');
    }
  }

  Future<void> applyForReedJob(ReedResult job) async {
    try {
      final user = _auth.currentUser;
      if (user != null && !_appliedReedJobs.contains(job)) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .add({
          'type': 'reed',
          'jobData': job.toJson(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        _appliedReedJobs.add(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error applying for Reed job: $e');
    }
  }

  // Clear all saved/applied jobs methods
  Future<void> clearAllSavedJobs() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final batch = _firestore.batch();
        final savedJobs = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('savedJobs')
            .get();

        for (var doc in savedJobs.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
        _savedCvJobs.clear();
        _savedReedJobs.clear();
        notifyListeners();
      }
    } catch (e) {
      print('Error clearing saved jobs: $e');
    }
  }

  Future<void> clearAllAppliedJobs() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final batch = _firestore.batch();
        final appliedJobs = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .get();

        for (var doc in appliedJobs.docs) {
          batch.delete(doc.reference);
        }

        await batch.commit();
        _appliedCvJobs.clear();
        _appliedReedJobs.clear();
        notifyListeners();
      }
    } catch (e) {
      print('Error clearing applied jobs: $e');
    }
  }

  // Delete single applied job methods
  Future<void> deleteAppliedCvJob(CvJobs job) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .where('type', isEqualTo: 'cv')
            .where('jobData.id', isEqualTo: job.id)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        _appliedCvJobs.remove(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting applied CV job: $e');
    }
  }

  Future<void> deleteAppliedReedJob(ReedResult job) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('appliedJobs')
            .where('type', isEqualTo: 'reed')
            .where('jobData.jobId', isEqualTo: job.jobId)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }

        _appliedReedJobs.remove(job);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting applied Reed job: $e');
    }
  }
}