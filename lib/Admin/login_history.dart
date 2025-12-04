// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class LoginHistoryWidget extends StatelessWidget {
//   const LoginHistoryWidget({super.key, required int limit});

//   DateTime parseLoginTime(dynamic loginTime) {
//     if (loginTime == null) return DateTime.now();
//     if (loginTime is Timestamp) return loginTime.toDate();
//     if (loginTime is String) return DateTime.parse(loginTime);
//     return DateTime.now();
//   }

//   // Fetch fullName from "users" collection using the email
//   Future<String> fetchFullName(String email) async {
//     final query = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .limit(1)
//         .get();

//     if (query.docs.isNotEmpty) {
//       final data = query.docs.first.data();
//       return data['fullName'] ?? 'No Name';
//     }
//     return 'No Name';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginHistoryCollection = FirebaseFirestore.instance.collection(
//       'login_history',
//     );

//     return StreamBuilder<QuerySnapshot>(
//       stream: loginHistoryCollection
//           .orderBy('createdAt', descending: true)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No login records found.'));
//         }

//         final loginDocs = snapshot.data!.docs;
//         final totalLogins = loginDocs.length;

//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Total logins: $totalLogins',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),

//             // Table
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: const [
//                   DataColumn(label: Text('Full Name')),
//                   DataColumn(label: Text('Email')),
//                   DataColumn(label: Text('Date')),
//                   DataColumn(label: Text('Time')),
//                 ],
//                 rows: loginDocs.map((doc) {
//                   final data = doc.data() as Map<String, dynamic>;
//                   final email = data['email'] ?? 'Unknown';
//                   final loginTime = parseLoginTime(data['createdAt']);

//                   final formattedDate = DateFormat(
//                     'yyyy-MM-dd',
//                   ).format(loginTime);
//                   final formattedTime = DateFormat(
//                     'HH:mm:ss',
//                   ).format(loginTime);

//                   return DataRow(
//                     cells: [
//                       // Full Name cell using FutureBuilder
//                       DataCell(
//                         FutureBuilder<String>(
//                           future: fetchFullName(email),
//                           builder: (context, snap) {
//                             if (!snap.hasData) {
//                               return const Text("Loading...");
//                             }
//                             return Text(snap.data!);
//                           },
//                         ),
//                       ),

//                       DataCell(Text(email)),
//                       DataCell(Text(formattedDate)),
//                       DataCell(Text(formattedTime)),
//                     ],
//                   );
//                 }).toList(),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class LoginHistoryWidget extends StatelessWidget {
//   const LoginHistoryWidget({
//     super.key,
//     this.limit = 0, // 0 means fetch all
//   });

//   final int limit;

//   DateTime parseLoginTime(dynamic loginTime) {
//     if (loginTime == null) return DateTime.now();
//     if (loginTime is Timestamp) return loginTime.toDate();
//     if (loginTime is String) return DateTime.parse(loginTime);
//     return DateTime.now();
//   }

//   // Fetch fullName from "users" collection using the email
//   Future<String> fetchFullName(String email) async {
//     final query = await FirebaseFirestore.instance
//         .collection('users')
//         .where('email', isEqualTo: email)
//         .limit(1)
//         .get();

//     if (query.docs.isNotEmpty) {
//       final data = query.docs.first.data();
//       return data['fullName'] ?? 'No Name';
//     }
//     return 'No Name';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loginHistoryCollection = FirebaseFirestore.instance.collection(
//       'login_history',
//     );

//     // Choose stream based on limit
//     final stream = (limit > 0)
//         ? loginHistoryCollection
//               .orderBy('createdAt', descending: true)
//               .limit(limit)
//               .snapshots()
//         : loginHistoryCollection
//               .orderBy('createdAt', descending: true)
//               .snapshots();

//     return StreamBuilder<QuerySnapshot>(
//       stream: stream,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(child: Text('No login records found.'));
//         }

//         final loginDocs = snapshot.data!.docs;
//         final totalLogins = loginDocs.length;

//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             color: Colors.white,
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Total logins
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16.0),
//                     child: Text(
//                       'Total logins: $totalLogins',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   // Responsive Table
//                   LayoutBuilder(
//                     builder: (context, constraints) {
//                       return SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: ConstrainedBox(
//                           constraints: BoxConstraints(
//                             minWidth: constraints.maxWidth,
//                           ),
//                           child: DataTable(
//                             columnSpacing: 20,
//                             headingRowHeight: 40,
//                             dataRowHeight: 40,
//                             columns: const [
//                               DataColumn(label: Text('Full Name')),
//                               DataColumn(label: Text('Email')),
//                               DataColumn(label: Text('Date')),
//                               DataColumn(label: Text('Time')),
//                             ],
//                             rows: loginDocs.map((doc) {
//                               final data = doc.data() as Map<String, dynamic>;
//                               final email = data['email'] ?? 'Unknown';
//                               final loginTime = parseLoginTime(
//                                 data['createdAt'],
//                               );

//                               final formattedDate = DateFormat(
//                                 'yyyy-MM-dd',
//                               ).format(loginTime);
//                               final formattedTime = DateFormat(
//                                 'HH:mm:ss',
//                               ).format(loginTime);

//                               return DataRow(
//                                 cells: [
//                                   DataCell(
//                                     FutureBuilder<String>(
//                                       future: fetchFullName(email),
//                                       builder: (context, snap) {
//                                         if (!snap.hasData) {
//                                           return const Text("Loading...");
//                                         }
//                                         return Text(
//                                           snap.data!,
//                                           overflow: TextOverflow.ellipsis,
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                   DataCell(
//                                     Text(
//                                       email,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   DataCell(Text(formattedDate)),
//                                   DataCell(Text(formattedTime)),
//                                 ],
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LoginHistoryWidget extends StatefulWidget {
  final int limit;
  const LoginHistoryWidget({super.key, required this.limit});

  @override
  State<LoginHistoryWidget> createState() => _LoginHistoryWidgetState();
}

class _LoginHistoryWidgetState extends State<LoginHistoryWidget> {
  DateTime? selectedDate;
  bool filterToday = false;
  String searchEmail = '';

  // Cache to avoid fetching fullName repeatedly
  final Map<String, String> fullNameCache = {};

  DateTime parseLoginTime(dynamic loginTime) {
    if (loginTime == null) return DateTime.now();
    if (loginTime is Timestamp) return loginTime.toDate();
    if (loginTime is String)
      return DateTime.tryParse(loginTime) ?? DateTime.now();
    if (loginTime is int) return DateTime.fromMillisecondsSinceEpoch(loginTime);
    return DateTime.now();
  }

  Future<String> getFullName(String email) async {
    if (fullNameCache.containsKey(email)) {
      return fullNameCache[email]!;
    }

    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      fullNameCache[email] = "No Name";
      return "No Name";
    }

    final fullName = query.docs.first['fullName'] ?? "No Name";
    fullNameCache[email] = fullName;
    return fullName;
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        filterToday = false;
      });
    }
  }

  void clearFilters() {
    setState(() {
      selectedDate = null;
      filterToday = false;
      searchEmail = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: 220,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search by email',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) => setState(() {
                    searchEmail = value.toLowerCase();
                  }),
                ),
              ),
              OutlinedButton.icon(
                onPressed: pickDate,
                icon: const Icon(Icons.date_range),
                label: const Text('Pick Date'),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Today Only"),
                  Switch(
                    value: filterToday,
                    onChanged: (value) => setState(() {
                      filterToday = value;
                      if (value) selectedDate = null;
                    }),
                  ),
                ],
              ),
              OutlinedButton.icon(
                onPressed: clearFilters,
                icon: const Icon(Icons.clear),
                label: const Text("Clear"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('login_history')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data?.docs ?? [];

              final filteredDocs = docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final loginTime = parseLoginTime(data['createdAt']);
                final email = (data['email'] ?? '').toString().toLowerCase();

                if (searchEmail.isNotEmpty && !email.contains(searchEmail)) {
                  return false;
                }

                if (filterToday) {
                  final now = DateTime.now();
                  final start = DateTime(now.year, now.month, now.day);
                  final end = start.add(const Duration(days: 1));
                  if (!(loginTime.isAfter(start) && loginTime.isBefore(end))) {
                    return false;
                  }
                }

                if (selectedDate != null) {
                  final start = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                  );
                  final end = start.add(const Duration(days: 1));
                  if (!(loginTime.isAfter(start) && loginTime.isBefore(end))) {
                    return false;
                  }
                }

                return true;
              }).toList();

              if (filteredDocs.isEmpty) {
                return const Center(child: Text("No login records found."));
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total logins: ${filteredDocs.length}",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // HEADER
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey)),
                    ),
                    child: Row(
                      children: const [
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Full Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Time",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 6),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          filteredDocs[index].data() as Map<String, dynamic>;
                      final loginTime = parseLoginTime(data['createdAt']);
                      final email = data['email'] ?? "Unknown";

                      return FutureBuilder<String>(
                        future: getFullName(email),
                        builder: (context, nameSnapshot) {
                          final fullName = nameSnapshot.data ?? "N/A";

                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 3, child: Text(fullName)),
                                Expanded(flex: 3, child: Text(email)),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(loginTime),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    DateFormat('HH:mm:ss').format(loginTime),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
