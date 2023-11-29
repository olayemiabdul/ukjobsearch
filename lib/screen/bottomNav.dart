
import 'package:flutter/material.dart';
import 'package:ukjobsearch/cvlibrary/cvjobpage.dart';
import 'package:ukjobsearch/cvlibrary/cvjobseachPage.dart';






import 'package:ukjobsearch/screen/jobsearchHome.dart';
import 'package:ukjobsearch/screen/myJobs.dart';
import 'package:ukjobsearch/screen/welcomePage.dart';

class myNewBar extends StatefulWidget {
  myNewBar({super.key});

  @override
  State<myNewBar> createState() => _myNewBarState();
}

class _myNewBarState extends State<myNewBar>
    with SingleTickerProviderStateMixin {
  TabController? myController;

//final myController = TabController( length: 3, vsync: this, );
  @override
  void initState() {
    super.initState();
    myController = TabController(length: 4, vsync: this);
    myController!.addListener(tabChanged);
  }

  void tabChanged () {
// Check if Tab Controller index is changing, otherwise we get the notice twice
    if (myController!.indexIsChanging) {
      print('tabChanged: ${myController!.index}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: TabBar(
            controller: myController,
            labelColor: Colors.black54,
            unselectedLabelColor: Colors.black38,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: 'Find Jobs',
              ),
              Tab(
                icon: Icon(Icons.search_outlined),
                text: 'Recommended Jobs',
              ),
              Tab(
                icon: Icon(Icons.favorite_border),
                text: 'My Jobs',
              ),
                Tab(
                icon: Icon(Icons.person_2_outlined),
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
              const JobsearchScreen(),
              const CvLibrarySearchPage()  ,
                    const  likedJobs(),
              WelcomeHomeScreen(),
                     
              
                    ],
                  ),
            ),),
      ),
    );
  }
}
