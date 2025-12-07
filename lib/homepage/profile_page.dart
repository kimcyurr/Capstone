// import 'dart:convert';
// import 'package:agsecure/homepage/EditProfilePage.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;

// import 'ModuleDetailPage.dart';

// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   User? user;
//   late CollectionReference usersRef;

//   List readingHistory = [];
//   bool isLoadingHistory = true;

//   final String backendBase = "https://agsecure-backend.onrender.com";
//   // final String backendBase = "http://192.168.8.125:3000";
//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.currentUser;
//     usersRef = FirebaseFirestore.instance.collection('users');
//     if (user != null) {
//       fetchReadingHistory();
//     }
//   }

//   Future<DocumentSnapshot> getUserData() async {
//     if (user == null) throw Exception('No logged-in user');
//     return usersRef.doc(user!.uid).get();
//   }

//   Future<void> fetchReadingHistory() async {
//     if (user == null) return;

//     try {
//       final uri = Uri.parse(
//         "$backendBase/api/reading-history/user/${user!.uid}",
//       );
//       final response = await http.get(uri);

//       if (response.statusCode == 200) {
//         final List data = json.decode(response.body);

//         final List tempHistory = data
//             .map((item) {
//               final feature = item["featureId"];
//               return feature != null
//                   ? {
//                       "_id": item["_id"],
//                       "title": feature["title"],
//                       "description": feature["description"],
//                       "image": feature["image"],
//                       "steps": feature["steps"],
//                     }
//                   : null;
//             })
//             .where((element) => element != null)
//             .toList();

//         setState(() {
//           readingHistory = tempHistory;
//           isLoadingHistory = false;
//         });
//       } else {
//         setState(() => isLoadingHistory = false);
//       }
//     } catch (e) {
//       setState(() => isLoadingHistory = false);
//       print("Error fetching history: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Scaffold(
//         body: Center(child: Text("No logged-in user found")),
//       );
//     }

//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF2D5F2E),
//         elevation: 0,
//         title: const Text(
//           'Profile',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings_outlined, color: Colors.white),
//             onPressed: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context)=>
//               //   ),
//               // );
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

//           final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
//           final fullName = data['fullName'] ?? 'Unknown';
//           final email = user?.email ?? 'Unknown';

//           return SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Profile Header Card
//                 Container(
//                   margin: const EdgeInsets.all(16),
//                   padding: const EdgeInsets.all(24),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       // Avatar with gradient border
//                       Container(
//                         padding: const EdgeInsets.all(4),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                         child: Container(
//                           padding: const EdgeInsets.all(4),
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             shape: BoxShape.circle,
//                           ),
//                           child: CircleAvatar(
//                             radius: 50,
//                             backgroundColor: const Color(0xFF6366F1),
//                             child: Text(
//                               fullName.isNotEmpty
//                                   ? fullName[0].toUpperCase()
//                                   : '?',
//                               style: const TextStyle(
//                                 fontSize: 36,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         fullName,
//                         style: const TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         email,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF6B7280),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => EditProfilePage(),
//                               ),
//                             );
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
//                       // Stats Row
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       //   children: [
//                       //     _buildStatItem(
//                       //       icon: Icons.auto_stories_outlined,
//                       //       label: 'Modules',
//                       //       value: '${readingHistory.length}',
//                       //     ),
//                       //     Container(
//                       //       height: 40,
//                       //       width: 1,
//                       //       color: Colors.grey[300],
//                       //     ),
//                       //     _buildStatItem(
//                       //       icon: Icons.access_time_outlined,
//                       //       label: 'Hours',
//                       //       value: '${readingHistory.length * 2}',
//                       //     ),
//                       //     Container(
//                       //       height: 40,
//                       //       width: 1,
//                       //       color: Colors.grey[300],
//                       //     ),
//                       //     _buildStatItem(
//                       //       icon: Icons.workspace_premium_outlined,
//                       //       label: 'Streak',
//                       //       value: '7',
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),

//                 // Reading History Section
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         ' History',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1A1A1A),
//                         ),
//                       ),
//                       // if (readingHistory.isNotEmpty)
//                       // TextButton(
//                       //   onPressed: () {
//                       //     // View all
//                       //   },
//                       //   child: const Text(
//                       //     'View All',
//                       //     style: TextStyle(
//                       //       color: Color(0xFF6366F1),
//                       //       fontWeight: FontWeight.w600,
//                       //     ),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 SizedBox(
//                   height: 210,
//                   child: isLoadingHistory
//                       ? ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: 3,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           itemBuilder: (context, index) {
//                             return Container(
//                               width: 180,
//                               margin: const EdgeInsets.only(right: 15),
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                             );
//                           },
//                         )
//                       : readingHistory.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.book_outlined,
//                                 size: 64,
//                                 color: Colors.grey[400],
//                               ),
//                               const SizedBox(height: 12),
//                               const Text(
//                                 "No reading history yet",
//                                 style: TextStyle(
//                                   color: Color(0xFF6B7280),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               const Text(
//                                 "Start exploring modules to see them here",
//                                 style: TextStyle(
//                                   color: Color(0xFF9CA3AF),
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: readingHistory.length,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           itemBuilder: (context, index) {
//                             final feature = readingHistory[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         ModuleDetailPage(feature: feature),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 width: 180,
//                                 margin: EdgeInsets.only(
//                                   right: index == readingHistory.length - 1
//                                       ? 0
//                                       : 15,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(16),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.06),
//                                       blurRadius: 8,
//                                       offset: const Offset(0, 2),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: const BorderRadius.only(
//                                         topLeft: Radius.circular(16),
//                                         topRight: Radius.circular(16),
//                                       ),
//                                       child: Stack(
//                                         children: [
//                                           feature["image"] != null
//                                               ? Image.memory(
//                                                   base64Decode(
//                                                     feature["image"],
//                                                   ),
//                                                   width: double.infinity,
//                                                   height: 130,
//                                                   fit: BoxFit.cover,
//                                                 )
//                                               : Container(
//                                                   width: double.infinity,
//                                                   height: 130,
//                                                   decoration: BoxDecoration(
//                                                     gradient: LinearGradient(
//                                                       colors: [
//                                                         Color(
//                                                           0xFF6366F1,
//                                                         ).withOpacity(0.3),
//                                                         Color(
//                                                           0xFF8B5CF6,
//                                                         ).withOpacity(0.3),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   child: const Icon(
//                                                     Icons.menu_book_rounded,
//                                                     size: 48,
//                                                     color: Color(0xFF6366F1),
//                                                   ),
//                                                 ),
//                                           Positioned(
//                                             top: 8,
//                                             right: 8,
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 8,
//                                                     vertical: 4,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black.withOpacity(
//                                                   0.6,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(8),
//                                               ),
//                                               child: Row(
//                                                 children: [
//                                                   const Icon(
//                                                     Icons.check_circle,
//                                                     size: 14,
//                                                     color: Colors.white,
//                                                   ),
//                                                   const SizedBox(width: 4),
//                                                   Text(
//                                                     'Done',
//                                                     style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 11,
//                                                       fontWeight:
//                                                           FontWeight.w600,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               feature["title"] ?? "No Title",
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 14,
//                                                 color: Color(0xFF1A1A1A),
//                                                 height: 1.3,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 6),
//                                             Text(
//                                               feature["description"] ?? "",
//                                               maxLines: 2,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                 fontSize: 12,
//                                                 color: Color(0xFF6B7280),
//                                                 height: 1.4,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatItem({
//     required IconData icon,
//     required String label,
//     required String value,
//   }) {
//     return Column(
//       children: [
//         Icon(icon, color: const Color(0xFF6366F1), size: 24),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF1A1A1A),
//           ),
//         ),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:agsecure/homepage/DownloadPage.dart';
import 'package:agsecure/homepage/EditProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'ModuleDetailPage.dart';
import 'DownloadPage.dart';

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

  final String backendBase = "https://agsecure-backend.onrender.com";

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
      backgroundColor: Colors.green[50],
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

          return Column(
            children: [
              // ===== DARK HEADER WITH PROFILE =====
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      // App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Text(
                              'Account',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),

                      // Profile Avatar and Info
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color(0xFF2D5F2E),
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
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Color(0xFF1A1A1A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFFAAAAAA),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===== WHITE MENU LIST =====
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        // Menu Container
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildMenuItem(
                                icon: Icons.account_balance_wallet_outlined,
                                title: "Wallet",
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.edit_outlined,
                                title: "Edit Profile",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfilePage(),
                                    ),
                                  );
                                },
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.history,
                                title: "Reading History",
                                onTap: () {
                                  _showReadingHistoryBottomSheet(context);
                                },
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.task_alt_outlined,
                                title: "Task Center",
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.local_activity_outlined,
                                title: "Activities",
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Settings Menu Container
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              _buildMenuItem(
                                icon: Icons.settings_outlined,
                                title: "Settings",
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.military_tech_outlined,
                                title: "Level",
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.favorite_outline,
                                title: "Favorites",
                                onTap: () {},
                              ),
                              _buildDivider(),
                              _buildMenuItem(
                                icon: Icons.download_outlined,
                                title: "Downloads",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DownloadsPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Logout Button
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 20,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.logout,
                                  size: 20,
                                  color: Color(0xFFEF4444),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================================
  // HELPER WIDGETS
  // ===========================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF666666)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1A1A1A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF999999),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      color: const Color(0xFFDDDDDD),
      margin: const EdgeInsets.only(left: 58),
    );
  }

  void _showReadingHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Reading History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // History List
            Expanded(
              child: isLoadingHistory
                  ? const Center(child: CircularProgressIndicator())
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
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: readingHistory.length,
                      itemBuilder: (context, index) {
                        final feature = readingHistory[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ModuleDetailPage(feature: feature),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: feature["image"] != null
                                      ? Image.memory(
                                          base64Decode(feature["image"]),
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 60,
                                          height: 60,
                                          color: const Color(0xFF2D5F2E),
                                          child: const Icon(
                                            Icons.menu_book_rounded,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feature["title"] ?? "No Title",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        feature["description"] ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
