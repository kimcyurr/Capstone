import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersWidget extends StatefulWidget {
  const AdminUsersWidget({super.key});

  @override
  State<AdminUsersWidget> createState() => _AdminUsersWidgetState();
}

class _AdminUsersWidgetState extends State<AdminUsersWidget> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Users",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER (User count)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  final count = snapshot.hasData
                      ? snapshot.data!.docs.length
                      : 0;

                  return Text(
                    "All Users ($count)",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // SEARCH BAR
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by name or email...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // TABLE HEADER
              Row(
                children: const [
                  Expanded(
                    child: Text(
                      "USER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "CONTACT",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "GENDER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // USERS LIST
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Text("No users found.");
                  }

                  final users = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['fullName']?.toLowerCase() ?? "";
                    final email = data['email']?.toLowerCase() ?? "";
                    return name.contains(searchQuery) ||
                        email.contains(searchQuery);
                  }).toList();

                  return Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final data =
                              users[index].data() as Map<String, dynamic>;

                          final initials =
                              (data['fullName'] != null &&
                                  data['fullName'] != "")
                              ? data['fullName'][0].toUpperCase()
                              : "?";

                          final gender = data['gender'] ?? "Not set";

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 8,
                            ),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Row(
                              children: [
                                // USER COLUMN
                                Expanded(
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.green.shade300,
                                        child: Text(
                                          initials,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['fullName'] ?? "No Name",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            "ID: ${users[index].id.substring(0, 6)}...",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // CONTACT COLUMN (Email)
                                Expanded(
                                  child: Text(
                                    data['email'] ?? "No Email",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),

                                // GENDER COLUMN
                                Expanded(
                                  child: Text(
                                    gender,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // COUNT FOOTER
                      Text(
                        "Showing ${users.length} users",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class AdminUsersWidget extends StatefulWidget {
//   const AdminUsersWidget({super.key});

//   @override
//   State<AdminUsersWidget> createState() => _AdminUsersWidgetState();
// }

// class _AdminUsersWidgetState extends State<AdminUsersWidget> {
//   String searchQuery = "";
//   List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUsers();
//   }

//   Future<void> _loadUsers() async {
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .orderBy('createdAt', descending: true)
//           .get();

//       setState(() {
//         users = snapshot.docs;
//       });
//     } catch (e) {
//       debugPrint("Error loading users: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Filter users based on search query
//     final filteredUsers = users.where((user) {
//       final data = user.data();
//       final name = data['fullName'] ?? '';
//       final email = data['email'] ?? '';
//       return name.toLowerCase().contains(searchQuery.toLowerCase()) ||
//           email.toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();

//     return Column(
//       children: [
//         // Search Field
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             decoration: const InputDecoration(
//               labelText: "Search Users",
//               prefixIcon: Icon(Icons.search),
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 searchQuery = value;
//               });
//             },
//           ),
//         ),

//         // Table Header
//         Container(
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//           decoration: BoxDecoration(
//             border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
//           ),
//           child: Row(
//             children: const [
//               Expanded(
//                 child: Text(
//                   "USER",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   "CONTACT",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   "GENDER",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   "CREATED",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 4),

//         // User List
//         Expanded(
//           child: ListView.builder(
//             itemCount: filteredUsers.length,
//             itemBuilder: (context, index) {
//               final userDoc = filteredUsers[index];
//               final data = userDoc.data();

//               final fullName = data['fullName'] ?? "No Name";
//               final email = data['email'] ?? "No Email";
//               final gender = data['gender'] ?? "N/A";

//               // Initials for avatar
//               final initials = fullName.isNotEmpty
//                   ? fullName
//                         .trim()
//                         .split(" ")
//                         .map((e) => e[0])
//                         .take(2)
//                         .join()
//                         .toUpperCase()
//                   : "?";

//               // CreatedAt
//               final createdAt = data['createdAt'];
//               String createdText = "Unknown";

//               if (createdAt != null) {
//                 try {
//                   DateTime date = createdAt is Timestamp
//                       ? createdAt.toDate()
//                       : DateTime.tryParse(createdAt.toString()) ??
//                             DateTime.now();

//                   createdText = DateFormat('MMM dd, yyyy').format(date);
//                 } catch (e) {
//                   createdText = "Invalid";
//                 }
//               }

//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 8,
//                 ),
//                 margin: const EdgeInsets.only(bottom: 8),
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(color: Colors.grey.shade300),
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     // USER
//                     Expanded(
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             radius: 20,
//                             backgroundColor: Colors.green.shade300,
//                             child: Text(
//                               initials,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 fullName,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Text(
//                                 "ID: ${userDoc.id.substring(0, 6)}...",
//                                 style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey.shade600,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                     // EMAIL
//                     Expanded(
//                       child: Text(
//                         email,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                     ),

//                     // GENDER
//                     Expanded(
//                       child: Text(
//                         gender,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                     ),

//                     // CREATED AT
//                     Expanded(
//                       child: Text(
//                         createdText,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade800,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
