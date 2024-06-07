
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../utils.dart';

class ProfileAvatar1 extends StatefulWidget {
  const ProfileAvatar1({Key? key}) : super(key: key);

  @override
  State<ProfileAvatar1> createState() => _ProfileAvatar1State();
}
class _ProfileAvatar1State extends State<ProfileAvatar1> {
  //File? imagei;
  String? myImagePath;
  String imageUrl = '';
  Uint8List? profileImage;
  PlatformFile? pickedFiles;

  UploadTask? uploadTask;
  TextEditingController nameController = TextEditingController();
  TextEditingController bController = TextEditingController();
  Utils utils = Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CircleAvatar(
            foregroundColor: Colors.white,
            radius: 60,
            child: Stack(
              children: [
                // ClipOval(
                //     child: profileImage!=null
                //         ?
                //          const Image(
                //             image: AssetImage(
                //               'assets/images/profile.png',
                //             ),
                //             width: 180,
                //             height: 170,
                //           ):
                //     Image.network(
                //       imageUrl,
                //
                //       width: 300,
                //       height: 100,
                //       fit: BoxFit.fill,
                //     )
                //
                //
                //
                //
                //
                //
                //
                // ),
                profileImage != null
                    ? CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(profileImage!),
                )
                    : const Image(
                  image: AssetImage(
                    'assets/images/profile.png',
                  ),
                  width: 180,
                  height: 170,
                ),

                Positioned(
                  //top: 40,
                  bottom: 20,
                  left: 80,
                  child: InkWell(
                    onTap: () =>
                    // selectedFile();
                    andriodModalBottomSheet(context),
                    child: const FaIcon(
                      FontAwesomeIcons.camera,
                      color: Color(0xffffb702),
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            textInputAction: TextInputAction.done,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.emailAddress,
            controller: nameController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF000000),
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                fillColor: Colors.purple.withOpacity(0.2),
                filled: true,
                prefixIcon: const Icon(
                  Icons.mail,
                  color: Colors.purple,
                )),

          ),
          TextField(
            textInputAction: TextInputAction.done,
            keyboardAppearance: Brightness.dark,
            keyboardType: TextInputType.emailAddress,
            controller: bController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Bio",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Color(0xFF000000),
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                fillColor: Colors.purple.withOpacity(0.2),
                filled: true,
                prefixIcon: const Icon(
                  Icons.mail,
                  color: Colors.purple,
                )),

          ),
          ElevatedButton(onPressed: ()=>saveProfileImage(), child: Text('Save')),
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
              onPressed: () =>selectImage(),
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
                  selectImage(),

              icon: const Icon(Icons.image_outlined),
              label: const Text('Gallery'))
        ],
      ),
    );
  }
  Future saveProfileImage() async {
    String msg = await saveData(
        name: nameController.text, bio: bController.text, file: profileImage!);
  }

  Future selectImage() async {
    Uint8List myImage = await utils.pickMyImage(ImageSource.gallery);
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
      {required String name,
        required String bio,
        required Uint8List file}) async {
    String msg = 'Some error occur';
    try {
      if (bio.isNotEmpty || name.isNotEmpty) {
        String myImageUrl = await uploadImageToStorage('mystorage', file);
        await firestore
            .collection('userProfile')
            .add({'name': name, 'bio': bio, 'imageLink': myImageUrl});
        msg = 'success';
      }
    } catch (error) {
      msg = error.toString();
    }
    return msg;
  }
}


