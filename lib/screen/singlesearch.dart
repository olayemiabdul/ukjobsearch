// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:ukjobsearch/screen/jobdecriptionpage.dart';

class mySearch extends StatefulWidget {
  const mySearch({super.key, required this.jobName, required this.jobCity});
  final String jobName;
  final String jobCity;

  @override
  State<mySearch> createState() => _mySearchState();
}

class _mySearchState extends State<mySearch> {
  ApiServices jobApi = ApiServices();
  // final cityController = TextEditingController();

  // final jobTitleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // to rebuild the future builder anytime the tab changes

    jobApi.getFilesApi(widget.jobName, widget.jobCity);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.black,
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
            child: Expanded(
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  Text(widget.jobName),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: jobApi.getFilesApi(widget.jobName, widget.jobCity),
          builder:
              (BuildContext context, AsyncSnapshot<List<Result>> snapshot) {
            if (snapshot.hasData) {
              List<Result> olayemi = snapshot.data!;
              final provider = Provider.of<FavouritesJob>(context);
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    //var employerProfile = olayemi[index].employerProfileId;
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
                                  olayemi[index].jobTitle.toString(),
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
                                  snapshot.data![index].employerName.toString(),
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(snapshot.data![index].locationName
                                    .toString()),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    "posted on ${snapshot.data![index].date.toString()}"),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(snapshot.data![index].currency
                                      .toString()),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(snapshot
                                        .data![index].minimumSalary
                                        .toString()),
                                  ),
                                  const Text('-'),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Text(snapshot
                                        .data![index].maximumSalary
                                        .toString()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //trailing:employerProfile !=null?Image.network(olayemi[index].employerProfileId):Image.asset('assets/images/emp.png'),
                          trailing: IconButton(
                              onPressed: () {
                                provider.toggleFavourite(jobApi.abcJob[index]);
                              },
                              icon: provider.likedjobs(jobApi.abcJob[index])
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border)),
                          onTap: () {
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
              return const Center(
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    value: 10,
                  ),
                ),
              );
            }
          },
        ),
      ),
    ));
  }
}
