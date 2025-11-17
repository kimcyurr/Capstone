// import 'package:agsecure/forms/home.dart';
// import 'package:flutter/material.dart';
// import '../widgets/custom_text_field.dart';
// import 'package:firebase_auth/firebase_auth.dart';

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
//     if (!_validateInputs()) return;

//     setState(() => isLoading = true);

//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       handleRememberMe(); // Save or remove login data
//       await logLoginToFirestore(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));

//       String userName =
//           userCredential.user?.displayName ?? emailController.text.trim();

//       // Navigate to HomePage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomePage(userName: userName)),
//       );
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
//ksjdfbskjfsdkfjnsdfkjsfnskjfdn
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
// import 'admin_dashboard.dart'; // <-- import your admin page

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
//     if (!_validateInputs()) return;

//     setState(() => isLoading = true);

//     try {
//       // ---------------------------
//       // Check if admin credentials
//       // ---------------------------
//       if (emailController.text.trim() == "admin123@gmail.com" &&
//           passwordController.text.trim() == "admin123") {
//         handleRememberMe();

//         // Log admin login to Firestore
//         await logLoginToFirestore(
//           emailController.text.trim(),
//           passwordController.text.trim(),
//         );

//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text("Admin Login Successful")));

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => const AdminDashboard()),
//         );
//         return;
//       }

//       // ---------------------------
//       // Normal user login
//       // ---------------------------
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(
//             email: emailController.text.trim(),
//             password: passwordController.text.trim(),
//           );

//       handleRememberMe();

//       await logLoginToFirestore(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("Login successful")));

//       String userName =
//           userCredential.user?.displayName ?? emailController.text.trim();

//       // Navigate to HomePage
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => HomePage(userName: userName)),
//       );
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
import 'admin_dashboard.dart';

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

  // Log login to Firestore in login_history
  Future<void> logLoginToFirestore(String email, String password) async {
    try {
      var bytes = utf8.encode(password.trim());
      var hashedPassword = sha256.convert(bytes).toString();

      await FirebaseFirestore.instance.collection('login_history').add({
        'email': email,
        'passwordHash': hashedPassword,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('Login logged to Firestore!');
    } catch (e) {
      print('Error logging login: $e');
    }
  }

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
      // Admin login
      if (emailController.text.trim() == "admin123@gmail.com" &&
          passwordController.text.trim() == "admin123") {
        handleRememberMe();

        await logLoginToFirestore(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Admin Login Successful")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboard()),
        );
        return;
      }

      // Normal user login
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      handleRememberMe();

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
      ],
    );
  }
}
