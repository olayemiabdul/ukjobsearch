
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../provider/favouriteProvider.dart';
import '../model/cvlibraryJob.dart';
import '../model/jobdescription.dart';
import 'jobs_details.dart';


class SavedJobsPage extends StatelessWidget {
  const SavedJobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesJob = Provider.of<FavouritesJob>(context);
    final savedCvJobs = favouritesJob.savedCvJobs;
    final savedReedJobs = favouritesJob.savedReedJobs;

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Jobs', style: GoogleFonts.poppins(
          textStyle: TextStyle( letterSpacing: .5),
        ),),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        elevation: 4,
      ),
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
        child: savedCvJobs.isEmpty && savedReedJobs.isEmpty
            ? Container(
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
              child: Center(

                        child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'No saved jobs yet',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap the heart icon on a job to save it for later.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
                        ),
                      ),
            )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: savedCvJobs.length + savedReedJobs.length,
          itemBuilder: (context, index) {
            if (index < savedCvJobs.length) {
              return _buildJobCard(
                context,
                job: savedCvJobs[index],
                isCvLibrary: true,
                onDelete: () {
                  favouritesJob.deleteSavedCvJob(savedCvJobs[index]);
                },
              );
            } else {
              final reedIndex = index - savedCvJobs.length;
              return _buildJobCard(
                context,
                job: savedReedJobs[reedIndex],
                isCvLibrary: false,
                onDelete: () {
                  favouritesJob.deleteSavedReedJob(savedReedJobs[reedIndex]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildJobCard(BuildContext context,
      {required dynamic job,
        required bool isCvLibrary,
        required VoidCallback onDelete}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCvLibrary
                        ? job.hlTitle ?? 'Job Title Not Specified'
                        : job.jobTitle ?? 'Job Title Not Specified',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isCvLibrary
                        ? job.location ?? 'Location not specified'
                        : job.locationName ?? 'Location not specified',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isCvLibrary
                        ? 'Posted on: ${job.posted ?? 'N/A'}'
                        : 'Posted on: ${job.date ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.teal),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: Provider.of<FavouritesJob>(context, listen: false),
                          child: AllJobDetailsPage(
                            jobDetails: job,
                            isCvLibrary: isCvLibrary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
