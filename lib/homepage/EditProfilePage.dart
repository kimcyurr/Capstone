// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final picker = ImagePicker();

//   User? user = FirebaseAuth.instance.currentUser;
//   late CollectionReference usersRef;

//   // Controllers
//   final fullNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final userNameController = TextEditingController();
//   final genderController = TextEditingController();

//   bool isLoading = true;
//   File? profileImageFile;

//   @override
//   void initState() {
//     super.initState();
//     usersRef = FirebaseFirestore.instance.collection("users");
//     loadUserData();
//   }

//   Future<void> loadUserData() async {
//     if (user == null) return;

//     try {
//       DocumentSnapshot snap = await usersRef.doc(user!.uid).get();
//       Map<String, dynamic>? data = snap.data() as Map<String, dynamic>? ?? {};

//       fullNameController.text = data["fullName"] ?? "";
//       emailController.text = user?.email ?? "";
//       userNameController.text = data["userName"] ?? "";
//       genderController.text = data["gender"] ?? "";

//       setState(() => isLoading = false);
//     } catch (e) {
//       print("Error loading user profile: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => isLoading = true);

//     try {
//       // Update Firebase Auth email if changed
//       if (emailController.text.trim() != user!.email) {
//         await user!.updateEmail(emailController.text.trim());
//       }

//       // Update Firestore user data
//       await usersRef.doc(user!.uid).update({
//         "fullName": fullNameController.text.trim(),
//         "userName": userNameController.text.trim(),
//         "Gender": genderController.text.trim(),
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Profile updated successfully!"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       print("Error updating profile: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Failed to update profile"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() => isLoading = false);
//   }

//   Future pickImage() async {
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() {
//         profileImageFile = File(picked.path);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: Color(0xFF1A1A1A),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // Profile Picture
//                     GestureDetector(
//                       onTap: pickImage,
//                       child: CircleAvatar(
//                         radius: 55,
//                         backgroundColor: Colors.green.shade200,
//                         backgroundImage: profileImageFile != null
//                             ? FileImage(profileImageFile!)
//                             : null,
//                         child: profileImageFile == null
//                             ? const Icon(
//                                 Icons.camera_alt,
//                                 size: 40,
//                                 color: Colors.white,
//                               )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 20),

//                     // Full Name
//                     TextFormField(
//                       controller: fullNameController,
//                       decoration: inputStyle("Full Name"),
//                       validator: (v) =>
//                           v!.isEmpty ? "Full name is required" : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Email
//                     TextFormField(
//                       controller: emailController,
//                       decoration: inputStyle("Email"),
//                       validator: (v) => v!.isEmpty ? "Email is required" : null,
//                     ),
//                     const SizedBox(height: 15),

//                     // Gender
//                     TextFormField(
//                       controller: genderController,
//                       decoration: inputStyle("Gender"),
//                     ),
//                     const SizedBox(height: 15),

//                     // Username
//                     TextFormField(
//                       controller: userNameController,
//                       decoration: inputStyle("Username"),
//                     ),
//                     const SizedBox(height: 25),

//                     // Save Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: updateProfile,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2D5F2E),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           "Save Changes",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   InputDecoration inputStyle(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black87),
//       filled: true,
//       fillColor: Colors.white,
//       contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: BorderSide.none,
//       ),
//     );
//   }
// }

// extension on User {
//   Future<void> updateEmail(String trim) async {}
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();

  User? user = FirebaseAuth.instance.currentUser;
  late CollectionReference usersRef;

  // Controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final usernameController = TextEditingController();
  final genderController = TextEditingController();

  bool isLoading = true;
  File? profileImageFile;

  @override
  void initState() {
    super.initState();
    usersRef = FirebaseFirestore.instance.collection("users");
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (user == null) return;

    try {
      DocumentSnapshot snap = await usersRef.doc(user!.uid).get();
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>? ?? {};

      fullNameController.text = data["fullName"] ?? "";
      emailController.text = user?.email ?? "";
      usernameController.text = data["userName"] ?? "";
      genderController.text = data["gender"] ?? "";
      // contactController.text = data["contact"] ?? "";
      // addressController.text = data["address"] ?? "";

      setState(() => isLoading = false);
    } catch (e) {
      print("Error loading user profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Update Firebase Auth email
      if (emailController.text.trim() != user!.email) {
        await user!.updateEmail(emailController.text.trim());
      }

      // Update Firestore user profile
      await usersRef.doc(user!.uid).update({
        "fullName": fullNameController.text.trim(),
        "userName": usernameController.text.trim(),
        "Gender": genderController.text.trim(),
        // "contact": contactController.text.trim(),
        // "address": addressController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to update profile"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        profileImageFile = File(picked.path);
      });
      // (Optional) upload to Firebase Storage here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.green.shade200,
                        backgroundImage: profileImageFile != null
                            ? FileImage(profileImageFile!)
                            : null,
                        child: profileImageFile == null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Full Name
                    TextFormField(
                      controller: fullNameController,
                      decoration: inputStyle("Full Name"),
                      validator: (v) =>
                          v!.isEmpty ? "Full name is required" : null,
                    ),
                    const SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: inputStyle("Email"),
                      validator: (v) => v!.isEmpty ? "Email is required" : null,
                    ),
                    const SizedBox(height: 15),

                    // Username
                    TextFormField(
                      controller: usernameController,
                      decoration: inputStyle("Username"),
                    ),
                    const SizedBox(height: 15),

                    // Gender
                    TextFormField(
                      controller: genderController,
                      decoration: inputStyle("Gender"),
                    ),
                    const SizedBox(height: 15),

                    // Contact
                    // TextFormField(
                    //   controller: contactController,
                    //   decoration: inputStyle("Contact Number"),
                    // ),
                    // const SizedBox(height: 15),

                    // // Address
                    // TextFormField(
                    //   controller: addressController,
                    //   decoration: inputStyle("Address"),
                    //   maxLines: 2,
                    // ),
                    // const SizedBox(height: 20),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5F2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

extension on User {
  Future<void> updateEmail(String trim) async {}
}
