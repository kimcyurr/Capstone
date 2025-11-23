import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GenderAnalyticsWidget extends StatelessWidget {
  GenderAnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender Analytics",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
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
            double malePercent = total == 0 ? 0 : male / total;
            double femalePercent = total == 0 ? 0 : female / total;
            double otherPercent = total == 0 ? 0 : other / total;

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _analyticsCard(
                  "Male",
                  male,
                  malePercent,
                  Colors.blue,
                  Icons.male,
                ),
                _analyticsCard(
                  "Female",
                  female,
                  femalePercent,
                  Colors.pink,
                  Icons.female,
                ),
                _analyticsCard(
                  "Other",
                  other,
                  otherPercent,
                  Colors.green,
                  Icons.transgender,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _analyticsCard(
    String label,
    int count,
    double percent,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, size: 36, color: color),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: percent,
                backgroundColor: Colors.grey[300],
                color: color,
                minHeight: 6,
              ),
              const SizedBox(height: 4),
              Text(
                "${(percent * 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
