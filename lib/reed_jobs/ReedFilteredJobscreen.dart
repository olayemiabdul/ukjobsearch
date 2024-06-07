import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/reed_jobs/singlesearch.dart';

import '../provider/favouriteProvider.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => _SearchScreen1State();
}

class _SearchScreen1State extends State<SearchScreen1> {
  ApiServices jobApi = ApiServices();
  String title = '';
  String town = '';

  //late Future<ReedJob> futureFiles;
  final cityController = TextEditingController();

  final jobTitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // use this and just context, snapshot
    // since this page will navigate to a provider page, wrap it with chnagenotier used in the main 
    return ChangeNotifierProvider<FavouritesJob>(
      create: (BuildContext context) => FavouritesJob(),
      // builder must be added to avoid flutter error
      builder: (context, child) {
        // No longer throws
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'search Job page',
                style: TextStyle(fontFamily: 'Kanit-Bold'),
              ),
            ),
            body:Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: ListView(
                children: [
                  TextField(
                    //get the value of textfield
                    onChanged: (value) {
                      value = jobTitleController.text;
                    },
                    controller: jobTitleController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide:
                            BorderSide(width: 3, color: Colors.blueAccent),
                      ),
                      labelText: 'Job Title',
                      floatingLabelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    //get the value of textfield
                    onChanged: (value2) {
                      value2 = cityController.text;
                    },

                    controller: cityController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        //<-- SEE HERE
                        borderSide:
                            BorderSide(width: 3, color: Colors.blueAccent),
                      ),
                      labelText: 'Job City',
                      floatingLabelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.location_city,
                        color: Colors.green,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      final provider =
                          Provider.of<FavouritesJob>(context, listen: false);
                          //navigate to singlesearch page provider
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: mySearch(
                              jobName: jobTitleController.text, jobCity: cityController.text,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 66,
                      width: 10,
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
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                size: 15,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'search ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontFamily: 'Kanit-Bold'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // ignore: unnecessary_null_comparison

                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
