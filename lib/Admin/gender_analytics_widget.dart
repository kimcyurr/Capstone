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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

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
                // =====================
                // 🔵 OVERALL TOTAL USERS
                // =====================
                Text(
                  "Total Users: $total",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ================
                // 🥧 PIE CHART
                // ================
                SizedBox(
                  height: 260,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: male.toDouble(),
                          color: Colors.blue,
                          title: male == 0 ? "" : "$male",
                          radius: 90,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: female.toDouble(),
                          color: Colors.pink,
                          title: female == 0 ? "" : "$female",
                          radius: 90,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: other.toDouble(),
                          color: Colors.green,
                          title: other == 0 ? "" : "$other",
                          radius: 90,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // =====================
                // 🔹 LEGEND
                // =====================
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  children: [
                    _legendItem(Colors.blue, "Male ($male)"),
                    _legendItem(Colors.pink, "Female ($female)"),
                    _legendItem(Colors.green, "Other ($other)"),
                  ],
                ),

                const SizedBox(height: 30),

                // =====================
                // 📊 BAR CHART
                // =====================
                SizedBox(
                  height: 260,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY:
                          ([
                            male.toDouble(),
                            female.toDouble(),
                            other.toDouble(),
                          ].reduce((a, b) => a > b ? a : b)) +
                          2,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 0:
                                  return const Text("Male");
                                case 1:
                                  return const Text("Female");
                                case 2:
                                  return const Text("Other");
                              }
                              return const Text("");
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: male.toDouble(),
                              color: Colors.blue,
                              width: 30,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: female.toDouble(),
                              color: Colors.pink,
                              width: 30,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: other.toDouble(),
                              color: Colors.green,
                              width: 30,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
          width: 14,
          height: 14,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
