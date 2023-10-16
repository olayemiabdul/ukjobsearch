// import 'package:flutter/material.dart';
// import 'package:ukjobsearch/screen/authourity.dart';
// import 'package:ukjobsearch/screen/firstscreenTab.dart';
// import 'package:ukjobsearch/screen/jobsearchScreen.dart';
// import 'package:ukjobsearch/screen/phonelogin.dart';
// import 'package:ukjobsearch/screen/signupscreen.dart';
// import 'package:ukjobsearch/screen/welcomePage.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   int currentIndex = 0;
//   List listPages = [];
//   Widget currentPage = WelcomeHomeScreen();
//   @override
//   void initState() {
//     super.initState();
//     listPages
//       ..add(WelcomeHomeScreen())
//       ..add(JobsearchScreen())
//       ..add(FistScreenPage())
//       ..add(myAuthPage())
//       ..add(PhoneLoginPage());
//     currentPage = WelcomeHomeScreen();
//   }

//   void _changePage(int selectedIndex) {
//     setState(() {
//       currentIndex = selectedIndex;
//       currentPage = listPages[selectedIndex];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       body: SafeArea(

//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: currentPage,
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         backgroundColor: Colors.blue,
//         currentIndex: currentIndex,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_max_rounded),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search_off_rounded),
//             label: 'Find Job',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.favorite_border_outlined),
//             label: 'My Application',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notification_add_rounded),
//             label: 'Notification',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_2_rounded),
//             label: 'Profile',
//           ),
//         ],
//         onTap: (selectedIndex) => _changePage(selectedIndex),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:ukjobsearch/screen/firstscreenTab.dart';
// import 'package:ukjobsearch/screen/forgotpassword.dart';
// import 'package:ukjobsearch/screen/jobsearchScreen.dart';
// import 'package:ukjobsearch/screen/longinscreen.dart';

// class MyBottomAppbar extends StatefulWidget {
//   const MyBottomAppbar({super.key});

//   @override
//   State<MyBottomAppbar> createState() => _MyBottomAppbarState();
// }

// class _MyBottomAppbarState extends State<MyBottomAppbar> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: BottomAppBar(
//           shape: CircularNotchedRectangle(),
//           notchMargin: 5,
//           clipBehavior: Clip.antiAlias,
//           child: Container(
//             color: Colors.amber,
//             height: 70,
//             width: MediaQuery.of(context).size.width,
//             child: Row(
//               children: [
//                 Column(
//                   children: [
//                     IconButton.filled(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => FistScreenPage()));
//                       },
//                       icon: Icon(Icons.home),
//                     ),
//                     SizedBox(height: 1),
//                     Text(
//                       'home',
//                       style: TextStyle(fontSize: 16),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   width: 15,
//                 ),
//                 Icon(Icons.send_and_archive_rounded),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => JobsearchScreen()));
//                   },
//                   child: Text('Job'),
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => FistScreenPage()));
//                         },
//                         icon: Icon(Icons.home))
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => FistScreenPage()));
//                         },
//                         icon: Icon(Icons.favorite_border_outlined))
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => FistScreenPage()));
//                         },
//                         icon: Icon(Icons.account_circle_outlined))
//                   ],
//                 ),
//               ],
//             ),
//           )),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ukjobsearch/provider/favouritejob.dart';
import 'package:ukjobsearch/screen/firstscreenTab.dart';
import 'package:ukjobsearch/authentication/forgotpassword.dart';
import 'package:ukjobsearch/screen/FilteredJobscreen.dart';
import 'package:ukjobsearch/screen/jobsearchHome.dart';
import 'package:ukjobsearch/authentication/longinscreen.dart';
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

  void tabChanged() {
// Check if Tab Controller index is changing, otherwise we get the notice twice
    if (myController!.indexIsChanging) {
      print('tabChanged: ${myController!.index}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: TabBarView(
        controller: myController,
        children: [
          const JobsearchScreen(),
          LoginPage(
            clickSignup: () {},
          ),
        const  likedJobs(),
          WelcomeHomeScreen(),
         
          
        ],
      )),
    );
  }
}
