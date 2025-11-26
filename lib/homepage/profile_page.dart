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
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // leading: IconButton(
//         //   icon: const Icon(Icons.arrow_back, color: Colors.black),
//         //   onPressed: () => Navigator.pop(context),
//         // ),
//         title: const Text(
//           'My Profile',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_outlined, color: Colors.black),
//             onPressed: () {
//               // Navigate to settings
//             },
//           ),
//         ],
//       ),
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
//           final fullName = data?['fullName'] ?? 'Unknown';
//           final email = user?.email ?? 'Unknown';

//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 // Profile Header Section
//                 Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(24),
//                   child: Column(
//                     children: [
//                       // Profile Picture with Camera Icon
//                       Stack(
//                         children: [
//                           CircleAvatar(
//                             radius: 60,
//                             backgroundColor: Colors.grey[300],
//                             child: Text(
//                               fullName.isNotEmpty
//                                   ? fullName[0].toUpperCase()
//                                   : '?',
//                               style: const TextStyle(
//                                 fontSize: 48,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 0,
//                             right: 0,
//                             child: Container(
//                               padding: const EdgeInsets.all(6),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                   color: Colors.grey[300]!,
//                                   width: 2,
//                                 ),
//                               ),
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 size: 18,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),

//                       // User Name
//                       Text(
//                         fullName,
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       const SizedBox(height: 4),

//                       // Email
//                       Text(
//                         email,
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                       ),
//                       const SizedBox(height: 20),

//                       // Edit Profile Button
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             // Navigate to edit profile
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF2D5F2E),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 14),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             elevation: 0,
//                           ),
//                           child: const Text(
//                             'Edit Profile',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 12),

//                 // Menu Items Section
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: Column(
//                 //     children: [
//                 //       _buildMenuItem(
//                 //         icon: Icons.favorite_outline,
//                 //         title: 'Favourites',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.download_outlined,
//                 //         title: 'Downloads',
//                 //         onTap: () {},
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 const SizedBox(height: 12),

//                 // Settings Section
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: Column(
//                 //     children: [
//                 //       _buildMenuItem(
//                 //         icon: Icons.language_outlined,
//                 //         title: 'Language',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.location_on_outlined,
//                 //         title: 'Location',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.display_settings_outlined,
//                 //         title: 'Display',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.feed_outlined,
//                 //         title: 'Feed preference',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.card_membership_outlined,
//                 //         title: 'Subscription',
//                 //         onTap: () {},
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 const SizedBox(height: 12),

//                 // Cache & History Section
//                 // Container(
//                 //   color: Colors.white,
//                 //   child: Column(
//                 //     children: [
//                 //       _buildMenuItem(
//                 //         icon: Icons.delete_outline,
//                 //         title: 'Clear Cache',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.history,
//                 //         title: 'Clear history',
//                 //         onTap: () {},
//                 //       ),
//                 //       _buildMenuItem(
//                 //         icon: Icons.logout,
//                 //         title: 'Log Out',
//                 //         iconColor: Colors.red,
//                 //         onTap: () async {
//                 //           await FirebaseAuth.instance.signOut();
//                 //           if (mounted) Navigator.pop(context);
//                 //         },
//                 //         showDivider: false,
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ),
//                 const SizedBox(height: 24),

//                 // App Version
//                 // Text(
//                 //   'App version 003',
//                 //   style: TextStyle(fontSize: 12, color: Colors.grey[400]),
//                 // ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     Color? iconColor,
//     bool showDivider = true,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//             child: Row(
//               children: [
//                 Icon(icon, color: iconColor ?? Colors.grey[700], size: 24),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: iconColor ?? Colors.black87,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ),
//                 Icon(Icons.chevron_right, color: Colors.grey[400], size: 24),
//               ],
//             ),
//           ),
//         ),
//         if (showDivider)
//           Divider(height: 1, thickness: 1, color: Colors.grey[200], indent: 60),
//       ],
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'ModuleDetailPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  late CollectionReference usersRef;

  List readingHistory = [];
  bool isLoadingHistory = true;

  final String backendBase = "http://192.168.123.33:3000";

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    usersRef = FirebaseFirestore.instance.collection('users');
    if (user != null) {
      fetchReadingHistory();
    }
  }

  Future<DocumentSnapshot> getUserData() async {
    if (user == null) throw Exception('No logged-in user');
    return usersRef.doc(user!.uid).get();
  }

  Future<void> fetchReadingHistory() async {
    if (user == null) return;

    try {
      final uri = Uri.parse(
        "$backendBase/api/reading-history/user/${user!.uid}",
      );
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        final List tempHistory = data
            .map((item) {
              final feature = item["featureId"];
              return feature != null
                  ? {
                      "_id": item["_id"],
                      "title": feature["title"],
                      "description": feature["description"],
                      "image": feature["image"],
                      "steps": feature["steps"],
                    }
                  : null;
            })
            .where((element) => element != null)
            .toList();

        setState(() {
          readingHistory = tempHistory;
          isLoadingHistory = false;
        });
      } else {
        setState(() => isLoadingHistory = false);
      }
    } catch (e) {
      setState(() => isLoadingHistory = false);
      print("Error fetching history: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No logged-in user found")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1A1A1A)),
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

          final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final fullName = data['fullName'] ?? 'Unknown';
          final email = user?.email ?? 'Unknown';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar with gradient border
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF6366F1),
                            child: Text(
                              fullName.isNotEmpty
                                  ? fullName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 20),
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
                      // Stats Row
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     _buildStatItem(
                      //       icon: Icons.auto_stories_outlined,
                      //       label: 'Modules',
                      //       value: '${readingHistory.length}',
                      //     ),
                      //     Container(
                      //       height: 40,
                      //       width: 1,
                      //       color: Colors.grey[300],
                      //     ),
                      //     _buildStatItem(
                      //       icon: Icons.access_time_outlined,
                      //       label: 'Hours',
                      //       value: '${readingHistory.length * 2}',
                      //     ),
                      //     Container(
                      //       height: 40,
                      //       width: 1,
                      //       color: Colors.grey[300],
                      //     ),
                      //     _buildStatItem(
                      //       icon: Icons.workspace_premium_outlined,
                      //       label: 'Streak',
                      //       value: '7',
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),

                // Reading History Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        ' History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      // if (readingHistory.isNotEmpty)
                      // TextButton(
                      //   onPressed: () {
                      //     // View all
                      //   },
                      //   child: const Text(
                      //     'View All',
                      //     style: TextStyle(
                      //       color: Color(0xFF6366F1),
                      //       fontWeight: FontWeight.w600,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                SizedBox(
                  height: 240,
                  child: isLoadingHistory
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            return Container(
                              width: 180,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(16),
                              ),
                            );
                          },
                        )
                      : readingHistory.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.book_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "No reading history yet",
                                style: TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Start exploring modules to see them here",
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: readingHistory.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (context, index) {
                            final feature = readingHistory[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ModuleDetailPage(feature: feature),
                                  ),
                                );
                              },
                              child: Container(
                                width: 180,
                                margin: EdgeInsets.only(
                                  right: index == readingHistory.length - 1
                                      ? 0
                                      : 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.06),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Stack(
                                        children: [
                                          feature["image"] != null
                                              ? Image.memory(
                                                  base64Decode(
                                                    feature["image"],
                                                  ),
                                                  width: double.infinity,
                                                  height: 130,
                                                  fit: BoxFit.cover,
                                                )
                                              : Container(
                                                  width: double.infinity,
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(
                                                          0xFF6366F1,
                                                        ).withOpacity(0.3),
                                                        Color(
                                                          0xFF8B5CF6,
                                                        ).withOpacity(0.3),
                                                      ],
                                                    ),
                                                  ),
                                                  child: const Icon(
                                                    Icons.menu_book_rounded,
                                                    size: 48,
                                                    color: Color(0xFF6366F1),
                                                  ),
                                                ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                  0.6,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    'Done',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              feature["title"] ?? "No Title",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Color(0xFF1A1A1A),
                                                height: 1.3,
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              feature["description"] ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF6B7280),
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6366F1), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}
