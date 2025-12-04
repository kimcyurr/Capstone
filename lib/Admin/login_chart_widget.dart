import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoginChartWidget extends StatelessWidget {
  const LoginChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Login Activity (Last 7 Days)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // STREAMBUILDER
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("login_history")
                .orderBy("createdAt", descending: true)
                .limit(200)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final docs = snapshot.data!.docs;

              /// Count logins per day
              final Map<String, int> counts = {};

              for (var doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final ts = data["createdAt"];

                DateTime date;

                if (ts is Timestamp) {
                  date = ts.toDate();
                } else if (ts is String) {
                  date = DateTime.tryParse(ts) ?? DateTime.now();
                } else if (ts is int) {
                  date = DateTime.fromMillisecondsSinceEpoch(ts);
                } else {
                  continue;
                }

                final day = DateFormat('yyyy-MM-dd').format(date);

                counts[day] = (counts[day] ?? 0) + 1;
              }

              final sortedKeys = counts.keys.toList()
                ..sort((a, b) => a.compareTo(b));

              final last7 = sortedKeys.takeLast(7);

              if (last7.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("No login activity recently."),
                );
              }

              return SizedBox(
                height: 220,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value < 0 || value >= last7.length) {
                              return const SizedBox();
                            }

                            final date = DateTime.parse(last7[value.toInt()]);
                            final label = DateFormat("E").format(date);
                            return Text(
                              label,
                              style: const TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(
                      last7.length,
                      (i) => BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: counts[last7[i]]!.toDouble(),
                            width: 18,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// FIXED EXTENSION
extension TakeLastExtension<T> on List<T> {
  List<T> takeLast(int count) {
    if (length <= count) return List<T>.from(this);
    return sublist(length - count);
  }
}
