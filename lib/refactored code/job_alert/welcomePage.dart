import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

import 'package:share_plus/share_plus.dart';
import '../profile_model.dart';
import '../../settings/setting_screen.dart';

class WelcomeHomeScreen extends StatefulWidget {
  const WelcomeHomeScreen({super.key});

  @override
  State<WelcomeHomeScreen> createState() => _WelcomeHomeScreenState();
}

class _WelcomeHomeScreenState extends State<WelcomeHomeScreen> {
  PlatformFile? pickedFiles;
  String? downloadUrl;
  bool isEditing = false;
  final formKey = GlobalKey<FormState>();
  //pdf file
  late PDFViewController? pdfViewController;
  int totalPages = 0;
  int currentPage = 0;

  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController preferredJobController = TextEditingController();
  final TextEditingController currentJobController = TextEditingController();

  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
    loadResume();
    if (userProfile != null) {
      currentJobController.text=userProfile?.currentJob??'';
      preferredJobController.text=userProfile?.preferredJob??'';
      firstNameController.text = userProfile?.firstName ?? '';
      lastNameController.text = userProfile?.lastName ?? '';
    }
  }

  Future<void> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        setState(() {
          userProfile = UserProfile.fromMap(doc.data()!);
          preferredJobController.text=userProfile?.preferredJob??'';
          currentJobController.text=userProfile?.currentJob??'';
          locationController.text = userProfile?.location ?? '';

          phoneController.text = userProfile?.phone ?? '';
        });
      }
    }
  }

  Future<void> updateUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final updatedProfile = {
        'preferredJob':preferredJobController.text,
        'currentJob':currentJobController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'location': locationController.text,
        'phone': phoneController.text,
        'customImageUrl': userProfile?.customImageUrl,
      };

      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .set(updatedProfile, SetOptions(merge: true));

      setState(() {
        userProfile = UserProfile(

          firstName: firstNameController.text,
          currentJob: currentJobController.text,
          preferredJob: preferredJobController.text,
          lastName: lastNameController.text,
          location: locationController.text,
          phone: phoneController.text,
          customImageUrl: userProfile?.customImageUrl,
        );
        isEditing = false;
      });
    }
  }


  Future<void> pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final user = FirebaseAuth.instance.currentUser;
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user!.uid}.jpg');

      await ref.putFile(File(image.path));
      final imageUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .update({'customImageUrl': imageUrl});

      setState(() {
        userProfile = UserProfile(
          location: userProfile?.location ?? '',
          phone: userProfile?.phone ?? '',
          customImageUrl: imageUrl,
        );
      });
    }
  }

  Future<void> pickAndUploadResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      final user = FirebaseAuth.instance.currentUser;
      final file = File(result.files.single.path!);
      final ref = FirebaseStorage.instance
          .ref()
          .child('resumes')
          .child('${user!.uid}_${result.files.single.name}');

      await ref.putFile(file);
      downloadUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('userProfiles')
          .doc(user.uid)
          .update({'resumeUrl': downloadUrl});

      setState(() {});
    }
  }

  Future<void> loadResume() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('userProfiles')
            .doc(user.uid)
            .get();

        if (doc.exists && doc.data()!.containsKey('resumeUrl')) {
          setState(() {
            downloadUrl = doc.data()!['resumeUrl'];
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading resume: $e');
    }
  }



  Widget buildProfileRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.green,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget buildProfileHeader() {
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Section
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userProfile?.customImageUrl != null
                        ? NetworkImage(userProfile!.customImageUrl!)
                        : user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: userProfile?.customImageUrl == null &&
                        user?.photoURL == null
                        ? const Icon(Icons.person, size: 65, color: Colors.grey)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: pickAndUploadImage,
                        tooltip: 'Update Profile Picture',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          if (!isEditing) ...[
            // Profile Information
            Center(
              child: Column(
                children: [
                  Text(
                    '${userProfile?.firstName ?? ''} ${userProfile?.lastName ?? ''}',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  buildInfoRow(
                    icon: FontAwesomeIcons.briefcase,
                    title: 'Current Job',
                    value: userProfile?.currentJob ?? 'Current Job',
                  ),

                  buildInfoRow(
                    icon: FontAwesomeIcons.briefcaseMedical,
                    title: 'Preferred Job',
                    value:   userProfile?.preferredJob ?? 'Preferred Job',
                  ),

                ],
              ),
            ),


            // Contact Information
            buildInfoRow(
              icon: FontAwesomeIcons.mapMarkerAlt,
              title: 'Location',
              value: userProfile?.location ?? 'Add location',
            ),

            buildInfoRow(
              icon: FontAwesomeIcons.phoneAlt,
              title: 'Phone',
              value: userProfile?.phone ?? 'Add phone number',
            ),

            buildInfoRow(
              icon: FontAwesomeIcons.envelope,
              title: 'Email',
              value: user?.email ?? 'Add email',
            ),
            const SizedBox(height: 24),

            // Edit Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () => setState(() => isEditing = true),
                icon: const Icon(Icons.edit),
                label: Text(
                  'Edit Profile',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ] else ...[
            // Edit Form
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildFormField(
                    controller: firstNameController,
                    label: 'First Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  buildFormField(
                    controller: lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  buildFormField(
                    controller: currentJobController,
                    label: 'Current Job',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 16),
                  buildFormField(
                    controller: preferredJobController,
                    label: 'Preferred Job',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 16),
                  buildFormField(
                    controller: locationController,
                    label: 'Location',
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  buildFormField(
                    controller: phoneController,
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => isEditing = false),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            updateUserProfile();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

// Helper Function for Info Row
  Widget buildInfoRow({required IconData icon, required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.green),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.lato(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green),
        ),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }
  Widget buildPDFViewer() {
    if (downloadUrl == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resume Preview',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Page ${currentPage + 1} of $totalPages',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 500,
            child: PDF(
              enableSwipe: true,
              defaultPage: currentPage,
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page ?? 0;
                  totalPages = total ?? 0;
                });
              },
              onViewCreated: (PDFViewController controller) {
                pdfViewController = controller;
                controller.getPageCount().then((count) {
                  setState(() {
                    totalPages = count ?? 0;
                  });
                });
              },
            ).cachedFromUrl(
              downloadUrl!,
              placeholder: (progress) => Center(
                child: CircularProgressIndicator(
                  value: progress,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
              errorWidget: (error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 8),
                    Text(
                      'Error loading PDF: $error',
                      style: GoogleFonts.poppins(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: currentPage > 0
                      ? () async {
                    setState(() {
                      if (currentPage > 0) {
                        currentPage--;
                      }
                    });
                    await pdfViewController?.setPage(currentPage);
                  }
                      : null,
                  color: currentPage > 0 ? Colors.green : Colors.grey,
                ),
                Text(
                  '${currentPage + 1} / $totalPages',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: currentPage < totalPages - 1
                      ? () async {
                    setState(() {
                      if (currentPage < totalPages - 1) {
                        currentPage++;
                      }
                    });
                    await pdfViewController?.setPage(currentPage);
                  }
                      : null,
                  color: currentPage < totalPages - 1 ? Colors.green : Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Semantics(
            label: 'Share Resume',
            child: IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {
                if (downloadUrl != null) {
                  Share.share('Here is my uploaded resume: $downloadUrl');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No resume uploaded to share.',
                        style: GoogleFonts.poppins(),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPageScreen()),
            ),
          ),
        ],

      ),
      body:  SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE0C2), // Top gradient color (peach-like)
                Color(0xFF7FFFD4), // Bottom gradient color (blue-like)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [

              const SizedBox(height: 24),
              buildProfileHeader(),
              const SizedBox(height: 24),
              buildPDFViewer(),


              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: pickAndUploadResume,
                        icon: const Icon(
                          Icons.upload_file,
                          color: Colors.black,
                        ),
                        label: Text(
                          'Upload Resume',
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(color: Colors.black, width: 2.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (downloadUrl != null) {
                            Share.share('Here is my uploaded resume: $downloadUrl');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No resume uploaded to share.',
                                  style: GoogleFonts.poppins(),
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Share Resume',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),




              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

