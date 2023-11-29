
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/networkservices.dart';

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
      Duration(milliseconds: 10),
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
      Duration(milliseconds: 100),
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
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  Text(widget.cvjobName),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: jobApi.getCvLibraryJob(widget.cvjobName, widget.cvJobLocation),
          builder: (BuildContext context, AsyncSnapshot<List<Job>> snapshot) {
            if (snapshot.hasData) {
              final List<Job> ola = snapshot.data!;
              //final provider = Provider.of<FavouritesJob>(context);
      
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
                            
                              // ignore: unnecessary_null_comparison
                              // leading: employerProfile != null
                              //     ? Image.network(
                              //         ola[index].logo.toString(),
                              //         width: 50,
                              //         height: 50,
                              //         alignment: Alignment.centerLeft,
                              //       )
                              //     : Image.asset('assets/images/emp.png'),
                              // trailing: IconButton(
                              //   onPressed: () {
                              //     provider.toggleFavourite(jobApi.abcJob[index]);
                              //   },
                              //   icon: provider.likedjobs(jobApi.abcJob[index])
                              //       ? const Icon(
                              //           Icons.favorite,
                              //           color: Colors.red,
                              //         )
                              //       : const Icon(Icons.favorite_border),
                              // ),
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: ((context) {
                              //         return DescriptionPagem(
                              //           jobdetailsm: jobApi.abcJob[index],
                              //         );
                              //       }),
                              //     ),
                              //   );
                              // },
                            ),
                          ),
                        );
                    }),
              );
            } else {
              return Align(
                child: SpinKitRing(
                  color: Colors.greenAccent,
                  size: 100,
                ),
                alignment: Alignment.center,
              );
            }
          },
        ),
    ),);
  }
}
