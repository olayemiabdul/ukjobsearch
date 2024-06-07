import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ukjobsearch/cvlibrary/cvjobFilteredSearch.dart';
import 'package:ukjobsearch/cvlibrary/cvjobpage.dart';

import 'package:ukjobsearch/authentication/authScreen.dart';

import 'package:ukjobsearch/reed_jobs/widget.dart';

class JobSearchScreen extends StatefulWidget {
  const JobSearchScreen({super.key});

  @override
  State<JobSearchScreen> createState() => _JobSearchScreenState();
}

class _JobSearchScreenState extends State<JobSearchScreen> {
  bool selected = false;
  final user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        endDrawer: drawerNew(context),
        //bottomNavigationBar: BottomAppBar(child: myNewBar (), height: 105),
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,

          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Tuned Jobs!',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 2000),
              ),
            ],

            totalRepeatCount: 2,
            pause: const Duration(milliseconds: 1000),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          )
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: Colors.white,
            border: Border.all(
              color: Colors.green,
              width: 1,
            ),
          ),
          child: ListView(
            children: [
              user!=null?   const Text(''):Padding(
                padding: const EdgeInsets.only(left: 100),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 10),
                          curve: Curves.fastOutSlowIn,
                          width: selected ? 100.0 : 120.0,
                          height: selected ? 100.0 : 80.0,
                          //color: selected ? Colors.blueGrey : Colors.white,
                          alignment: selected
                              ? Alignment.center
                              : AlignmentDirectional.topCenter,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.black,
                              ),
                              TextButton(
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 24),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selected = !selected;
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ProfileAuth(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        child: Container(
                          width: 120,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.green,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 20,
                                color: Colors.white,
                              ),
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileAuth(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, left: 20),
                child: Container(
                  //bigger container
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  //color: const Color(0xff969FA6),
                  color: Colors.green,
                  child: Column(children: [
                    const Text(
                      'Tuned Jobs! Grab the desired dream Job here',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins-ExtraBold',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text('Jobs, employment & career development',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins-ExtraBold',
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 6,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CvLibraryFilteredSearch (),
                            ),
                          );
                        },
                        child: Container(
                          height: 46,
                          width: 290,
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
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    'search Jobs',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontFamily: 'Kanit-Bold'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: const MyCvJob(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
