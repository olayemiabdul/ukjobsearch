import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/refactored%20code/savedJobs.dart';
import 'package:ukjobsearch/refactored%20code/saved_applied.dart';
import '../provider/favouriteProvider.dart';
 // This should contain your AppliedJobsPage widget

class SavedAndAppliedJobsTab extends StatelessWidget {
  const SavedAndAppliedJobsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('My Jobs',
            style: GoogleFonts.poppins(
              textStyle:  TextStyle(color: Colors.grey[600], letterSpacing: .5, fontSize: 24, fontWeight: FontWeight.w900),
            ),
         ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 4,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.bookmark), text: 'Saved Jobs'),
              Tab(icon: Icon(Icons.check_circle), text: 'Applied Jobs'),
            ],
          ),
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

          child: const TabBarView(
            children: [
              SavedJobsPage(),
              AppliedJobsPage()
            ],
          ),
        ),
      ),
    );
  }
}
