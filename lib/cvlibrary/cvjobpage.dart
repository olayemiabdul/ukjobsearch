import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/cvlibrary/cvJobdescription.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ukjobsearch/model/cvlibraryJob.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';

class MycvJob extends StatefulWidget {
  const MycvJob({super.key});

  @override
  State<MycvJob> createState() => _MycvJobState();
}

class _MycvJobState extends State<MycvJob> {
  ApiServices jobApi = ApiServices();

  RefreshController refreshController = RefreshController(initialRefresh: true);
  bool isnetworkOk = false;

  onRefresh() async {
    await Future.delayed(
      const Duration(milliseconds: 10),
    );
    final result = jobApi.cvlibraryjob;

    // print(result.length);
    // refreshController.refreshCompleted();
    // return result;

    // ignore: unnecessary_null_comparison
    if (result != null) {
      refreshController.refreshCompleted();
      return result;

      // ignore: unrelated_type_equality_checks
    } else if (result == jobApi.totalPage) {
      refreshController.loadNoData();
    } else {
      refreshController.refreshFailed();
    }
  }

  onLoading() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    var result = jobApi.cvlibraryjob;
    refreshController.loadComplete();
    setState(() {
      result.length;
    });
    print(result.length);
    return result;

    // ignore: unnecessary_null_comparison
    //   if (result != null) {
    //     refreshController.loadComplete();
    //   setState(() {});
    //  return result;
    //   } else if (result == jobApi.totalPage) {
    //     refreshController.loadNoData();
    //   } else {
    //     refreshController.loadFailed();
    //   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobApi.getCvLibraryJob('', '');
  }

  @override
  Widget build(BuildContext context) => cvjobWidget();

  SafeArea cvjobWidget() {
    return SafeArea(
      child: FutureBuilder(
        future: jobApi.getCvLibraryJob('', ''),
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
//leading refactored to prevent no  connectivity crash using try and catch
                          //leading: leadingWidget(employerProfile, ola, index),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) {
                                  return CvJobDetailsPage(cvJobdetails: jobApi.cvlibraryjob[index],
                                    
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: const Center(child: Text('check network')),
            );
          }
        },
      ),
    );
  }

  Widget leadingWidget(String employerProfile, List<Job> ola, int index) {
    
    try {
      return SizedBox(
        height: 10,
        width: 10,
        // ignore: unnecessary_null_comparison
        child: employerProfile != null
            ? Image.network(
                ola[index].logo.toString(),
                width: 50,
                height: 50,
                alignment: Alignment.centerLeft,
              )
            : Image.asset('assets/images/emp.png'),
      );
    } catch (e) {
      return const Text('Check Network connectivity');
    }
  }
}
