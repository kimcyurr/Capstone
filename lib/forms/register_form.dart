// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import '../widgets/custom_text_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RegisterForm extends StatefulWidget {
//   const RegisterForm({Key? key}) : super(key: key);

//   @override
//   State<RegisterForm> createState() => _RegisterFormState();
// }

// enum Gender { male, female, other }

// class _RegisterFormState extends State<RegisterForm> {
//   late TextEditingController fullNameController;
//   late TextEditingController userNameController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController confirmPasswordController;

//   bool obscurePassword = true;
//   bool obscureConfirm = true;
//   bool agreeToTerms = false;
//   Gender? selectedGender;
//   bool showVerificationScreen = false;
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     fullNameController = TextEditingController();
//     userNameController = TextEditingController();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     confirmPasswordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     userNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> registerUser() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     if (selectedGender == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please select a gender")));
//       return;
//     }

//     try {
//       // Step 1: Create user in Firebase Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       currentUser = userCredential.user;

//       // Step 2: Send email verification
//       await currentUser!.sendEmailVerification();

//       // Step 3: Show verification screen
//       setState(() {
//         showVerificationScreen = true;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text(
//             "Verification email sent! Please check your inbox and verify.",
//           ),
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'weak-password') {
//         message = 'Password is too weak';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'Email already in use';
//       } else {
//         message = e.message ?? 'Registration failed';
//       }
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }

//   Future<void> checkEmailVerified() async {
//     await currentUser!.reload();
//     currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser!.emailVerified) {
//       // Hash password before saving
//       var bytes = utf8.encode(passwordController.text.trim());
//       var hashedPassword = sha256.convert(bytes).toString();

//       // Save user info to Firestore
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(currentUser!.uid)
//           .set({
//             'fullName': fullNameController.text.trim(),
//             'userName': userNameController.text.trim(),
//             'email': emailController.text.trim(),
//             'gender': selectedGender.toString().split('.').last,
//             'password': hashedPassword,
//             'createdAt': FieldValue.serverTimestamp(),
//           });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Email verified! Account created successfully."),
//         ),
//       );

//       // Navigate or reset form
//       setState(() {
//         showVerificationScreen = false;
//       });

//       // Optional: navigate to home page
//       // Navigator.pushReplacement(...);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Email not verified yet. Please check again."),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return showVerificationScreen
//         ? buildEmailVerificationScreen()
//         : buildRegistrationForm();
//   }

//   Widget buildRegistrationForm() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           CustomTextField(
//             controller: fullNameController,
//             hintText: 'Full Name',
//             icon: Icons.person_outline,
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: userNameController,
//             hintText: 'User Name',
//             icon: Icons.account_circle_outlined,
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: emailController,
//             hintText: 'Email Address',
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 14),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Gender',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: RadioListTile<Gender>(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text('Male'),
//                   value: Gender.male,
//                   groupValue: selectedGender,
//                   onChanged: (Gender? value) {
//                     setState(() {
//                       selectedGender = value;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: RadioListTile<Gender>(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text('Female'),
//                   value: Gender.female,
//                   groupValue: selectedGender,
//                   onChanged: (Gender? value) {
//                     setState(() {
//                       selectedGender = value;
//                     });
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: RadioListTile<Gender>(
//                   contentPadding: EdgeInsets.zero,
//                   title: const Text('Other'),
//                   value: Gender.other,
//                   groupValue: selectedGender,
//                   onChanged: (Gender? value) {
//                     setState(() {
//                       selectedGender = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: passwordController,
//             hintText: 'Password',
//             icon: Icons.lock_outlined,
//             obscureText: obscurePassword,
//             suffixIcon: GestureDetector(
//               onTap: () => setState(() => obscurePassword = !obscurePassword),
//               child: Icon(
//                 obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF999999),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: confirmPasswordController,
//             hintText: 'Confirm Password',
//             icon: Icons.lock_outlined,
//             obscureText: obscureConfirm,
//             suffixIcon: GestureDetector(
//               onTap: () => setState(() => obscureConfirm = !obscureConfirm),
//               child: Icon(
//                 obscureConfirm ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF999999),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           Row(
//             children: [
//               Checkbox(
//                 value: agreeToTerms,
//                 onChanged: (value) =>
//                     setState(() => agreeToTerms = value ?? false),
//                 activeColor: const Color(0xFF2D5F2E),
//               ),
//               Expanded(
//                 child: RichText(
//                   text: const TextSpan(
//                     style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
//                     children: [
//                       TextSpan(text: 'I agree to '),
//                       TextSpan(
//                         text: 'Terms',
//                         style: TextStyle(
//                           color: Color(0xFF2D5F2E),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       TextSpan(text: ' and '),
//                       TextSpan(
//                         text: 'Privacy Policy',
//                         style: TextStyle(
//                           color: Color(0xFF2D5F2E),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           ElevatedButton(
//             onPressed: agreeToTerms ? registerUser : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2D5F2E),
//               disabledBackgroundColor: const Color(0xFFCCCCCC),
//               minimumSize: const Size(double.infinity, 56),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//             ),
//             child: const Text(
//               'Create Account',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildEmailVerificationScreen() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.email_outlined, size: 100, color: Colors.green),
//             const SizedBox(height: 20),
//             const Text(
//               "Verify Your Email",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "A verification email has been sent to your inbox. "
//               "Please verify to activate your account.",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton.icon(
//               onPressed: checkEmailVerified,
//               icon: const Icon(Icons.check_circle_outline),
//               label: const Text("I’ve Verified"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2D5F2E),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextButton(
//               onPressed: () async {
//                 await currentUser!.sendEmailVerification();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Verification email re-sent.")),
//                 );
//               },
//               child: const Text("Resend Verification Email"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

//skjdfbsjkdfbdjf

// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import '../widgets/custom_text_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RegisterForm extends StatefulWidget {
//   const RegisterForm({Key? key}) : super(key: key);

//   @override
//   State<RegisterForm> createState() => _RegisterFormState();
// }

// enum Gender { male, female, other }

// class _RegisterFormState extends State<RegisterForm> {
//   // Controllers
//   late TextEditingController fullNameController;
//   late TextEditingController userNameController;
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   late TextEditingController confirmPasswordController;

//   // UI State
//   bool obscurePassword = true;
//   bool obscureConfirm = true;
//   bool agreeToTerms = false;
//   Gender? selectedGender;
//   bool showVerificationScreen = false;

//   // Firebase
//   User? currentUser;
//   late CollectionReference usersRef;

//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers
//     fullNameController = TextEditingController();
//     userNameController = TextEditingController();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     confirmPasswordController = TextEditingController();

//     // Initialize Firestore reference safely
//     usersRef = FirebaseFirestore.instance.collection('users');
//   }

//   @override
//   void dispose() {
//     fullNameController.dispose();
//     userNameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   // Register User
//   Future<void> registerUser() async {
//     if (passwordController.text != confirmPasswordController.text) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
//       return;
//     }

//     if (selectedGender == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Please select a gender")));
//       return;
//     }

//     if (!agreeToTerms) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("You must agree to Terms and Privacy Policy"),
//         ),
//       );
//       return;
//     }

//     try {
//       // 1️⃣ Create user in Firebase Auth
//       UserCredential userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       currentUser = userCredential.user;

//       // 2️⃣ Hash password
//       var bytes = utf8.encode(passwordController.text.trim());
//       var hashedPassword = sha256.convert(bytes).toString();

//       // 3️⃣ Prepare Firestore data
//       Map<String, dynamic> userData = {
//         'fullName': fullNameController.text.trim(),
//         'userName': userNameController.text.trim(),
//         'email': emailController.text.trim(),
//         'gender': selectedGender.toString().split('.').last,
//         'password': hashedPassword,
//         'createdAt': FieldValue.serverTimestamp(),
//       };

//       // 4️⃣ Save user data to Firestore
//       await usersRef.doc(currentUser!.uid).set(userData);

//       // 5️⃣ Send verification email
//       await currentUser!.sendEmailVerification();

//       // 6️⃣ Show verification screen
//       setState(() {
//         showVerificationScreen = true;
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Verification email sent! Please check your inbox."),
//         ),
//       );
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'weak-password') {
//         message = 'Password is too weak';
//       } else if (e.code == 'email-already-in-use') {
//         message = 'Email already in use';
//       } else {
//         message = e.message ?? 'Registration failed';
//       }
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     }
//   }

//   // Check email verification
//   Future<void> checkEmailVerified() async {
//     await currentUser!.reload();
//     currentUser = FirebaseAuth.instance.currentUser;

//     if (currentUser!.emailVerified) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Email verified! Account activated.")),
//       );
//       setState(() => showVerificationScreen = false);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Email not verified yet. Please check again."),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return showVerificationScreen
//         ? buildEmailVerificationScreen()
//         : buildRegistrationForm();
//   }

//   // Registration Form
//   Widget buildRegistrationForm() {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           CustomTextField(
//             controller: fullNameController,
//             hintText: 'Full Name',
//             icon: Icons.person_outline,
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: userNameController,
//             hintText: 'User Name',
//             icon: Icons.account_circle_outlined,
//           ),
//           const SizedBox(height: 14),
//           CustomTextField(
//             controller: emailController,
//             hintText: 'Email Address',
//             icon: Icons.email_outlined,
//             keyboardType: TextInputType.emailAddress,
//           ),
//           const SizedBox(height: 14),

//           // Gender selection
//           Align(
//             alignment: Alignment.centerLeft,
//             child: Text(
//               'Gender',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey[700],
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Row(
//             children: Gender.values.map((gender) {
//               return Expanded(
//                 child: RadioListTile<Gender>(
//                   contentPadding: EdgeInsets.zero,
//                   title: Text(gender.toString().split('.').last.capitalize()),
//                   value: gender,
//                   groupValue: selectedGender,
//                   onChanged: (Gender? value) {
//                     setState(() => selectedGender = value);
//                   },
//                 ),
//               );
//             }).toList(),
//           ),

//           const SizedBox(height: 14),

//           // Password
//           CustomTextField(
//             controller: passwordController,
//             hintText: 'Password',
//             icon: Icons.lock_outlined,
//             obscureText: obscurePassword,
//             suffixIcon: GestureDetector(
//               onTap: () => setState(() => obscurePassword = !obscurePassword),
//               child: Icon(
//                 obscurePassword ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF999999),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),

//           // Confirm Password
//           CustomTextField(
//             controller: confirmPasswordController,
//             hintText: 'Confirm Password',
//             icon: Icons.lock_outlined,
//             obscureText: obscureConfirm,
//             suffixIcon: GestureDetector(
//               onTap: () => setState(() => obscureConfirm = !obscureConfirm),
//               child: Icon(
//                 obscureConfirm ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF999999),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),

//           // Terms checkbox
//           Row(
//             children: [
//               Checkbox(
//                 value: agreeToTerms,
//                 onChanged: (value) =>
//                     setState(() => agreeToTerms = value ?? false),
//                 activeColor: const Color(0xFF2D5F2E),
//               ),
//               Expanded(
//                 child: RichText(
//                   text: const TextSpan(
//                     style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
//                     children: [
//                       TextSpan(text: 'I agree to '),
//                       TextSpan(
//                         text: 'Terms',
//                         style: TextStyle(
//                           color: Color(0xFF2D5F2E),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       TextSpan(text: ' and '),
//                       TextSpan(
//                         text: 'Privacy Policy',
//                         style: TextStyle(
//                           color: Color(0xFF2D5F2E),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),

//           ElevatedButton(
//             onPressed: agreeToTerms ? registerUser : null,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF2D5F2E),
//               disabledBackgroundColor: const Color(0xFFCCCCCC),
//               minimumSize: const Size(double.infinity, 56),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               elevation: 3,
//             ),
//             child: const Text(
//               'Create Account',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Verification Screen
//   Widget buildEmailVerificationScreen() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.email_outlined, size: 100, color: Colors.green),
//             const SizedBox(height: 20),
//             const Text(
//               "Verify Your Email",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "A verification email has been sent to your inbox. "
//               "Please verify to activate your account.",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),

//             ElevatedButton.icon(
//               onPressed: checkEmailVerified,
//               icon: const Icon(Icons.check_circle_outline),
//               label: const Text("I’ve Verified"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF2D5F2E),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//             ),

//             const SizedBox(height: 16),

//             TextButton(
//               onPressed: () async {
//                 await currentUser!.sendEmailVerification();
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Verification email re-sent.")),
//                 );
//               },
//               child: const Text("Resend Verification Email"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Extension to capitalize first letter
// extension StringCasingExtension on String {
//   String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
// }

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

enum Gender { male, female, other }

class _RegisterFormState extends State<RegisterForm> {
  // Controllers
  late TextEditingController fullNameController;
  late TextEditingController userNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  // UI State
  bool obscurePassword = true;
  bool obscureConfirm = true;
  bool agreeToTerms = false;
  Gender? selectedGender;
  bool showVerificationScreen = false;

  // Firebase
  User? currentUser;
  late CollectionReference usersRef;

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    fullNameController = TextEditingController();
    userNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // Initialize Firestore reference
    usersRef = FirebaseFirestore.instance.collection('users');
  }

  @override
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Register User
  Future<void> registerUser() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (selectedGender == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a gender")));
      return;
    }

    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to Terms and Privacy Policy"),
        ),
      );
      return;
    }

    try {
      // 1️⃣ Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      currentUser = userCredential.user;

      // 2️⃣ Hash password
      var bytes = utf8.encode(passwordController.text.trim());
      var hashedPassword = sha256.convert(bytes).toString();

      // 3️⃣ Prepare Firestore data
      Map<String, dynamic> userData = {
        'name': fullNameController.text.trim(), // <--- HomePage will fetch this
        'fullName': fullNameController.text.trim(),
        'userName': userNameController.text.trim(),
        'email': emailController.text.trim(),
        'gender': selectedGender.toString().split('.').last,
        'password': hashedPassword,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // 4️⃣ Save user data to Firestore
      await usersRef.doc(currentUser!.uid).set(userData);

      // 5️⃣ Send verification email
      await currentUser!.sendEmailVerification();

      // 6️⃣ Show verification screen
      setState(() {
        showVerificationScreen = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Verification email sent! Please check your inbox."),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else {
        message = e.message ?? 'Registration failed';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Check email verification
  Future<void> checkEmailVerified() async {
    await currentUser!.reload();
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser!.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email verified! Account activated.")),
      );
      setState(() => showVerificationScreen = false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email not verified yet. Please check again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return showVerificationScreen
        ? buildEmailVerificationScreen()
        : buildRegistrationForm();
  }

  // Registration Form
  Widget buildRegistrationForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomTextField(
            controller: fullNameController,
            hintText: 'Full Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: userNameController,
            hintText: 'User Name',
            icon: Icons.account_circle_outlined,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: emailController,
            hintText: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),

          // Gender selection
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Gender',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: Gender.values.map((gender) {
              return Expanded(
                child: RadioListTile<Gender>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(gender.toString().split('.').last.capitalize()),
                  value: gender,
                  groupValue: selectedGender,
                  onChanged: (Gender? value) {
                    setState(() => selectedGender = value);
                  },
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Password
          CustomTextField(
            controller: passwordController,
            hintText: 'Password',
            icon: Icons.lock_outlined,
            obscureText: obscurePassword,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => obscurePassword = !obscurePassword),
              child: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Confirm Password
          CustomTextField(
            controller: confirmPasswordController,
            hintText: 'Confirm Password',
            icon: Icons.lock_outlined,
            obscureText: obscureConfirm,
            suffixIcon: GestureDetector(
              onTap: () => setState(() => obscureConfirm = !obscureConfirm),
              child: Icon(
                obscureConfirm ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF999999),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Terms checkbox
          Row(
            children: [
              Checkbox(
                value: agreeToTerms,
                onChanged: (value) =>
                    setState(() => agreeToTerms = value ?? false),
                activeColor: const Color(0xFF2D5F2E),
              ),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    children: [
                      TextSpan(text: 'I agree to '),
                      TextSpan(
                        text: 'Terms',
                        style: TextStyle(
                          color: Color(0xFF2D5F2E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF2D5F2E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          ElevatedButton(
            onPressed: agreeToTerms ? registerUser : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2D5F2E),
              disabledBackgroundColor: const Color(0xFFCCCCCC),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Verification Screen
  Widget buildEmailVerificationScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.email_outlined, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Verify Your Email",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "A verification email has been sent to your inbox. "
              "Please verify to activate your account.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: checkEmailVerified,
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("I’ve Verified"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5F2E),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () async {
                await currentUser!.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Verification email re-sent.")),
                );
              },
              child: const Text("Resend Verification Email"),
            ),
          ],
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringCasingExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
