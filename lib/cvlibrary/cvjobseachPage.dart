import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ukjobsearch/cvlibrary/cvjobpage.dart';
import 'package:ukjobsearch/cvlibrary/cvjobFilteredSearch.dart';

import 'package:ukjobsearch/model/networkservices.dart';

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
        //backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: Card(
            margin: EdgeInsets.all(1),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
            ),
            child: Expanded(
              child: GestureDetector(
                  onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CvLibraryFilteredSearch(),
                        ),
                      );
                    },
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    Text(
                      'All Jobs',
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
        ),
      ),
      body: Container(
        //height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            color: Colors.amber,
        child: const MycvJob(),
      ),
    );
  }
}
