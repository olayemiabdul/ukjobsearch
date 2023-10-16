import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/screen/jobdecriptionpage.dart';
import 'package:ukjobsearch/screen/FilteredJobscreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ukjobsearch/screen/welcomePage.dart';

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

            return Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: ola.length,
                  itemBuilder: (context, index) {
                    //var employerProfile = olayemi[index].employerProfileId;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 170,
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
                                icon: provider.likedjobs(jobApi.abcJob[index])
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(Icons.favorite_border)),
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return DescriptionPagem(
                                  jobdetailsm: jobApi.abcJob[index],
                                );
                              })));
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return  Align(
              child: SpinKitRing(
                color: Colors.greenAccent,
                size: 100,
              
              ),
              alignment: Alignment.center,
            );
          }
        },
      ),
    );
  }
}

Future<void> signOutFromGoogle() async {
  final GoogleSignIn googleUser = GoogleSignIn();
  await googleUser.signOut();
  await FirebaseAuth.instance.signOut();
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
              image: AssetImage('assets/images/google.png'),
            ),
          ),
          child: Text(
            'Side menu',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text('About Us'),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen1()),
            ),
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user),
          title: const Text('Terms and Conditions'),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomeHomeScreen(),
              ),
            ),
          },
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Privacy Policy'),
          onTap: () => {
            Navigator.of(context).pop(),
          },
        ),
        ListTile(
          leading: const Icon(Icons.border_color),
          title: const Text('Contact Us'),
          onTap: () => {Navigator.of(context).pop()},
        ),
        ListTile(
          leading: const Icon(Icons.exit_to_app),
          title: const Text('Logout'),
          onTap: () => {signOutFromGoogle()},
        ),
      ],
    ),
  );
}
