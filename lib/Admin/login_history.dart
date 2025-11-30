import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LoginHistoryWidget extends StatelessWidget {
  const LoginHistoryWidget({super.key, required int limit});

  DateTime parseLoginTime(dynamic loginTime) {
    if (loginTime == null) return DateTime.now();
    if (loginTime is Timestamp) return loginTime.toDate();
    if (loginTime is String) return DateTime.parse(loginTime);
    return DateTime.now();
  }

  // Fetch fullName from "users" collection using the email
  Future<String> fetchFullName(String email) async {
    final query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      return data['fullName'] ?? 'No Name';
    }
    return 'No Name';
  }

  @override
  Widget build(BuildContext context) {
    final loginHistoryCollection = FirebaseFirestore.instance.collection(
      'login_history',
    );

    return StreamBuilder<QuerySnapshot>(
      stream: loginHistoryCollection
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No login records found.'));
        }

        final loginDocs = snapshot.data!.docs;
        final totalLogins = loginDocs.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Total logins: $totalLogins',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Full Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Time')),
                ],
                rows: loginDocs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final email = data['email'] ?? 'Unknown';
                  final loginTime = parseLoginTime(data['createdAt']);

                  final formattedDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(loginTime);
                  final formattedTime = DateFormat(
                    'HH:mm:ss',
                  ).format(loginTime);

                  return DataRow(
                    cells: [
                      // Full Name cell using FutureBuilder
                      DataCell(
                        FutureBuilder<String>(
                          future: fetchFullName(email),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return const Text("Loading...");
                            }
                            return Text(snap.data!);
                          },
                        ),
                      ),

                      DataCell(Text(email)),
                      DataCell(Text(formattedDate)),
                      DataCell(Text(formattedTime)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class LoginHistoryWidget extends StatefulWidget {
//   const LoginHistoryWidget({super.key});

//   @override
//   State<LoginHistoryWidget> createState() => _LoginHistoryWidgetState();
// }

// class _LoginHistoryWidgetState extends State<LoginHistoryWidget> {
//   DateTime? startDate;
//   DateTime? endDate;

//   DateTime parseLoginTime(dynamic loginTime) {
//     if (loginTime == null) return DateTime.now();
//     if (loginTime is Timestamp) return loginTime.toDate();
//     if (loginTime is String) return DateTime.parse(loginTime);
//     return DateTime.now();
//   }

//   Query buildQuery() {
//     final collection = FirebaseFirestore.instance
//         .collection('login_history')
//         .orderBy('createdAt', descending: true);

//     if (startDate != null && endDate != null) {
//       return collection
//           .where(
//             'createdAt',
//             isGreaterThanOrEqualTo: Timestamp.fromDate(startDate!),
//           )
//           .where(
//             'createdAt',
//             isLessThanOrEqualTo: Timestamp.fromDate(endDate!),
//           );
//     }

//     return collection;
//   }

//   Future<void> pickDateRange() async {
//     final now = DateTime.now();
//     final initialStart = startDate ?? now;
//     final initialEnd = endDate ?? now;

//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//       initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
//     );

//     if (picked != null) {
//       setState(() {
//         startDate = DateTime(
//           picked.start.year,
//           picked.start.month,
//           picked.start.day,
//           0,
//           0,
//           0,
//         );
//         endDate = DateTime(
//           picked.end.year,
//           picked.end.month,
//           picked.end.day,
//           23,
//           59,
//           59,
//         );
//       });
//     }
//   }

//   void selectToday() {
//     final now = DateTime.now();
//     setState(() {
//       startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);
//       endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     });
//   }

//   void selectYesterday() {
//     final yesterday = DateTime.now().subtract(const Duration(days: 1));
//     setState(() {
//       startDate = DateTime(
//         yesterday.year,
//         yesterday.month,
//         yesterday.day,
//         0,
//         0,
//         0,
//       );
//       endDate = DateTime(
//         yesterday.year,
//         yesterday.month,
//         yesterday.day,
//         23,
//         59,
//         59,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final query = buildQuery();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Date filter buttons
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 ElevatedButton(
//                   onPressed: selectToday,
//                   child: const Text("Today"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: selectYesterday,
//                   child: const Text("Yesterday"),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: pickDateRange,
//                   child: const Text("Custom Range"),
//                 ),
//                 const SizedBox(width: 16),
//                 if (startDate != null && endDate != null)
//                   Text(
//                     "Showing: ${DateFormat('yyyy-MM-dd').format(startDate!)} - ${DateFormat('yyyy-MM-dd').format(endDate!)}",
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//               ],
//             ),
//           ),
//         ),

//         // Table container
//         Expanded(
//           child: StreamBuilder<QuerySnapshot>(
//             stream: query.snapshots(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                 return const Center(child: Text('No login records found.'));
//               }

//               final loginDocs = snapshot.data!.docs;
//               final totalLogins = loginDocs.length;

//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Total logins: $totalLogins',
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),

//                   // Scrollable table
//                   Expanded(
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: DataTable(
//                           columns: const [
//                             DataColumn(label: Text('Email')),
//                             DataColumn(label: Text('Date')),
//                             DataColumn(label: Text('Time')),
//                           ],
//                           rows: loginDocs.map((doc) {
//                             final data = doc.data() as Map<String, dynamic>;
//                             final loginTime = parseLoginTime(data['createdAt']);
//                             final formattedDate = DateFormat(
//                               'yyyy-MM-dd',
//                             ).format(loginTime);
//                             final formattedTime = DateFormat(
//                               'HH:mm:ss',
//                             ).format(loginTime);

//                             return DataRow(
//                               cells: [
//                                 DataCell(Text(data['email'] ?? 'Unknown')),
//                                 DataCell(Text(formattedDate)),
//                                 DataCell(Text(formattedTime)),
//                               ],
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
