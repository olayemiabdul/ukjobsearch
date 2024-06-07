import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/reed_jobs/jobdecriptionpage.dart';
import 'package:ukjobsearch/reed_jobs/ReedFilteredJobscreen.dart';
import 'package:ukjobsearch/screen/underConstruction.dart';

import 'package:ukjobsearch/screen/welcomePage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../settings/contactPage.dart';
import '../screen/newUser.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final jobTitleController = TextEditingController();
  final cityController = TextEditingController();
  ApiServices jobApi = ApiServices();
  //late Future<List<Result>> futureFiles;
  String title = '';
  String town = '';

  @override
  void initState() {
    super.initState();
    // to rebuild the future builder anytime the tab changes
    setState(() {
      jobApi.getFilesApi(jobTitleController.text, cityController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder(
        future:
            jobApi.getFilesApi(jobTitleController.text, cityController.text),
        builder: (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
          if (snapshot.hasData) {
            final List<Result> ola = snapshot.data!;
            final provider = Provider.of<FavouritesJob>(context);

            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: ola.length,
                itemBuilder: (context, index) {
                  //var employerProfile = olayemi[index].employerProfileId;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 190,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Colors.green,
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                snapshot.data![index].jobTitle.toString(),
                                style: const TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                snapshot.data![index].employerName
                                    .toString(),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child:
                                  Text(ola[index].locationName.toString()),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "posted on ${ola[index].date.toString()}"),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                        //trailing:employerProfile !=null?Image.network(olayemi[index].employerProfileId):Image.asset('assets/images/emp.png'),
                        trailing: IconButton(
                            onPressed: () {
                              provider
                                  .toggleFavourite(jobApi.abcJob[index]);
                            },
                            icon: provider.likedJobs(jobApi.abcJob[index])
                                ? const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : const Icon(Icons.favorite_border)),
                        onTap: () {
                          //navigator must be of provider since going to a page with provider
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ChangeNotifierProvider.value (
                                value: provider,
                                child: DescriptionPage(jobDetails: jobApi.abcJob[index],),
                              )));
                        },
                      ),
                    ),
                  );
                });
          } else {
            return  Container(
              color: Colors.greenAccent,


            );
          }
        },
      ),
    );
  }
}
void termsOfService() async{
  // Implement navigation to Terms of Service page
  const privacyUrl='https://doc-hosting.flycricket.io/tuned-jobs-terms-of-use/cd72c851-b405-4ef2-926d-d9f92e850b54/terms';

  if (await canLaunch(privacyUrl)) {
    await launch(privacyUrl);
  } else {
    throw 'Could not launch $privacyUrl';
  }
}

privacyPolicy() async{
  const termsUrl='https://doc-hosting.flycricket.io/tuned-jobs-privacy-policy/d8474bc1-13cf-4365-9c1d-1d60a9051883/privacy';
  if (await canLaunch(termsUrl)) {
    await launch(termsUrl);
  } else {
    throw 'Could not launch $termsUrl';
  }

}
Future<void> signOutFromGoogle() async {
  final GoogleSignIn googleUser = GoogleSignIn();
  await googleUser.signOut();
  await FirebaseAuth.instance.signOut();
}
void signOutGoogle() async {
  final GoogleSignIn googleUser = GoogleSignIn();
  await googleUser.signOut();
  await FirebaseAuth.instance.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  // uid = null;
  // name = null;
  // userEmail = null;
  // imageUrl = null;

  print("User signed out of Google account");
}

Drawer drawerNew(BuildContext context) {
  //final provider = Provider.of<FavouritesJob>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.green,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/logo.jpg'),
            ),
          ),
          child: Text(
            '',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('About Us'),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const UnderConstructionPage ()),
            ),
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Terms and Conditions'),
          onTap: () => termsOfService(),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Privacy Policy'),
          onTap: () => privacyPolicy(),
        ),
        ListTile(
          leading: const Icon(Icons.border_color),
          title: const Text('Contact Us'),
          onTap: () => {Navigator.push(context, MaterialPageRoute(builder:(context){
             return const ContactUsPage();
          }))},
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () => {signOutGoogle() },
        ),
      ],
    ),
  );
}


