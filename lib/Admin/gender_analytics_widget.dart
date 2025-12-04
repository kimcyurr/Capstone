// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class GenderAnalyticsWidget extends StatelessWidget {
//   GenderAnalyticsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Gender Analytics",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance.collection('users').snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//               return const Text("No users found");
//             }

//             int male = 0, female = 0, other = 0;
//             for (var doc in snapshot.data!.docs) {
//               final data = doc.data() as Map<String, dynamic>;
//               final gender = (data['gender'] ?? 'other')
//                   .toString()
//                   .toLowerCase();
//               if (gender == 'male')
//                 male++;
//               else if (gender == 'female')
//                 female++;
//               else
//                 other++;
//             }

//             int total = male + female + other;
//             double malePercent = total == 0 ? 0 : male / total;
//             double femalePercent = total == 0 ? 0 : female / total;
//             double otherPercent = total == 0 ? 0 : other / total;

//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _analyticsCard(
//                   "Male",
//                   male,
//                   malePercent,
//                   Colors.blue,
//                   Icons.male,
//                 ),
//                 _analyticsCard(
//                   "Female",
//                   female,
//                   femalePercent,
//                   Colors.pink,
//                   Icons.female,
//                 ),
//                 _analyticsCard(
//                   "Other",
//                   other,
//                   otherPercent,
//                   Colors.green,
//                   Icons.transgender,
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }

//   Widget _analyticsCard(
//     String label,
//     int count,
//     double percent,
//     Color color,
//     IconData icon,
//   ) {
//     return Expanded(
//       child: Card(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 3,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             children: [
//               Icon(icon, size: 36, color: color),
//               const SizedBox(height: 8),
//               Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 count.toString(),
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               LinearProgressIndicator(
//                 value: percent,
//                 backgroundColor: Colors.grey[300],
//                 color: color,
//                 minHeight: 6,
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "${(percent * 100).toStringAsFixed(1)}%",
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class GenderAnalyticsWidget extends StatelessWidget {
  const GenderAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender Analytics",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text("No users found");
            }

            int male = 0, female = 0, other = 0;

            for (var doc in snapshot.data!.docs) {
              final data = doc.data() as Map<String, dynamic>;
              final gender = (data['gender'] ?? 'other')
                  .toString()
                  .toLowerCase();

              if (gender == 'male')
                male++;
              else if (gender == 'female')
                female++;
              else
                other++;
            }

            int total = male + female + other;

            return Column(
              children: [
                // Total Users (Smaller)
                Text(
                  "Total Users: $total",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // ======================
                // 📌 SMALL PIE CHART
                // ======================
                SizedBox(
                  height: 170,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 25,
                      sections: [
                        PieChartSectionData(
                          value: male.toDouble(),
                          color: Colors.blue,
                          title: male == 0 ? "" : "$male",
                          radius: 55, // smaller
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: female.toDouble(),
                          color: Colors.pink,
                          title: female == 0 ? "" : "$female",
                          radius: 55,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: other.toDouble(),
                          color: Colors.green,
                          title: other == 0 ? "" : "$other",
                          radius: 55,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Compact Legend
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  children: [
                    _legendItem(Colors.blue, "Male ($male)"),
                    _legendItem(Colors.pink, "Female ($female)"),
                    _legendItem(Colors.green, "Other ($other)"),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
