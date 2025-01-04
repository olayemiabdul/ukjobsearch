import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/reed_jobs/jobdecriptionpage.dart';

import 'jobs_details.dart';

class UnifiedJobSearchScreen extends StatefulWidget {
  const UnifiedJobSearchScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedJobSearchScreen> createState() => _UnifiedJobSearchScreenState();
}

class _UnifiedJobSearchScreenState extends State<UnifiedJobSearchScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final jobTitleController = TextEditingController();
  final locationController = TextEditingController();
  final ApiServices jobApi = ApiServices();
  final RefreshController refreshController =
  RefreshController(initialRefresh: false);

  List<CvJobs> cvLibraryJobs = [];
  List<ReedResult> reedJobs = [];
  List<CvJobs> filteredCvLibraryJobs = [];
  List<ReedResult> filteredReedJobs = [];
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  bool isInitialized = false;
  int totalJobs = 0;

  @override
  void initState() {
    super.initState();
    fetchInitialJob();
    jobTitleController.addListener(() {
      filterJobs();
    });
    locationController.addListener(() {
      filterJobs();
    });
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    locationController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  Future<void> fetchInitialJob() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      final cvJobs = await jobApi.getCvLibraryJob('', '');
      final reedJobResults = await jobApi.getFilesApi('', '');

      if (mounted) {
        setState(() {
          cvLibraryJobs = cvJobs;
          reedJobs = reedJobResults;
          filteredCvLibraryJobs = cvJobs;
          filteredReedJobs = reedJobResults;
          totalJobs = cvLibraryJobs.length + reedJobs.length;
          isInitialized = true;
          isLoading = false;
        });
        refreshController.refreshCompleted();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load jobs. Please try again.';
          isLoading = false;
        });
        refreshController.refreshFailed();
      }
      debugPrint('Error fetching initial jobs: $e');
    }
  }

  void filterJobs() {
    String jobTitle = jobTitleController.text.toLowerCase();
    String location = locationController.text.toLowerCase();

    if (jobTitle.isEmpty && location.isEmpty) {
      setState(() {
        filteredCvLibraryJobs = cvLibraryJobs;
        filteredReedJobs = reedJobs;
      });
    } else {
      setState(() {
        filteredCvLibraryJobs = cvLibraryJobs
            .where((job) =>
        (job.hlTitle ?? '').toLowerCase().contains(jobTitle) &&
            (job.location ?? '').toLowerCase().contains(location))
            .toList();
        filteredReedJobs = reedJobs
            .where((job) =>
        (job.jobTitle ?? '').toLowerCase().contains(jobTitle) &&
            (job.locationName ?? '').toLowerCase().contains(location))
            .toList();
      });
    }
  }

  Future<void> searchJobs(String jobTitle, String location) async {
    if (isLoading) return;

    // If no user input, load initial jobs
    if (jobTitle.trim().isEmpty && location.trim().isEmpty) {
      fetchInitialJob();
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      // Fetch filtered jobs based on user inputs
      final cvJobs = await jobApi.getCvLibraryJob(jobTitle, location);
      final reedJobResults = await jobApi.getFilesApi(jobTitle, location);

      if (mounted) {
        setState(() {
          cvLibraryJobs = cvJobs;
          reedJobs = reedJobResults;
          totalJobs = cvLibraryJobs.length + reedJobResults.length;
          isLoading = false;
        });
        filterJobs(); // Apply filtering after fetching
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Search failed. Please try again.';
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
      debugPrint('Error searching jobs: $e');
    }
  }



  Widget buildCvJobCard(FavouritesJob favouritesJob, CvJobs job) {
    final provider = Provider.of<FavouritesJob>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          job.hlTitle ?? 'Job Title Not Specified',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.location ?? 'Location not specified'),
            Text(job.salary ?? 'Salary not specified'),
            Text('Posted: ${job.posted!.hour} ago'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                favouritesJob.cvlikedjobs(job)
                    ? FontAwesomeIcons.heart
                    : Icons.favorite_border,
                color: favouritesJob.cvlikedjobs(job) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  favouritesJob.cvtoggleFavourite(job);
                  favouritesJob.saveCvJob(job);
                });
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.share, color: Colors.teal,),
              onPressed: () {
                Share.share(
                    "https://www.cv-library.co.uk${job.url}");

              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: provider,
                child: AllJobDetailsPage(
                  jobDetails: job,
                  isCvLibrary: true,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildReedJobCard(FavouritesJob favouritesJob, ReedResult job) {
    final provider = Provider.of<FavouritesJob>(context, listen: false);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          job.jobTitle ?? 'Job Title Not Specified',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.employerName ?? 'Employer not specified'),
            Text(job.locationName ?? 'Location not specified'),
            Text('Posted: ${job.date.toString()}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                favouritesJob.likedJobs(job)
                    ? FontAwesomeIcons.heart
                    : Icons.favorite_border,
                color: favouritesJob.likedJobs(job) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  favouritesJob.toggleFavourite(job);
                  favouritesJob.saveReedJob(job);
                });
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.share, color: Colors.teal,),
              onPressed: () {
                Share.share(
                     job.jobUrl.toString());

              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider.value(
                value: provider,
                child: AllJobDetailsPage(
                  jobDetails: job,
                  isCvLibrary: false,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildJobList() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                searchJobs(jobTitleController.text, locationController.text);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (filteredCvLibraryJobs.isEmpty && filteredReedJobs.isEmpty) {
      return const Center(child: Text('No jobs found. Try a different search.'));
    }

    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        searchJobs(jobTitleController.text, locationController.text);
      },
      child: ListView(
        children: [
          ...filteredCvLibraryJobs.map((job) {
            final favouritesJob =
            Provider.of<FavouritesJob>(context, listen: false);
            return buildCvJobCard(favouritesJob, job);
          }).toList(),
          ...filteredReedJobs.map((job) {
            final favouritesJob =
            Provider.of<FavouritesJob>(context, listen: false);
            return buildReedJobCard(favouritesJob, job);
          }).toList(),
        ],
      ),
    );
  }

  PreferredSizeWidget buildSearchAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFE0C2),
              Color(0xFF7FFFD4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [

              Expanded(
                child: TextField(
                  onSubmitted: (value){
                    setState(() {
                      searchJobs(jobTitleController.text,locationController.text);
                    });


                  },
                  controller: jobTitleController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.work_outline, color: Colors.grey),
                    hintText: 'Job Title',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.grey,
              ),
              Expanded(
                child: TextField(
                  onSubmitted: (value){
                    setState(() {
                      searchJobs(jobTitleController.text,locationController.text);
                    });


                  },
                  controller: locationController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on_outlined,
                        color: Colors.grey),
                    hintText: 'Location',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  ),
                ),
              ),

              // Location Input


            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE0C2), // Top gradient color
                Color(0xFF7FFFD4), // Bottom gradient color
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.work, color: Colors.black38, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Total Jobs: ${cvLibraryJobs.length + reedJobs.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF7FFFD4), // Your desired color
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: buildSearchAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE0C2), // Top gradient color (peach-like)
                Color(0xFF7FFFD4), // Bottom gradient color (blue-like)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [

              Expanded(
                child: buildJobList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
