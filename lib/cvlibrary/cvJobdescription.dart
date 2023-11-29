import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class CvJobDetailsPage extends StatefulWidget {
  const CvJobDetailsPage({super.key, required this.cvJobdetails});
  final Job cvJobdetails;

  @override
  State<CvJobDetailsPage> createState() => _CvJobDetailsPageState();
}

class _CvJobDetailsPageState extends State<CvJobDetailsPage> {
  ApiServices jobApi = ApiServices();
  launchJob1() async {
    final url = Uri.parse("https://www.cv-library.co.uk${widget.cvJobdetails.url}");
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
                color: Colors.blue,
                child: GestureDetector(
                  child: const Center(child: Text('Apply Now')),
                  onTap: () {
                    launchJob1();
                  },
                ),
              ),
              appBar: AppBar(
                title: const Text(
                  'search Job page',
                  style: TextStyle(fontFamily: 'Kanit-Bold'),
                ),
              ),
              body: SafeArea(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //color: Colors.black,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.cvJobdetails.hlTitle.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-ExtraBold',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.cvJobdetails.agency!.title.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-ExtraBold',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.cvJobdetails.location.toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins-ExtraBold',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black54,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Card(
                          // width: MediaQuery.of(context).size.width,
                          // height: 700,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                  widget.cvJobdetails.description.toString()),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          color: Colors.black54,
                        ),
                        Card(
                          child: Text(
                            widget.cvJobdetails.type.toString(),
                            style: const TextStyle(
                                fontFamily: 'Poppins-Black',
                                fontSize: 26,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
