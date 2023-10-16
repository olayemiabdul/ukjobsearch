import 'package:flutter/material.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionPagem extends StatefulWidget {
  DescriptionPagem({super.key, required this.jobdetailsm});
  final Result jobdetailsm;

  @override
  State<DescriptionPagem> createState() => _DescriptionPagemState();
}

class _DescriptionPagemState extends State<DescriptionPagem> {
  ApiServices jobApi = ApiServices();
  launchJob() async {
    final url = Uri.parse(widget.jobdetailsm.jobUrl.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
        create: (BuildContext context) => FavouritesJob(),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              bottomSheet: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.amberAccent,
                child: GestureDetector(
                  child: Center(child: Text('Apply Now')),
                  onTap: () {
                    launchJob();
                  },
                ),
              ),
              appBar: AppBar(
                title: Text(
                  'search Job page',
                  style: TextStyle(fontFamily: 'Kanit-Bold'),
                ),
              ),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.black,
                  child: ListView(
                    children: [
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    child: Text(
                                      widget.jobdetailsm.jobTitle.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins-ExtraBold',
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    child: Text(
                                      widget.jobdetailsm.employerName
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins-ExtraBold',
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    child: Text(
                                      widget.jobdetailsm.locationName
                                          .toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins-ExtraBold',
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Text(
                                  widget.jobdetailsm.jobDescription.toString()),
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.black54,
                            ),
                            Card(
                              child: Text(
                                  widget.jobdetailsm.locationName.toString()),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        color: Colors.amberAccent,
                        child: GestureDetector(
                          child: Center(child: Text('Apply Now')),
                          onTap: () {
                            final provider = Provider.of<FavouritesJob>(context, listen: false);
                            launchJob();
                            provider.appliedJob(widget.jobdetailsm);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
