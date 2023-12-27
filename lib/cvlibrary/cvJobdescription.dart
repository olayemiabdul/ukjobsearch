import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
    final provider = Provider.of<FavouritesJob>(context);
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
                // to remove default backButton
                automaticallyImplyLeading: false,
                leading:  IconButton(onPressed: ()  => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back),color: Colors.deepOrange,),


                title: const Text(
                  'Job Details ',
                  style: TextStyle(fontFamily: 'Kanit-Bold', color: Colors.black),
                ),
                actions: [
                  IconButton(onPressed: (){
                    Share.share("https://www.cv-library.co.uk${widget.cvJobdetails.url}");
                  }, icon: const Icon(Icons.share, color: Colors.deepOrangeAccent,),)
                ],
              ),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
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
                              widget.cvJobdetails.hlTitle.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Poppins-ExtraBold',
                                  fontSize: 20,
                                  color: Colors.black),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.cvJobdetails.agency!.title.toString(),

                                style: const TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',
                                    fontSize: 20,
                                    color: Colors.black54),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.deepOrange,),
                                const SizedBox(width: 10,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.cvJobdetails.location.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 15,
                                        color: Colors.deepOrange),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.currency_pound, color: Colors.deepOrange,),
                                const SizedBox(width: 10,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.cvJobdetails.salary.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 13,
                                        color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month_outlined, color: Colors.deepOrange,),
                                const SizedBox(width: 15,),
                                const Text('Posted', style:  TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',

                                    color: Colors.black),),
                                const SizedBox(width: 8,),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    widget.cvJobdetails.posted!.hour.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'Poppins-ExtraBold',
                                        fontSize: 20,
                                        color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                const Text('hrs', style:  TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',

                                    color: Colors.black),),
                                const SizedBox(width: 15,),
                                const Text('ago', style:  TextStyle(
                                    fontFamily: 'Poppins-ExtraBold',
                                    fontSize: 20,

                                    color: Colors.black),),
                              ],
                            ),

                          ],
                        ),
                        leading: const Image(image: AssetImage('assets/images/cvlogo.png', ),width: 35,height: 35,),
                        trailing:  Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              onPressed: () {
                                provider.cvtoggleFavourite(widget.cvJobdetails);

                              },
                              icon: provider.cvlikedjobs(widget.cvJobdetails)
                                  ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                                  : const Icon(Icons.favorite_border),),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                            const Text(' Type', style: TextStyle(
                                fontFamily: 'Poppins-ExtraBold',
                                fontSize: 20,
                                color: Colors.black),),
                            const SizedBox(width: 10,),

                            Text(widget.cvJobdetails.type.toString(), style: const TextStyle(
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
                          alignment: Alignment.center,
                          child: Text(
                              widget.cvJobdetails.description.toString()),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
