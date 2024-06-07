import 'package:flutter/material.dart';

import 'package:ukjobsearch/provider/favouritejob.dart';


class likedClickedJobs extends StatefulWidget {
  const likedClickedJobs({super.key});

  @override
  State<likedClickedJobs> createState() => _likedClickedJobsState();
}

class _likedClickedJobsState extends State<likedClickedJobs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.green,
            title: const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'My Jobs',
                style: TextStyle(
                    fontFamily: 'Kanit-Bold', fontSize: 29, color: Colors.white),
              ),
            ),
            bottom: const TabBar(
                padding: EdgeInsets.all(5),
                indicatorColor: Colors.green,
                tabs: [
                  Tab(
                    icon: Icon(Icons.save_alt_outlined),
                    text: 'CvLibrary',
                  ),
                  Tab(
                    icon: Icon(Icons.app_registration_outlined),
                    text: 'Reed.co.uk',
                  ),
                ]),
          ),
          body: const TabBarView(children: [FavouriteCvJob (), SavedJob(),]),
        ),
      ),
    );
  }
}
