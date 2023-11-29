import 'package:flutter/material.dart';
import 'package:ukjobsearch/cvlibrary/cvjobSingleSearch.dart';

import 'package:ukjobsearch/model/networkservices.dart';

class CvLibraryFilteredSearch extends StatefulWidget {
   const CvLibraryFilteredSearch({super.key});
 

  @override
  State<CvLibraryFilteredSearch> createState() => _CvLibraryFilteredSearchState();
}

class _CvLibraryFilteredSearchState extends State<CvLibraryFilteredSearch> {
  ApiServices jobApi = ApiServices();
  String title = '';
  String town = '';

  final cityController = TextEditingController();

  final jobTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<FavouritesJob>(
    //   create: (BuildContext context) => FavouritesJob(),
    //   // builder must be added to avoid flutter error
    //   builder: (context, child) {
    // No longer throws
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
             
              SizedBox(width: 20,),
              Text(
                'search Job page',
                style: TextStyle(fontFamily: 'Kanit-Bold'),
              ),
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: [
              TextField(
                //get the value of textfield
                onChanged: (value) {
                  value = jobTitleController.text;
                },
                controller: jobTitleController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                   
                    borderSide: BorderSide(width: 3, color: Colors.blueAccent),
                  ),
                  labelText: 'Job Title',
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.engineering,
                    color: Colors.green,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                //get the value of textfield
                onChanged: (value2) {
                  value2 = cityController.text;
                },

                controller: cityController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.blueAccent),
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
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  // final provider =
                  //     Provider.of<FavouritesJob>(context, listen: false);
                  //     //navigate to singlesearch page provider
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ChangeNotifierProvider.value(
                  //       value: provider,
                  //       child: mySearch(
                  //         jobName: jobTitleController.text,
                  //       ),
                  //     ),
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CvSingleSearch(cvjobName: jobTitleController.text, cvJobLocation: cityController.text,),
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 15,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Align(
                            child: Text(
                              'search ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Kanit-Bold'),
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // ignore: unnecessary_null_comparison

              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
