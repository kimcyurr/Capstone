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
//       appBar: AppBar(title: const Text('Profile')),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: getUserData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return const Center(child: Text('No profile data found'));
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Full Name: ${data['fullName'] ?? 'N/A'}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Username: ${data['userName'] ?? 'N/A'}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Email: ${data['email'] ?? 'N/A'}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Gender: ${data['gender'] ?? 'N/A'}',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//           );
//         },
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
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
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

          // Use Firebase Auth email if Firestore data is missing
          final fullName = data?['fullName'] ?? 'Unknown';
          final userName = data?['userName'] ?? 'Unknown';
          final gender = data?['gender'] ?? 'Unknown';
          final email = user?.email ?? 'Unknown';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green[200],
                  child: Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Card
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildProfileRow('Full Name', fullName),
                        const Divider(),
                        buildProfileRow('Username', userName),
                        const Divider(),
                        buildProfileRow('Email', email),
                        const Divider(),
                        buildProfileRow('Gender', gender),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Logout Button
                ElevatedButton.icon(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper widget for a single row
  Widget buildProfileRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
