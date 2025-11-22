// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   User? user;
//   late CollectionReference usersRef;

//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     usersRef = FirebaseFirestore.instance.collection('users');
//   }

//   Future<DocumentSnapshot> getUserData() async {
//     if (user == null) throw Exception('No logged-in user');
//     return usersRef.doc(user!.uid).get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("No logged-in user found")),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(title: const Text('Profile'), centerTitle: true),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           final data = snapshot.data?.data() as Map<String, dynamic>?;

//           // Use Firebase Auth email if Firestore data is missing
//           final fullName = data?['fullName'] ?? 'Unknown';
//           final userName = data?['userName'] ?? 'Unknown';
//           final gender = data?['gender'] ?? 'Unknown';
//           final email = user?.email ?? 'Unknown';

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 // Profile Avatar
//                 CircleAvatar(
//                   radius: 50,
//                   backgroundColor: Colors.green[200],
//                   child: Text(
//                     fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
//                     style: const TextStyle(fontSize: 40, color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Profile Card
//                 Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   elevation: 4,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 20,
//                       horizontal: 16,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         buildProfileRow('Full Name', fullName),
//                         const Divider(),
//                         buildProfileRow('Username', userName),
//                         const Divider(),
//                         buildProfileRow('Email', email),
//                         const Divider(),
//                         buildProfileRow('Gender', gender),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 30),

//                 // Logout Button
//                 ElevatedButton.icon(
//                   onPressed: () async {
//                     await FirebaseAuth.instance.signOut();
//                     if (mounted) Navigator.pop(context);
//                   },
//                   icon: const Icon(Icons.logout),
//                   label: const Text('Logout'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red[600],
//                     minimumSize: const Size(double.infinity, 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Helper widget for a single row
//   Widget buildProfileRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Text(
//             '$title: ',
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           ),
//           Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  late CollectionReference usersRef;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    usersRef = FirebaseFirestore.instance.collection('users');
  }

  Future<DocumentSnapshot> getUserData() async {
    if (user == null) throw Exception('No logged-in user');
    return usersRef.doc(user!.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No logged-in user found")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: const Text(
          'My Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final fullName = data?['fullName'] ?? 'Unknown';
          final email = user?.email ?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header Section
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Profile Picture with Camera Icon
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            child: Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Email
                      Text(
                        email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),

                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to edit profile
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D5F2E),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Menu Items Section
                // Container(
                //   color: Colors.white,
                //   child: Column(
                //     children: [
                //       _buildMenuItem(
                //         icon: Icons.favorite_outline,
                //         title: 'Favourites',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.download_outlined,
                //         title: 'Downloads',
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 12),

                // Settings Section
                // Container(
                //   color: Colors.white,
                //   child: Column(
                //     children: [
                //       _buildMenuItem(
                //         icon: Icons.language_outlined,
                //         title: 'Language',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.location_on_outlined,
                //         title: 'Location',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.display_settings_outlined,
                //         title: 'Display',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.feed_outlined,
                //         title: 'Feed preference',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.card_membership_outlined,
                //         title: 'Subscription',
                //         onTap: () {},
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 12),

                // Cache & History Section
                // Container(
                //   color: Colors.white,
                //   child: Column(
                //     children: [
                //       _buildMenuItem(
                //         icon: Icons.delete_outline,
                //         title: 'Clear Cache',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.history,
                //         title: 'Clear history',
                //         onTap: () {},
                //       ),
                //       _buildMenuItem(
                //         icon: Icons.logout,
                //         title: 'Log Out',
                //         iconColor: Colors.red,
                //         onTap: () async {
                //           await FirebaseAuth.instance.signOut();
                //           if (mounted) Navigator.pop(context);
                //         },
                //         showDivider: false,
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 24),

                // App Version
                // Text(
                //   'App version 003',
                //   style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                // ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? Colors.grey[700], size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: iconColor ?? Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.grey[200], indent: 60),
      ],
    );
  }
}
