import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/reed_jobs/ReedjobseachPage.dart';

import 'package:ukjobsearch/cvlibrary/CvjobsearchHome.dart';
import 'package:ukjobsearch/authentication/authScreen.dart';

import 'package:ukjobsearch/screen/myJobs.dart';

import 'package:ukjobsearch/refactored%20code/job_alert/welcomePage.dart';

import '../provider/favouriteProvider.dart';
import 'job_alert/alert_screen.dart';
import 'favourite tab.dart';
import 'savedJobs.dart';
import 'test.dart';

class myNewBar extends StatefulWidget {
  const myNewBar({super.key});

  @override
  State<myNewBar> createState() => _myNewBarState();
}

class _myNewBarState extends State<myNewBar>
    with SingleTickerProviderStateMixin {
  TabController? myController;
  final user = FirebaseAuth.instance.currentUser;
  final userDetails = FirebaseAuth.instance;

//final myController = TabController( length: 3, vsync: this, );
  @override
  void initState() {
    super.initState();
    myController = TabController(length: 4, vsync: this);
    myController!.addListener(tabChanged);
  }

  void tabChanged() {
// Check if Tab Controller index is changing, otherwise we get the notice twice
    if (myController!.indexIsChanging) {
      print('tabChanged: ${myController!.index}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouritesJob>(
        create: (BuildContext context) => FavouritesJob(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomAppBar(
                child: TabBar(
                  controller: myController,
                  labelColor: Colors.black54,
                  unselectedLabelColor: Colors.black38,
                  tabs: const [
                    Tab(
                      icon: Icon(
                        Icons.home,
                        color: Colors.blue,
                      ),
                      text: 'Find Jobs',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.home_max,
                        color: Colors.redAccent,
                      ),
                      text: 'Saved Jobs',
                    ),
                    Tab(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                      ),
                      text: 'Job Alerts',
                    ),
                    Tab(
                      icon: Icon(Icons.person_2_outlined,
                          color: Colors.deepOrange),
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
              body: SafeArea(
                child: Scaffold(
                  body: TabBarView(
                    controller: myController,
                    children: [
                      const UnifiedJobSearchScreen(),
                      const SavedAndAppliedJobsTab(),
                      const JobAlertPage(),

                      //if user is signin display welcome page or else display register page
                      user != null ? const WelcomeHomeScreen() : const ProfileAuth()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
