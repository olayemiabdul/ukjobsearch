
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';

import '../model/networkservices.dart';

class MyCvJob extends StatefulWidget {
  const MyCvJob({super.key});

  @override
  State<MyCvJob> createState() => _MyCvJobState();
}

class _MyCvJobState extends State<MyCvJob> {
  ApiServices jobApi = ApiServices();
  RefreshController refreshController = RefreshController(initialRefresh: true);

  onRefresh() async {
    await jobApi.getCvLibraryJob('', '');
    refreshController.refreshCompleted();
  }

  onLoading() async {
    await jobApi.getCvLibraryJob('', '');
    refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: jobApi.getCvLibraryJob('', ''),
      builder: (context, AsyncSnapshot<List<CvJobs>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Error fetching jobs. Please try again.',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final List<CvJobs> jobs = snapshot.data!;
          return SmartRefresher(
            controller: refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _buildJobCard(context, job);
              },
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No jobs found. Please refine your search.',
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
      },
    );
  }

  Widget _buildJobCard(BuildContext context, CvJobs job) {
    final provider = Provider.of<FavouritesJob>(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          job.hlTitle?? 'Location not specified',
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

            Text('Posted on: ${job.posted}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            provider.cvlikedjobs(job) ? Icons.favorite : Icons.favorite_border,
            color: provider.cvlikedjobs(job) ? Colors.red : Colors.grey,
          ),
          onPressed: () => provider.cvtoggleFavourite(job),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: provider,
                child: CvJobDetailsPage(cvJobdetails: job),
              ),
            ),
          );
        },
      ),
    );
  }
}
