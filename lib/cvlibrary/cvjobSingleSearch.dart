
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';

class CvSingleSearch extends StatefulWidget {
  const CvSingleSearch({super.key, required this.cvjobName, required this.cvJobLocation});
  final String cvjobName;
  final String cvJobLocation;

  @override
  State<CvSingleSearch> createState() => _CvSingleSearchState();
}

class _CvSingleSearchState extends State<CvSingleSearch> {
  ApiServices jobApi = ApiServices();
  RefreshController refreshController = RefreshController(initialRefresh: true);
   onRefresh() async {
    await Future.delayed(
      const Duration(milliseconds: 10),
    );
    final result = jobApi.cvlibraryjob;

    print(result.length);
    refreshController.refreshCompleted();
    setState(() {
         result;
    });
  
    
  }

  onLoading() async {
    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    final result = jobApi.cvlibraryjob;
    refreshController.loadComplete();
    setState(() {
      result;
    });

   
  }

  @override
  void initState() {
    super.initState();
    // to rebuild the future builder anytime the tab changes

    jobApi.getCvLibraryJob(widget.cvjobName, widget.cvJobLocation);
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
        automaticallyImplyLeading: false,

        title: SizedBox(
          height: 40,
          child: Card(
            margin: const EdgeInsets.all(1),
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                Text(widget.cvjobName),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: jobApi.getCvLibraryJob(widget.cvjobName, widget.cvJobLocation),
          builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
            if (snapshot.hasData) {
              final List<Job> ola = snapshot.data!;
              final provider = Provider.of<FavouritesJob>(context);

              return SmartRefresher(
                controller: refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: () => onRefresh(),
                onLoading: () => onLoading(),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: ola.length,
                    itemBuilder: (context, index) {
                      //var employerProfile = ola[index].logo.toString();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 220,
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
                          child:
                             ListTile(
                              title: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data![index].hlTitle.toString(),
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
                                      snapshot.data![index].location.toString(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(ola[index].salary.toString()),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        "posted on ${ola[index].posted.toString()}"),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),


                              // leading: employerProfile != null
                              //     ? Image.network(
                              //         ola[index].logo.toString(),
                              //         width: 50,
                              //         height: 50,
                              //         alignment: Alignment.centerLeft,
                              //       )
                              //     : Image.asset('assets/images/emp.png'),
                              trailing: IconButton(
                                onPressed: () {
                                  provider.cvtoggleFavourite(jobApi.cvlibraryjob[index]);
                                },
                                icon: provider.cvlikedjobs(jobApi.cvlibraryjob[index])
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      )
                                    : const Icon(Icons.favorite_border),
                              ),
                              onTap: () {
                                // needs to be in provider state
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) => ChangeNotifierProvider.value (
                                      value: provider,
                                      child: CvJobDetailsPage(cvJobdetails: jobApi.cvlibraryjob[index]),
                                    ))
                                );
                              },
                            ),
                          ),
                        );
                    }),
              );
            } else {
              return SizedBox(
                           height: 30,
              );
            }
          },
        ),
    ),);
  }
}
