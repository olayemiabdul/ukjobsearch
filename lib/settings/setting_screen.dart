import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contactPage.dart';

class SettingsPageScreen extends StatelessWidget {
  const SettingsPageScreen({super.key});

   privacyPolicy() async{
     const termsUrl='https://doc-hosting.flycricket.io/tuned-jobs-privacy-policy/d8474bc1-13cf-4365-9c1d-1d60a9051883/privacy';
     if (await canLaunch(termsUrl)) {
     await launch(termsUrl);
     } else {
     throw 'Could not launch $termsUrl';
     }

  }

  void termsOfService() async{

    const privacyUrl='https://doc-hosting.flycricket.io/tuned-jobs-terms-of-use/cd72c851-b405-4ef2-926d-d9f92e850b54/terms';

    if (await canLaunch(privacyUrl)) {
    await launch(privacyUrl);
    } else {
    throw 'Could not launch $privacyUrl';
    }
  }

 rateUs() async {
    const url = 'https://play.google.com/store/apps/details?id=com.tunedjobs.ukjobsearch';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

 contactUs(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactUsPage()),
    );
  }

shareApp(BuildContext context) {
    Share.share('Check out this amazing app: https://play.google.com/store/apps/details?id=com.finejobs.ukjobsearch', // Replace with your app's Play Store URL
        subject: 'Share Our App');
  }

  deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted successfully.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Container(
            height: 120,
            width: 200,
            //color: Colors.white,
            child: Center(child: Text('Failed to delete account: $e')))),
      );
    }
  }

 logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully.')),
    );
    // Navigate to login screen if needed
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: const Color(0xFF402D45),
      appBar: AppBar(
        leading: const Icon(Icons.settings, color: Colors.white,),
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Privacy Policy'),
            onTap: () => privacyPolicy(),
          ),
          ListTile(
            title: const Text('Terms of Service'),
            onTap: () => termsOfService(),
          ),
          ListTile(
            title: const Text('Rate Us'),
            onTap: rateUs,
          ),
          ListTile(
            title: const Text('Contact Us'),
            onTap: () => contactUs(context),
          ),
          ListTile(
            title: const Text('Share App'),
            onTap: () => shareApp(context),
          ),
          ListTile(
            title: const Text('Delete Account'),
            onTap: () => deleteAccount(context),
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () => logout(context),
          ),
        ],
      ),
    );
  }
}

