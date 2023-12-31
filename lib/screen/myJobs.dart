import 'package:flutter/material.dart';
import 'package:ukjobsearch/provider/favouritejob.dart';
import 'package:ukjobsearch/provider/providerAppliedjobs.dart';


class likedJobs extends StatefulWidget {
  const likedJobs({super.key});

  @override
  State<likedJobs> createState() => _likedJobsState();
}

class _likedJobsState extends State<likedJobs> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'My Jobs',
              style: TextStyle(
                  fontFamily: 'Kanit-Bold', fontSize: 29, color: Colors.white),
            ),
          ),
          bottom: TabBar(
              padding: EdgeInsets.all(5),
              indicatorColor: Colors.green,
              tabs: [
                Tab(
                  icon: Icon(Icons.save_alt_outlined),
                  text: 'Saved',
                ),
                Tab(
                  icon: Icon(Icons.app_registration_outlined),
                  text: 'Applied',
                ),
              ]),
        ),
        body: TabBarView(children: [SavedJob(), AppliedJob(),]),
      ),
    );
  }
}
