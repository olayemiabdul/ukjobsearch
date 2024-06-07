import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/reed_jobs/jobdecriptionpage.dart';






class SavedJob extends StatefulWidget {
  const SavedJob({super.key});

  @override
  State<SavedJob> createState() => _SavedJobState();
}

class _SavedJobState extends State<SavedJob> {
  ApiServices jobApi = ApiServices();

  final jobTitleController = TextEditingController();

  final cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //title: const Text('saved Jobs'),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: jobApi.getFilesApi(
                jobTitleController.text, cityController.text),
            builder:
                (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
              if (snapshot.hasData) {
                // List<Result> reed = snapshot.data!;
                final provider = Provider.of<FavouritesJob>(context);
                //to get the job send to save page, use
                final reed = provider.reedJobs;


                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: reed.length,
                    itemBuilder: (context, index) {
                      //var employerProfile = reed[index].employerProfileId;
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
                                    reed[index].jobTitle.toString(),
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
                                    reed[index].employerName.toString(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(reed[index]
                                      .locationName
                                      .toString()),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "posted on ${reed[index].date.toString()}"),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                            //trailing:employerProfile !=null?Image.network(reed[index].employerProfileId):Image.asset('assets/images/emp.png'),
                            trailing: IconButton(
                                onPressed: () {
                                  provider
                                      .clearLikedJob(0);
                                },
                                icon:
                                    provider.likedJobs(jobApi.abcJob[index])
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
                return const SizedBox(
                  height: 70,
                  width: 100,
                  child: LinearProgressIndicator(
                    color: Colors.green,
                    value: 30,
                    minHeight: 20,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
class FavouriteCvJob extends StatefulWidget {
  const FavouriteCvJob({super.key});

  @override
  State<FavouriteCvJob> createState() => _FavouriteCvJobState();
}

class _FavouriteCvJobState extends State<FavouriteCvJob> {
  ApiServices jobApi = ApiServices();

  final cvTitleController = TextEditingController();

  final cvCityController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          //title: const Text('saved Jobs'),
        ),
        body: Consumer(

          builder: (BuildContext context, value, Widget? child) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder(
                future: jobApi.getCvLibraryJob(cvTitleController.text, cvCityController.text),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
                  if (snapshot.hasData) {

                    final provider = Provider.of<FavouritesJob>(context);
                    //to get the job send to save page, use
                    final cvLibrary = provider.cvApply;


                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: cvLibrary.length,
                        itemBuilder: (context, index) {
                          //var employerProfile = ola[index].logo.toString();
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
                                        cvLibrary[index].hlTitle.toString(),
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
                                        cvLibrary[index].location.toString(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(cvLibrary[index].salary.toString()),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          "posted on ${cvLibrary[index].posted.toString()}"),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                                // ignore: unnecessary_null_comparison
                                //leading refactored to prevent no  connectivity crash using try and catch
                                //leading: leadingWidget(employerProfile, ola, index),
                                trailing: IconButton(
                                    onPressed: () {
                                      provider.cvClearLikedJob(0);
                                    },
                                    icon:
                                    provider.cvlikedjobs(jobApi.cvlibraryjob[index])
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
                                        child: CvJobDetailsPage(cvJobdetails: jobApi.cvlibraryjob[index]),
                                      )));
                                },
                              ),
                            ),
                          );
                        });
                  } else {
                    return const SizedBox(
                      height: 20,
                      width: 50,
                      child: CircularProgressIndicator(

                        value: 10,
                        //minHeight: 20,

                        color: Colors.green,
                      ),
                    );
                  }
                },
              ),
            );
          },

        ),
      ),
    );
  }
}
