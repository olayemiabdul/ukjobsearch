import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/authentication/authScreen.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
import 'package:ukjobsearch/cvlibrary/cvjobFilteredSearch.dart';
import 'package:ukjobsearch/cvlibrary/cvjobSingleSearch.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'cvjobpage.dart';

class CvLibraryJobSearchScreen extends StatefulWidget {
  const CvLibraryJobSearchScreen({super.key});

  @override
  State<CvLibraryJobSearchScreen> createState() => _CvLibraryJobSearchScreenState();
}

class _CvLibraryJobSearchScreenState extends State<CvLibraryJobSearchScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final cityController = TextEditingController();

  final jobTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Tuned Jobs',
                    textStyle: const TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],
                totalRepeatCount: 1,
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              const SizedBox(width: 10),
              const Icon(Icons.work, color: Colors.white),
            ],
          ),
          centerTitle: true,
        ),
        endDrawer: buildDrawer(context),
        body: Column(
          children: [
            buildWelcomeSection(context),
            buildSearchSection(),
            const Expanded(child:  MyCvJob()),
          ],
        ),
      ),
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Text(
              'Tuned Jobs',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget buildWelcomeSection(BuildContext context) {
    return Container(
      color: Colors.green[100],
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedTextKit(

            animatedTexts: [
              TyperAnimatedText(
                user != null
                    ? 'Welcome, ${user?.displayName ?? 'User'}!'
                    : 'Welcome to Tuned Jobs!',
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],

          ),
          const SizedBox(height: 8),
          const Hero(
            tag: '',
            child: Text(
              'Discover your dream job with ease.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 16),
          const Center(

          ),
        ],
      ),
    );
  }
  Widget buildSearchSection() {
    bool isLoading;
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green[50],
      child: Column(
        children: [
          TextField(
            controller: jobTitleController,

            decoration: InputDecoration(
              hintText: 'Job Title',
              prefixIcon: const Icon(Icons.work, color: Colors.green),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: cityController,
            decoration: InputDecoration(
              hintText: 'Location',
              prefixIcon: const Icon(Icons.location_on, color: Colors.green),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: (){
              final provider =
              Provider.of<FavouritesJob>(context, listen: false);
              //navigate to singlesearch page provider
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider.value(
                    value: provider,
                    child:CvSingleSearch(cvjobName: jobTitleController.text, cvJobLocation: cityController.text,),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
            const Text('Search Jobs', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
