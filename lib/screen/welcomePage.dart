import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';


import 'package:flutter/services.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';


import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:ukjobsearch/cvlibrary/CvjobsearchHome.dart';
import 'package:ukjobsearch/provider/favouriteProvider.dart';

import 'package:ukjobsearch/utils.dart';

import '../settings/contactPage.dart';
import '../settings/setting_screen.dart';




class WelcomeHomeScreen extends StatefulWidget {
  const WelcomeHomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeHomeScreen> createState() => _WelcomeHomeScreenState();
}

class _WelcomeHomeScreenState extends State<WelcomeHomeScreen> {
  //pdf viwer variables
  int currentPage = 0;
  int totalPages = 0;
  bool isReady = false;
  String errorMessage = '';
  PlatformFile? pickedFiles;
  Future<File?>? pickedPdfFile;
  UploadTask? uploadTask; // for file download
  PlatformFile? savedFile;
  String linkUrl='';
  final user = FirebaseAuth.instance.currentUser;
  var overlayController=OverlayPortalController();




  Future<File?> loadPdfFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/picked_pdf.pdf';

    if (await File(filePath).exists()) {
      return File(filePath);
    }
    return null;
  }
  Future<void> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/picked_pdf.pdf';

      final savedFile = await pickedFile.copy(filePath);

      setState(() {
        pickedPdfFile = Future.value(savedFile);
      });
    }
  }



  //upload to cloud storage
  Future uploadFile() async {
    final path = 'storage/${pickedFiles!.name}';
    final newfile = File(pickedFiles!.path!);
    final reference = FirebaseStorage.instance.ref().child(path);
    //reference.putFile(newfile);
    setState(() {
      uploadTask = reference.putFile(newfile);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    final linkDownload = await snapshot.ref.getDownloadURL();
    print(linkDownload);
    setState(() {
      linkUrl=linkDownload;
    });
    return linkDownload;


  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPdfFile();

  }
  shareApp(BuildContext context) {
    Share.share('Check out this amazing app: https://play.google.com/store/apps/details?id=com.example.yourapp', // Replace with your app's Play Store URL
        subject: 'Share Our App');
  }
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouritesJob>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    var imageUrl = user!.photoURL;

    DateTime selectedDate = DateTime.now();

    Widget item1 = ListTile(
      leading: const Icon(Icons.verified_user),
      title: const Text('Profile'),
      onTap: () => {Navigator.of(context).pop()},
    );
    Widget item2 = ListTile(
      leading: const Icon(Icons.settings),
      title: const Text('Settings'),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ContactUsPage(),
        ),
      ),
    );
    Widget item3 = ListTile(
      leading: const Icon(Icons.border_color),
      title: const Text('Feedback'),
      onTap: () => {Navigator.of(context).pop()},
    );
    Widget title = ListTile(
      leading: const Icon(Icons.input),
      title: const Text('App info'),
      onTap: () => {

      },
    );
    Widget item4 = ListTile(
      leading: const Icon(Icons.exit_to_app),
      title: const Text('Logout'),
      onTap: () => {signOutFromGoogle()},
    );


    return ChangeNotifierProvider<FavouritesJob>(
      create: (BuildContext context) => FavouritesJob(),
      builder: (context, child) {

        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.green,
              title: const Text(
                'Profile',
                style: TextStyle(color: Colors.black),
              ),
              // actions: [
              //   PopupMenuButton(
              //       // color: Colors.white,
              //       itemBuilder: (context) => [
              //             PopupMenuItem(
              //               value: title,
              //               child: title,
              //             ),
              //             PopupMenuItem(
              //               value: item1,
              //               child: item1,
              //             ),
              //             PopupMenuItem(
              //               value: item2,
              //               child: item2,
              //             ),
              //             PopupMenuItem(
              //               value: item3,
              //               child: item3,
              //             ),
              //             PopupMenuItem(
              //               value: item4,
              //               child: item4,
              //             )
              //           ])
              // ],
              actions: [

                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      // row with 2 children
                      child: ElevatedButton(
                        onPressed: overlayController.toggle,
                       child: OverlayPortal(
                         controller: overlayController, overlayChildBuilder: (BuildContext context) {
                           return Positioned(
                             top: 250,
                             right: 40,
                             child: Container
                               (
                               decoration: const BoxDecoration(
                                 color: Colors.cyan,
                                 borderRadius: BorderRadius.all(Radius.circular(10))
                               ),
                               //color: Colors.green,
                               height: 330,
                               width: 300,
                               child:  const Column(
                                 children: [
                                   // const SizedBox(height: 140,),
                                   Padding(
                                     padding: EdgeInsets.all(8.0),
                                     child: Text('Welcome Tuned Jobs\nGrab your next desired dream Job here',
                                     style: TextStyle(color: Colors.white),),
                                   ),
                                   Image(image: AssetImage('assets/images/logo.jpg', ), height: 180,width: 260,),
                                   SizedBox(height: 2,),
                                   Text('Version 1.0.1\nDeveloper:olayemi.abdullahi@gmail.com\n07407208778', style: TextStyle(
                                     color: Colors.white
                                   ),)
                                 ],
                               ),
                             ),
                           );
                       },
                         child: const Text('App Info'),
                       ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ElevatedButton(onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const  SettingsPageScreen(),
                          ),
                        );
                      }, child: const Text('Settings'),)
                    ),
                    PopupMenuItem(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              shareApp(context);
                            },
                            icon: const Icon(Icons.share),
                          ),
                          const Text('share'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            body: Column(
              children: [


                Padding(
                  //gmail photo or upload photo
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Center(child: profilePhotoWidget(imageUrl, user), ),
                ),

                const Center(
                  child: Text(' Welcome Back',
                    ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 1,
                      ),
                      Center(child: nameWidget(user)),


                      emailWidget(user),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                const SizedBox(
                  height: 15,
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_add_outlined,
                        color: Colors.green,
                        size: 40,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text(
                          'My Cv',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins-Bold',
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(

                  child: FutureBuilder<File?>(
                    future: loadPdfFile(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.hasData && snapshot.data != null) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: SfPdfViewer.file(snapshot.data!),
                        );
                      } else {
                        return const Center(child: Text('No PDF selected'));
                      }
                    },
                  ),
                ),
                 ElevatedButton(
                  onPressed: pickPdfFile,

                  child: const Text('Update Cv'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 40),
                //   child: Row(
                //     children: [
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: const BorderRadius.only(
                //               topLeft: Radius.circular(10),
                //               topRight: Radius.circular(10),
                //               bottomLeft: Radius.circular(10),
                //               bottomRight: Radius.circular(10)),
                //           color: Colors.green,
                //           border: Border.all(
                //             color: Colors.white,
                //             width: 1,
                //           ),
                //         ),
                //         height: 50,
                //         width: 150,
                //         child: InkWell(
                //           onTap: () {
                //
                //           },
                //           child: const Center(
                //               child: Text(
                //             'Share Resume',
                //             style: TextStyle(color: Colors.white, fontSize: 20),
                //           )),
                //         ),
                //       ),
                //       const SizedBox(
                //         width: 5,
                //       ),
                //       Container(
                //         decoration: BoxDecoration(
                //           borderRadius: const BorderRadius.only(
                //               topLeft: Radius.circular(10),
                //               topRight: Radius.circular(10),
                //               bottomLeft: Radius.circular(10),
                //               bottomRight: Radius.circular(10)),
                //           color: Colors.white,
                //           border: Border.all(
                //             color: Colors.green,
                //             width: 2,
                //           ),
                //         ),
                //         height: 50,
                //         width: 150,
                //         child: ElevatedButton(
                //           onPressed: () =>uploadFile(), child: const   Center(
                //           child: Text(
                //             'Upload',
                //             style:
                //             TextStyle(color: Colors.green, fontSize: 20),
                //           ),
                //         ),
                //
                //         ),
                //       ),
                //     ],
                //   ),
                //
                // ),

              ],
            ),
          ),
        );
      },
    );
  }

  Widget profilePhotoWidget(String? imageurl, User user) {
    try {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: imageurl != null
            ? Image.network(user.photoURL.toString(), height: 30,width: 30,)
            :  const CircleAvatar(radius: 30, child:  ProfileAvatar()),
      );
    } catch (e) {
      return const Text('Check the connectivity');
    }
  }

  Widget nameWidget(User user) {
    try {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          user.displayName!,
          style: const TextStyle(
            fontFamily: 'Poppins Bold',
            fontSize: 10,
            color: Colors.brown,
          ),
          //   style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
    } catch (e) {
      return const Text('Check the connectivity');
    }
  }

  Widget emailWidget(User user) {
    try {
      return Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: Text(
            user.email.toString(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    } catch (e) {
      return const Text('check network');
    }
  }
}

// to log out google user and user created using singup method
Future<void> signOutFromGoogle() async {
  final GoogleSignIn googleUser = GoogleSignIn();
  await googleUser.signOut();
  await FirebaseAuth.instance.signOut();
}

// class CustomClipPath extends CustomClipper<Path> {
//   @override
//   getClip(Size size) {
//     return Path()
//       ..lineTo(0, size.height)
//       ..quadraticBezierTo(
//         size.width / 4,
//         size.height - 40,
//         size.width / 2,
//         size.height - 20,
//       )
//       ..quadraticBezierTo(
//         3 / 4 * size.width,
//         size.height,
//         size.width,
//         size.height - 30,
//       )
//       ..lineTo(size.width, 0);
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper oldClipper) {
//
//     throw UnimplementedError();
//   }
// }

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {

  PlatformFile? pickedFiles;


  UploadTask? uploadTask;

  Utils utils = Utils();


  Uint8List? profileImage;



  Future saveProfileImage() async {
    String msg = await saveData(
      file: profileImage!,  );
    return msg;
  }

  Future selectImageGallery() async {
    Uint8List myImage = await utils.pickMyImage(ImageSource.gallery);
    setState(() {
      profileImage = myImage;
    });
  }
  Future selectImageCamera() async {
    Uint8List myImage = await utils.pickMyImage(ImageSource.camera);
    setState(() {
      profileImage = myImage;
    });
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = storage.ref().child(childName).child('id');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData(

  {
  required Uint8List file}
        ) async {
    String msg = 'Some error occur';
    try {
      if (file!=null) {
        String myImageUrl = await uploadImageToStorage('mystorage', file);

        await firestore
            .collection('userProfile')
            .add({ 'imageLink': myImageUrl});
        msg = 'success';
      }
    } catch (error) {
      msg = error.toString();
    }
    return msg;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Column(
        children: [
          CircleAvatar(
            foregroundColor: Colors.white,
            radius: 60,
            child: Stack(
              children: [
                ClipOval(
                     child:  profileImage!=null
                         ?
                    Image(image: MemoryImage(profileImage!))
                         : const Image(
                       image: AssetImage(
                         'assets/images/profile.png',
                       ),
                       width: 180,
                       height: 170,
                     ),

                 ),


                Positioned(
                  //top: 40,
                  bottom: 20,
                  left: 80,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: (){
                          andriodModalBottomSheet(context);
                          saveProfileImage();





                        },
                          // selectedFile();

                        child: const FaIcon(
                          FontAwesomeIcons.camera,
                          color: Color(0xffffb702),
                          size: 25,
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
    );
  }

  Future andriodModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (builder) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ListTile(
          //   leading:  FaIcon(FontAwesomeIcons.camera,),
          //   title: Text('Camera'),
          //   onTap: ()=>Navigator.of(context).pop(getNewImage(ImageSource.camera)),
          // ),
          // SizedBox(height: 5,),
          ElevatedButton.icon(
              onPressed: () =>selectImageCamera() ,
              icon: const FaIcon(
                FontAwesomeIcons.camera,
              ),
              label: const Text('Camera')),
          //  ListTile(
          //   leading:  Icon(Icons.browse_gallery),
          //   title: Text('Camera'),
          //   onTap: ()=>Navigator.of(context).pop(getNewImage(ImageSource.gallery)),
          // ),
          ElevatedButton.icon(
              onPressed: () =>
                  selectImageGallery() ,


              icon: const Icon(Icons.image_outlined),
              label: const Text('Gallery'))
        ],
      ),
    );
  }

}









