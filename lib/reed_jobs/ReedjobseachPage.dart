import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/reed_jobs/jobdecriptionpage.dart';

class ReedSearchPage extends StatefulWidget {
  const ReedSearchPage({super.key});

  @override
  State<ReedSearchPage> createState() => _ReedSearchPageState();
}

class _ReedSearchPageState extends State<ReedSearchPage> {
  final jobApi = ApiServices();
  final jobTitleController = TextEditingController();
  final cityController = TextEditingController();
  late Future<List<ReedResult>> jobFuture;

  @override
  void initState() {
    super.initState();
    // Initial fetch
    jobFuture = jobApi.getFilesApi("", "");
  }

  void _searchJobs() {
    setState(() {
      jobFuture = jobApi.getFilesApi(
        jobTitleController.text,
        cityController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.search, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              'Search for Jobs',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchFields(),
              const SizedBox(height: 16),
              _buildJobList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFields() {
    return Column(
      children: [
        _buildTextField(
          controller: jobTitleController,
          hint: 'Enter Job Title',
          icon: Icons.work_outline,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: cityController,
          hint: 'Enter City/Location',
          icon: Icons.location_on_outlined,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _searchJobs,
          icon: const Icon(Icons.search, size: 24),
          label: const Text(
            'Find Jobs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildJobList() {
    return FutureBuilder<List<ReedResult>>(
      future: jobFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No jobs found. Try a different search!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        final jobs = snapshot.data!;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: jobs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final job = jobs[index];
            return _buildJobCard(job);
          },
        );
      },
    );
  }

  Widget _buildJobCard(ReedResult job) {
    final provider = Provider.of<FavouritesJob>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        title: Text(
          job.jobTitle ?? 'No Title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              job.employerName ?? 'Unknown Employer',
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              job.locationName ?? 'No Location',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Posted on: ${job.date ?? 'N/A'}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: provider.likedJobs(job)
              ? const Icon(Icons.favorite, color: Colors.red)
              : const Icon(Icons.favorite_border),
          onPressed: () => provider.toggleFavourite(job),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DescriptionPage(jobDetails: job),
            ),
          );
        },
      ),
    );
  }
}
