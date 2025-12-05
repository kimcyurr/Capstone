import 'dart:convert';
import 'package:agsecure/homepage/EditProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import 'ModuleDetailPage.dart';
import 'Settings.dart';

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
  // final String backendBase = "http://192.168.8.125:3000";
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5F2E),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context)=>
              //   ),
              // );
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(),
                              ),
                            );
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
                  height: 210,
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

// import 'dart:convert';
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
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (user == null) {
//       return const Scaffold(body: Center(child: Text("No user found")));
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: FutureBuilder<DocumentSnapshot>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
//           final fullName = data['fullName'] ?? 'Unknown';
//           final email = user?.email ?? 'Unknown';

//           return Column(
//             children: [
//               // HEADER
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(
//                   top: 50,
//                   left: 16,
//                   right: 16,
//                   bottom: 20,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF2D5F2E),
//                   borderRadius: const BorderRadius.only(
//                     bottomLeft: Radius.circular(40),
//                     bottomRight: Radius.circular(40),
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     // Back button row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () => Navigator.pop(context),
//                           child: const Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 28,
//                           ),
//                         ),
//                         const Spacer(),
//                         const Text(
//                           "Account",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const Spacer(),
//                         const SizedBox(width: 28), // to balance the back icon
//                       ],
//                     ),

//                     const SizedBox(height: 20),

//                     // Circle profile icon
//                     const CircleAvatar(
//                       radius: 45,
//                       backgroundColor: Colors.white,
//                       child: Icon(Icons.person, size: 55, color: Colors.green),
//                     ),

//                     const SizedBox(height: 10),

//                     Text(
//                       fullName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),

//                     Text(
//                       email,
//                       style: const TextStyle(
//                         color: Colors.white70,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // MENU CONTAINER
//               Expanded(
//                 child: Container(
//                   width: double.infinity,
//                   margin: const EdgeInsets.symmetric(horizontal: 20),
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF4F4F4),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     children: [
//                       _menuItem(title: "History", onTap: () {}),
//                       const SizedBox(height: 15),
//                       _menuGroupContainer([
//                         _menuItem(title: "Edit Profile", onTap: () {}),
//                         _menuItem(title: "Settings", onTap: () {}),
//                         _menuItem(title: "FeedBack", onTap: () {}),
//                       ]),
//                       const Spacer(),
//                       _logoutButton(),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // REUSABLE MENU ITEM
//   Widget _menuItem({required String title, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Text(
//               title,
//               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//             ),
//             const Spacer(),
//             const Icon(
//               Icons.arrow_forward_ios_rounded,
//               size: 16,
//               color: Colors.black54,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // GROUP (Edit Profile / Settings / Feedback)
//   Widget _menuGroupContainer(List<Widget> children) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[300],
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Column(children: children),
//     );
//   }

//   // LOGOUT BUTTON
//   Widget _logoutButton() {
//     return GestureDetector(
//       onTap: () async {
//         await FirebaseAuth.instance.signOut();
//         if (mounted) Navigator.pushReplacementNamed(context, '/login');
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.symmetric(vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.red.shade50,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Center(
//           child: Text(
//             "Logout",
//             style: TextStyle(
//               color: Colors.red,
//               fontSize: 15,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
