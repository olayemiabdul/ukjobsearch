import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/favouriteProvider.dart';
import 'jobs_details.dart';

class AppliedJobsPage extends StatelessWidget {
  const AppliedJobsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouritesJob = Provider.of<FavouritesJob>(context);
    final appliedCvJobs = favouritesJob.appliedCvJobs;
    final appliedReedJobs = favouritesJob.appliedReedJobs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Applied Jobs'),
        backgroundColor: Colors.teal,
        elevation: 4,
      ),
      body: appliedCvJobs.isEmpty && appliedReedJobs.isEmpty
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
              Icon(Icons.check_circle_outline, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'No applied jobs yet',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apply to a job to track it here.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
                    ),
                  ),
          )
          : Container(
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
            child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: appliedCvJobs.length + appliedReedJobs.length,
                    itemBuilder: (context, index) {
            if (index < appliedCvJobs.length) {
              return _buildJobCard(context, job: appliedCvJobs[index], isCvLibrary: true);
            } else {
              final reedIndex = index - appliedCvJobs.length;
              return _buildJobCard(context, job: appliedReedJobs[reedIndex], isCvLibrary: false);
            }
                    },
                  ),
          ),
    );
  }

  Widget _buildJobCard(BuildContext context, {required dynamic job, required bool isCvLibrary}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(isCvLibrary ? job.hlTitle ?? 'Unknown Title' : job.jobTitle ?? 'Unknown Title'),
        subtitle: Text(isCvLibrary ? job.location ?? 'Unknown Location' : job.locationName ?? 'Unknown Location'),
        trailing: const Icon(Icons.arrow_forward, color: Colors.teal),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllJobDetailsPage(
                jobDetails: job,
                isCvLibrary: isCvLibrary,
              ),
            ),
          );
        },
      ),
    );
  }
}
