import 'package:agsecure/forms/home.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({Key? key}) : super(key: key);

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   late TextEditingController emailController;
//   late TextEditingController passwordController;
//   bool obscurePassword = true;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> loginUser() async {
//     setState(() => isLoading = true);

//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));

//       // TODO: Navigate to Home Page after login
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'user-not-found') {
//         message = 'No user found for that email.';
//       } else if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//       } else {
//         message = e.message ?? 'Login failed';
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   // 📌 Forgot Password Function
//   void showForgotPasswordDialog() {
//     final TextEditingController resetEmailController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Reset Password"),
//         content: TextField(
//           controller: resetEmailController,
//           decoration: const InputDecoration(
//             labelText: "Enter your email",
//             prefixIcon: Icon(Icons.email),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               if (resetEmailController.text.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text("Please enter an email")),
//                 );
//                 return;
//               }

//               try {
//                 await FirebaseAuth.instance.sendPasswordResetEmail(
//                   email: resetEmailController.text.trim(),
//                 );

//                 Navigator.pop(context);

//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text(
//                       "Password reset email sent! Check your inbox.",
//                     ),
//                   ),
//                 );
//               } catch (e) {
//                 ScaffoldMessenger.of(
//                   context,
//                 ).showSnackBar(SnackBar(content: Text(e.toString())));
//               }
//             },
//             child: const Text("Send"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTextField(
//           controller: emailController,
//           hintText: 'Email Address',
//           icon: Icons.email_outlined,
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 16),
//         CustomTextField(
//           controller: passwordController,
//           hintText: 'Password',
//           icon: Icons.lock_outlined,
//           obscureText: obscurePassword,
//           suffixIcon: GestureDetector(
//             onTap: () => setState(() => obscurePassword = !obscurePassword),
//             child: Icon(
//               obscurePassword ? Icons.visibility_off : Icons.visibility,
//               color: const Color(0xFF999999),
//             ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: showForgotPasswordDialog,
//             child: const Text(
//               'Forgot Password?',
//               style: TextStyle(
//                 color: Color(0xFF2D5F2E),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isLoading ? null : loginUser,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2D5F2E),
//             minimumSize: const Size(double.infinity, 56),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 3,
//           ),
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//         ),
//         const SizedBox(height: 18),
//         Row(
//           children: [
//             const Expanded(
//               child: Divider(color: Color(0xFFDDDDDD), thickness: 1),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 'Or continue with',
//                 style: TextStyle(color: Color(0xFF999999), fontSize: 12),
//               ),
//             ),
//             const Expanded(
//               child: Divider(color: Color(0xFFDDDDDD), thickness: 1),
//             ),
//           ],
//         ),
//         const SizedBox(height: 18),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
//             SocialButton(icon: Icons.facebook, onTap: () {}),
//             SocialButton(icon: Icons.apple, onTap: () {}),
//           ],
//         ),
//       ],
//     );
//   }
// }
// import 'package:flutter/material.dart';
//sdjfnaikjfnaifjnaiefjanfeijn
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/social_button.dart';
// import 'forgot_password_screen.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({super.key});

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   late TextEditingController emailController;
//   late TextEditingController passwordController;

//   bool obscurePassword = true;
//   bool isLoading = false;
//   bool rememberMe = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeFirebase();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     loadUserEmailPassword();
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//   }

//   // Load saved login data
//   void loadUserEmailPassword() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool remember = prefs.getBool("remember_me") ?? false;

//     if (remember) {
//       setState(() {
//         rememberMe = true;
//         emailController.text = prefs.getString("email") ?? "";
//         passwordController.text = prefs.getString("password") ?? "";
//       });
//     }
//   }

//   // Save login data if Remember Me is ticked
//   void handleRememberMe() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (rememberMe) {
//       await prefs.setBool("remember_me", true);
//       await prefs.setString("email", emailController.text.trim());
//       await prefs.setString("password", passwordController.text.trim());
//     } else {
//       await prefs.setBool("remember_me", false);
//       await prefs.remove("email");
//       await prefs.remove("password");
//     }
//   }

//   // Log successful login to Firestore
//   Future<void> logLoginToFirestore(String email, String password) async {
//     try {
//       await FirebaseFirestore.instance.collection('login').add({
//         'email': email,
//         'password': password, // ⚠️ demo only
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       print(' Login logged to Firestore!');
//     } catch (e) {
//       print(' Error logging login: $e');
//     }
//   }

//   Future<void> loginUser() async {
//     setState(() => isLoading = true);

//     try {
//       // ignore: unused_local_variable
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       handleRememberMe(); // Save or remove login data

//       // Log login to Firestore
//       await logLoginToFirestore(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));

//       // Navigate to HomePage (example)
//       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//     } on FirebaseAuthException catch (e) {
//       String message = '';

//       if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//       } else if (e.code == 'user-not-found') {
//         message = 'Account not found for this email.';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email format.';
//       } else {
//         message = e.message ?? 'Login failed. Please try again.';
//       }

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTextField(
//           controller: emailController,
//           hintText: 'Email Address',
//           icon: Icons.email_outlined,
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 16),
//         CustomTextField(
//           controller: passwordController,
//           hintText: 'Password',
//           icon: Icons.lock_outline,
//           obscureText: obscurePassword,
//           suffixIcon: GestureDetector(
//             onTap: () => setState(() => obscurePassword = !obscurePassword),
//             child: Icon(
//               obscurePassword ? Icons.visibility_off : Icons.visibility,
//               color: const Color(0xFF999999),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),

//         // Remember Me + Forgot Password
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: rememberMe,
//                   activeColor: const Color(0xFF2D5F2E),
//                   onChanged: (val) {
//                     setState(() {
//                       rememberMe = val!;
//                     });
//                   },
//                 ),
//                 const Text("Remember Me", style: TextStyle(fontSize: 13)),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const ForgotPasswordScreen(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   color: Color(0xFF2D5F2E),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),

//         ElevatedButton(
//           onPressed: isLoading ? null : loginUser,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2D5F2E),
//             minimumSize: const Size(double.infinity, 56),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//         ),
//         const SizedBox(height: 20),

//         // Divider + Social Buttons
//         Row(
//           children: [
//             const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 'Or continue with',
//                 style: TextStyle(color: Color(0xFF999999), fontSize: 12),
//               ),
//             ),
//             const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
//           ],
//         ),
//         const SizedBox(height: 18),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
//             SocialButton(icon: Icons.facebook, onTap: () {}),
//             SocialButton(icon: Icons.apple, onTap: () {}),
//           ],
//         ),
//       ],
//     );
//   }
// }

//aifsdbajdfhbafhb
// import 'dart:convert'; // for utf8
// import 'package:crypto/crypto.dart'; // for hashing
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/social_button.dart';
// import 'forgot_password_screen.dart';
// import 'home.dart';

// class LoginForm extends StatefulWidget {
//   const LoginForm({super.key});

//   @override
//   State<LoginForm> createState() => _LoginFormState();
// }

// class _LoginFormState extends State<LoginForm> {
//   late TextEditingController emailController;
//   late TextEditingController passwordController;

//   bool obscurePassword = true;
//   bool isLoading = false;
//   bool rememberMe = false;

//   final _secureStorage = const FlutterSecureStorage();

//   @override
//   void initState() {
//     super.initState();
//     initializeFirebase();
//     emailController = TextEditingController();
//     passwordController = TextEditingController();
//     loadUserEmailPassword();
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//   }

//   // Load saved login data
//   void loadUserEmailPassword() async {
//     String? storedEmail = await _secureStorage.read(key: "email");
//     String? storedPassword = await _secureStorage.read(key: "password");

//     if (storedEmail != null && storedPassword != null) {
//       setState(() {
//         rememberMe = true;
//         emailController.text = storedEmail;
//         passwordController.text = storedPassword;
//       });
//     }
//   }

//   // Save login data if Remember Me is ticked
//   void handleRememberMe() async {
//     if (rememberMe) {
//       await _secureStorage.write(
//         key: "email",
//         value: emailController.text.trim(),
//       );
//       await _secureStorage.write(
//         key: "password",
//         value: passwordController.text.trim(),
//       );
//     } else {
//       await _secureStorage.delete(key: "email");
//       await _secureStorage.delete(key: "password");
//     }
//   }

//   // Log login to Firestore with hashed password
//   Future<void> logLoginToFirestore(String email, String password) async {
//     try {
//       var bytes = utf8.encode(password.trim());
//       var hashedPassword = sha256.convert(bytes).toString();

//       await FirebaseFirestore.instance.collection('login').add({
//         'email': email,
//         'passwordHash': hashedPassword,
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//       print('Login logged to Firestore!');
//     } catch (e) {
//       print('Error logging login: $e');
//     }
//   }

//   // Validate inputs
//   bool _validateInputs() {
//     if (emailController.text.trim().isEmpty ||
//         !RegExp(
//           r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
//         ).hasMatch(emailController.text.trim())) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter a valid email')),
//       );
//       return false;
//     }
//     if (passwordController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Please enter a password')));
//       return false;
//     }
//     return true;
//   }

//   Future<void> loginUser() async {
//     setState(() => isLoading = true);

//     try {
//       // Authenticate user
//       final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );

//       handleRememberMe(); // Save or remove login data

//       // Log login to Firestore (safe, no password)
//       //await logLoginToFirestore(emailController.text.trim());

//       // ✅ Fetch username from Firestore
//       final userDoc = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(credential.user!.uid)
//           .get();

//       final userName = userDoc.data()?['username'] ?? 'Users';

//       // ✅ Navigate to HomePage and pass the username
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomePage(userName: userName)),
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));
//     } on FirebaseAuthException catch (e) {
//       String message = '';
//       if (e.code == 'wrong-password') {
//         message = 'Incorrect password.';
//       } else if (e.code == 'user-not-found') {
//         message = 'Account not found for this email.';
//       } else if (e.code == 'invalid-email') {
//         message = 'Invalid email format.';
//       } else {
//         message = e.message ?? 'Login failed. Please try again.';
//       }
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(message)));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CustomTextField(
//           controller: emailController,
//           hintText: 'Email Address',
//           icon: Icons.email_outlined,
//           keyboardType: TextInputType.emailAddress,
//         ),
//         const SizedBox(height: 16),
//         CustomTextField(
//           controller: passwordController,
//           hintText: 'Password',
//           icon: Icons.lock_outline,
//           obscureText: obscurePassword,
//           suffixIcon: GestureDetector(
//             onTap: () => setState(() => obscurePassword = !obscurePassword),
//             child: Icon(
//               obscurePassword ? Icons.visibility_off : Icons.visibility,
//               color: const Color(0xFF999999),
//             ),
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Checkbox(
//                   value: rememberMe,
//                   activeColor: const Color(0xFF2D5F2E),
//                   onChanged: (val) {
//                     setState(() {
//                       rememberMe = val!;
//                     });
//                   },
//                 ),
//                 const Text("Remember Me", style: TextStyle(fontSize: 13)),
//               ],
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => const ForgotPasswordScreen(),
//                   ),
//                 );
//               },
//               child: const Text(
//                 'Forgot Password?',
//                 style: TextStyle(
//                   color: Color(0xFF2D5F2E),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         ElevatedButton(
//           onPressed: isLoading ? null : loginUser,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF2D5F2E),
//             minimumSize: const Size(double.infinity, 56),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           child: isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.white,
//                   ),
//                 ),
//         ),
//         const SizedBox(height: 20),
//         Row(
//           children: const [
//             Expanded(child: Divider(color: Color(0xFFDDDDDD))),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 'Or continue with',
//                 style: TextStyle(color: Color(0xFF999999), fontSize: 12),
//               ),
//             ),
//             Expanded(child: Divider(color: Color(0xFFDDDDDD))),
//           ],
//         ),
//         const SizedBox(height: 18),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
//             SocialButton(icon: Icons.facebook, onTap: () {}),
//             SocialButton(icon: Icons.apple, onTap: () {}),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'dart:convert'; // for utf8
import 'package:crypto/crypto.dart'; // for hashing
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_button.dart';
import 'forgot_password_screen.dart';
import 'home.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool obscurePassword = true;
  bool isLoading = false;
  bool rememberMe = false;

  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    initializeFirebase();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    loadUserEmailPassword();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Load saved login data
  void loadUserEmailPassword() async {
    String? storedEmail = await _secureStorage.read(key: "email");
    String? storedPassword = await _secureStorage.read(key: "password");

    if (storedEmail != null && storedPassword != null) {
      setState(() {
        rememberMe = true;
        emailController.text = storedEmail;
        passwordController.text = storedPassword;
      });
    }
  }

  // Save login data if Remember Me is ticked
  void handleRememberMe() async {
    if (rememberMe) {
      await _secureStorage.write(
        key: "email",
        value: emailController.text.trim(),
      );
      await _secureStorage.write(
        key: "password",
        value: passwordController.text.trim(),
      );
    } else {
      await _secureStorage.delete(key: "email");
      await _secureStorage.delete(key: "password");
    }
  }

  // Log login to Firestore with hashed password
  Future<void> logLoginToFirestore(String email, String password) async {
    try {
      var bytes = utf8.encode(password.trim());
      var hashedPassword = sha256.convert(bytes).toString();

      await FirebaseFirestore.instance.collection('login').add({
        'email': email,
        'passwordHash': hashedPassword,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Login logged to Firestore!');
    } catch (e) {
      print('Error logging login: $e');
    }
  }

  // Validate inputs
  bool _validateInputs() {
    if (emailController.text.trim().isEmpty ||
        !RegExp(
          r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$",
        ).hasMatch(emailController.text.trim())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }
    if (passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a password')));
      return false;
    }
    return true;
  }

  Future<void> loginUser() async {
    if (!_validateInputs()) return;

    setState(() => isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      handleRememberMe(); // Save or remove login data
      await logLoginToFirestore(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login successful")));

      String userName =
          userCredential.user?.displayName ?? emailController.text.trim();

      // Navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(userName: userName)),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else if (e.code == 'user-not-found') {
        message = 'Account not found for this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else {
        message = e.message ?? 'Login failed. Please try again.';
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          controller: emailController,
          hintText: 'Email Address',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        CustomTextField(
          controller: passwordController,
          hintText: 'Password',
          icon: Icons.lock_outline,
          obscureText: obscurePassword,
          suffixIcon: GestureDetector(
            onTap: () => setState(() => obscurePassword = !obscurePassword),
            child: Icon(
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xFF999999),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: rememberMe,
                  activeColor: const Color(0xFF2D5F2E),
                  onChanged: (val) {
                    setState(() {
                      rememberMe = val!;
                    });
                  },
                ),
                const Text("Remember Me", style: TextStyle(fontSize: 13)),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF2D5F2E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isLoading ? null : loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2D5F2E),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(child: Divider(color: Color(0xFFDDDDDD))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Or continue with',
                style: TextStyle(color: Color(0xFF999999), fontSize: 12),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFDDDDDD))),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SocialButton(icon: Icons.g_mobiledata, onTap: () {}),
            SocialButton(icon: Icons.facebook, onTap: () {}),
            SocialButton(icon: Icons.apple, onTap: () {}),
          ],
        ),
      ],
    );
  }
}
