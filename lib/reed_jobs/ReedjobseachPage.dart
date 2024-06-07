
import 'package:flutter/material.dart';


import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/reed_jobs/ReedFilteredJobscreen.dart';
import 'package:ukjobsearch/reed_jobs/widget.dart';

class CvLibrarySearchPage extends StatefulWidget {
  const CvLibrarySearchPage({super.key});

  @override
  State<CvLibrarySearchPage> createState() => _CvLibrarySearchPageState();
}

class _CvLibrarySearchPageState extends State<CvLibrarySearchPage> {
  ApiServices jobApi = ApiServices();

  //late Future<ReedJob> futureFiles;
  final cityController = TextEditingController();

  final jobTitleController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //backgroundColor: Colors.black,
        title: Container(
          color: Colors.white,
          height: 40,
          child: GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen1(),
                    ),
                  );
                },
            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                SizedBox(width: 10,),
                Text(
                  'Search All Jobs',
                  style: TextStyle(
                      fontFamily: 'Kanit-Bold',
                      fontSize: 16,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            color: Colors.white,
        child: const MyWidget (),
      ),
    );
  }
}
