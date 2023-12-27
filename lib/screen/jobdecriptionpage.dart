import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:ukjobsearch/model/jobdescription.dart';
import 'package:provider/provider.dart';
import 'package:ukjobsearch/model/networkservices.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';
import 'package:url_launcher/url_launcher.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key, required this.jobDetails});
  final Result jobDetails;

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  ApiServices jobApi = ApiServices();
  launchJob() async {
    final url = Uri.parse(widget.jobDetails.jobUrl.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouritesJob>(context);

          return SafeArea(
            child: Scaffold(
              bottomSheet: Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.amberAccent,
                child: GestureDetector(
                  child: const Center(child: Text('Apply Now')),
                  onTap: () {
                    launchJob();
                  },
                ),
              ),
              appBar: AppBar(

                title: const Text(
                  'Job Details ',
                  style: TextStyle(fontFamily: 'Kanit-Bold', color: Colors.black),
                ),
                actions: [
                  IconButton(onPressed: (){
                    Share.share(widget.jobDetails.jobUrl.toString());
                  }, icon: const Icon(Icons.share, color: Colors.deepOrangeAccent,),)
                ],
              ),
              body: SafeArea(

                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: ListView(
                    children: [

                      ListTile(
                        title: Column(
                          children: [
                            Text(
                              widget.jobDetails.jobTitle.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Poppins-ExtraBold',
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.jobDetails.employerName
                                    .toString(),
                                style: const TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',
                                    fontSize: 20,
                                    color: Colors.black54),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.deepOrange,),
                                const SizedBox(width: 15,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.jobDetails.locationName
                                        .toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 20,
                                        color: Colors.deepOrange),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.currency_pound, color: Colors.deepOrange,),
                                const SizedBox(width: 10,),
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.jobDetails.minimumSalary
                                            .toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins-ExtraBold',
                                            fontSize: 13,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    const Text('-'),

                                    const SizedBox(width: 5,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        widget.jobDetails.maximumSalary
                                            .toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins-ExtraBold',
                                            fontSize: 15,
                                            color: Colors.black),
                                      ),
                                    ),
                                    const Text('/', style: TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 15,
                                        color: Colors.black),)
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined, color: Colors.deepOrange,),
                                const SizedBox(width: 15,),
                                const Text('Expires', style:  TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',

                                    color: Colors.black),),
                                SizedBox(width: 3,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.jobDetails.expirationDate
                                        .toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        leading: const Image(image: AssetImage('assets/images/reedlogo.png', ),width: 35,height: 35,),
                        trailing:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                provider
                                    .toggleFavourite(widget.jobDetails);
                              },
                              icon: provider.likedjobs(widget.jobDetails)
                                  ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                                  : const Icon(Icons.favorite_border)),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [

                            Text(widget.jobDetails.applications.toString(), style: const TextStyle(
                                fontFamily: 'Poppins-ExtraBold',
                                fontSize: 20,
                                color: Colors.black),),
                            const SizedBox(width: 10,),
                            const Text('Applicants', style: TextStyle(
                                fontFamily: 'Poppins-ExtraBold',
                                fontSize: 20,
                                color: Colors.black),),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.black12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              widget.jobDetails.jobDescription.toString()),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          );

  }
}
