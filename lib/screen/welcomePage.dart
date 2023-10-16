import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';


class WelcomeHomeScreen extends StatefulWidget {
  WelcomeHomeScreen({Key? key}) : super(key: key);

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
  UploadTask? uploadTask; // for file download
  PlatformFile? savedFile;

  //select file from folder
  Future selectedFile() async {
    final selected = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (selected == null) return;
    setState(() {
      pickedFiles = selected.files.last;
      
    });
  }

  // Future saveFile() async {
  //   final saveDoc = await FilePicker.platform.saveFile(
  //     dialogTitle: 'Please select an output file:',
  //     fileName: 'output-file.pdf',
  //   );
  //   if (saveDoc == null) return;
  //   setState(() {
  //     savedFile=saveDoc.
  //   });
  // }

  //upload to cloud storage
  Future uploadFile() async {
    final path = 'mystorage/${pickedFiles!.path!}';
    final newfile = File(pickedFiles!.path!);
    final reference = FirebaseStorage.instance.ref().child(path);
    // reference.putFile(newfile);
    uploadTask = reference.putFile(newfile);
    final snapshot = await uploadTask!.whenComplete(() {});
    final linkDownload = await snapshot.ref.getDownloadURL();
    print('Download link:${linkDownload}');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var imageurl = user!.photoURL;
    DateTime selectedDate = DateTime.now();
    Widget title = ListTile(
      leading: Icon(Icons.input),
      title: Text('HomePage'),
      onTap: () => {},
    );
    Widget item1 = ListTile(
      leading: Icon(Icons.verified_user),
      title: Text('Profile'),
      onTap: () => {Navigator.of(context).pop()},
    );
    Widget item2 = ListTile(
      leading: Icon(Icons.settings),
      title: Text('Settings'),
      onTap: () => {Navigator.of(context).pop()},
    );
    Widget item3 = ListTile(
      leading: Icon(Icons.border_color),
      title: Text('Feedback'),
      onTap: () => {Navigator.of(context).pop()},
    );
    Widget item4 = ListTile(
      leading: Icon(Icons.exit_to_app),
      title: Text('Logout'),
      onTap: () => {signOutFromGoogle()},
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Colors.white,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            PopupMenuButton(
                // color: Colors.white,
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: title,
                        value: title,
                      ),
                      PopupMenuItem(
                        child: item1,
                        value: item1,
                      ),
                      PopupMenuItem(
                        child: item2,
                        value: item2,
                      ),
                      PopupMenuItem(
                        child: item3,
                        value: item3,
                      ),
                      PopupMenuItem(
                        child: item4,
                        value: item4,
                      )
                    ])
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              //to shift edit container to left
              padding: const EdgeInsets.only(left: 270),

              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
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
                  height: 40,
                  width: MediaQuery.of(context).size.width / 4,
                  child: Center(
                      child: Text(
                    'EDIT',
                    style: TextStyle(color: Colors.white),
                  )),
                ),
                onTap: () {
                  //implement edit
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              //gmail photo or upload photo
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Center(
                  child: imageurl != null
                      ? Image.network(user.photoURL!)
                      : CircleAvatar(radius: 60, child: ProfileAvatar())),
            ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Text(' Welcome',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  SizedBox(
                    width: 1,
                  ),
                  // Text(
                  //   user.displayName!,
                  //   // style: TextStyle(
                  //   //   fontFamily: 'Poppins Bold',
                  //   //   fontSize: 10,
                  //   //   color: Colors.brown,

                  //   // ),
                  //   style: Theme.of(context).textTheme.headlineSmall,
                  // ),

                  Text(
                    user.displayName!.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    "${selectedDate.year} - ${selectedDate.month} - ${selectedDate.day}",
                    style: TextStyle(
                      fontFamily: 'Poppins Bold',
                      fontSize: 14,
                      color: Colors.amberAccent,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Center(
                child: Text(
                  user.email!,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
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
                    padding: const EdgeInsets.only(bottom: 15),
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
            Container(
              height: 600,
              width: double.infinity,
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  pickedFiles != null
                      ? Expanded(
                          child: Center(
                            // child: Image.file(
                            //   File(pickedFiles!.path!),
                            //   height: 100,
                            //   width: 100,
                            //   fit: BoxFit.cover,
                            // ),
                            child: Container(
                                child: PDFView(
                                    filePath: pickedFiles?.path,
                                    enableSwipe: true,
                                    swipeHorizontal: true,
                                    pageFling: false,
                                    onRender: (pages) {
                                      setState(() {
                                        totalPages = pages!;
                                        isReady = true;
                                      });
                                    },
                                    onError: (error) {
                                      print(error.toString());
                                    },
                                    onPageError: (page, error) {
                                      print('$page: ${error.toString()}');
                                    },
                                    onViewCreated:
                                        (PDFViewController pdfViewController) {
                                      pdfViewController.getCurrentPage();
                                    },
                                    onPageChanged: (page, totalpages) {
                                      print('page change: $page/$totalpages');
                                    })),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 240),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Colors.green,
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            height: 40,
                            width: 210,
                            child: InkWell(
                              onTap: () {
                                selectedFile();
                              },
                              child: Center(
                                  child: Text(
                                'Select Cv',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )),
                            ),
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 79),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    height: 50,
                    width: 150,
                    child: InkWell(
                      onTap: () {
                       
                      },
                      child: Center(
                          child: Text(
                        'Share Resume',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                    height: 40,
                    width: 90,
                    child: InkWell(
                      onTap: () {
                        uploadFile();
                      },
                      child: Center(
                        child: Text(
                          'Upload',
                          style: TextStyle(color: Colors.green, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// to log out google user and user created using singup method
Future<void> signOutFromGoogle() async {
  final GoogleSignIn googleUser = await GoogleSignIn();
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
//     // TODO: implement shouldReclip
//     throw UnimplementedError();
//   }
// }

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({Key? key}) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? image;

  Future getNewImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemp = File(image.path); for temporary image upload
      final imagePer = await saveImageProfile(image.path);
      setState(() {
        this.image = imagePer;
      });
    } on PlatformException catch (e) {
      print('failed to picke image:$e');
    }
  }

  Future<File> saveImageProfile(String imagepath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagepath);
    final image = File('${directory.path}/$name');
    return File(imagepath).copy(image.path);
  }

  Future uploadImage(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
                onPressed: () =>
                    Navigator.of(context).pop(getNewImage(ImageSource.camera)),
                child: Text('Camera')),
            CupertinoActionSheetAction(
                onPressed: () =>
                    Navigator.of(context).pop(getNewImage(ImageSource.gallery)),
                child: Text('Gallery'))
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      return andriodModalBottomSheet(context);
    } else if (Platform.isWindows) {
      return andriodModalBottomSheet(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CircleAvatar(
        foregroundColor: Colors.white,
        radius: 60,
        child: Stack(
          children: [
            ClipOval(
                child: image != null
                    ? Image.file(
                        image!,
                        width: 300,
                        height: 100,
                        fit: BoxFit.fill,
                      )
                    : Image(
                        image: AssetImage(
                          'assets/images/profile.png',
                        ),
                        width: 180,
                        height: 170,
                      )),
            Positioned(
              //top: 40,
              bottom: 20,
              left: 80,
              child: InkWell(
                onTap: () {
                  uploadImage(context);
                },
                child: FaIcon(
                  FontAwesomeIcons.camera,
                  color: Color(0xffffb702),
                  size: 25,
                ),
              ),
            ),
          ],
        ),
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
              onPressed: () =>
                  Navigator.of(context).pop(getNewImage(ImageSource.camera)),
              icon: FaIcon(
                FontAwesomeIcons.camera,
              ),
              label: Text('Camera')),
          //  ListTile(
          //   leading:  Icon(Icons.browse_gallery),
          //   title: Text('Camera'),
          //   onTap: ()=>Navigator.of(context).pop(getNewImage(ImageSource.gallery)),
          // ),
          ElevatedButton.icon(
              onPressed: () =>
                  Navigator.of(context).pop(getNewImage(ImageSource.gallery)),
              icon: Icon(Icons.image_outlined),
              label: Text('Gallery'))
        ],
      ),
    );
  }
}

// class MyUpload extends StatefulWidget {
//   MyUpload({super.key});

//   @override
//   State<MyUpload> createState() => _MyUploadState();
// }

// class _MyUploadState extends State<MyUpload> {
//   //PDFViewController fileController;
//   int currentPage = 0;
//   int totalPages = 0;
//   bool isReady = false;
//   String errorMessage = '';
//   PlatformFile? pickedFiles;
//   UploadTask? uploadTask; // for file download
//   Future selectedFile() async {
//     final selected = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['jpg', 'pdf', 'doc'],
//     );
//     if (selected == null) return;
//     setState(() {
//       pickedFiles = selected.files.first;
//     });
//   }

//   Future uploadFile() async {
//     final path = 'mystorage/${pickedFiles!.path!}';
//     final newfile = File(pickedFiles!.path!);
//     final reference = FirebaseStorage.instance.ref().child(path);
//     // reference.putFile(newfile);
//     uploadTask = reference.putFile(newfile);
//     final snapshot = await uploadTask!.whenComplete(() {});
//     final linkDownload = await snapshot.ref.getDownloadURL();
//     print('Download link:${linkDownload}');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         if (pickedFiles != null)
//           Expanded(
//             child: Center(
//               // child: Image.file(
//               //   File(pickedFiles!.path!),
//               //   height: 100,
//               //   width: 100,
//               //   fit: BoxFit.cover,
//               // ),
//               child: Container(
//                   child: PDFView(
//                       filePath: pickedFiles?.path,
//                       enableSwipe: true,
//                       swipeHorizontal: true,
//                       pageFling: false,
//                       onRender: (pages) {
//                         setState(() {
//                           totalPages = pages!;
//                           isReady = true;
//                         });
//                       },
//                       onError: (error) {
//                         print(error.toString());
//                       },
//                       onPageError: (page, error) {
//                         print('$page: ${error.toString()}');
//                       },
//                       onViewCreated: (PDFViewController pdfViewController) {
//                         pdfViewController.getCurrentPage();
//                       },
//                       onPageChanged: (page, totalpages) {
//                         print('page change: $page/$totalpages');
//                       })),
//             ),
//           ),
//         SizedBox(
//           height: 50,
//         ),
//         Row(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 selectedFile();
//               },
//               child: Text('select'),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 uploadFile();
//               },
//               child: Text('upload'),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }
// }
