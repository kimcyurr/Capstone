// import 'package:flutter/material.dart';
// import 'gender_analytics_widget.dart';
// import 'feature_crud_widget.dart';
// import 'feature_service.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final featureService = FeatureService(
//       backendBase: "https://agsecure-backend.onrender.com",
//     );

//     return Scaffold(
//       appBar: AppBar(title: const Text("Admin Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             GenderAnalyticsWidget(),
//             const SizedBox(height: 25),
//             FeatureCrudWidget(featureService: featureService),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:agsecure/Admin/login_history.dart';
import 'package:flutter/material.dart';
import 'gender_analytics_widget.dart';
import 'feature_crud_widget.dart';
import 'feature_service.dart';
import 'admin_users_widget.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  final featureService = FeatureService(
    backendBase: "https://agsecure-backend.onrender.com",
  );

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Center(
        child: Text("Dashboard Home", style: TextStyle(fontSize: 22)),
      ),

      // Gender Analytics
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: GenderAnalyticsWidget(),
      ),

      // Feature CRUD
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FeatureCrudWidget(featureService: featureService),
      ),

      // Users Page
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const AdminUsersWidget(),
      ),
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const LoginHistoryWidget(limit: 20),
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          // LEFT MENU (PERMANENT)
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          "assets/logo.png", // <-- put your image file here
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "AgSecure",
                        style: TextStyle(
                          color: Colors.black, // <-- Header text black
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                menuItem(index: 0, icon: Icons.dashboard, title: "Dashboard"),
                menuItem(
                  index: 1,
                  icon: Icons.bar_chart,
                  title: "Gender Analytics",
                ),
                menuItem(index: 2, icon: Icons.add_box, title: "Add Module"),
                menuItem(
                  index: 3,
                  icon: Icons.people,
                  title: "Registered Users",
                ),
                menuItem(
                  index: 4,
                  icon: Icons.login,
                  title: "Login Monitoring",
                ),
              ],
            ),
          ),

          // MAIN CONTENT SECTION
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }

  // SIDE MENU ITEM BUILDER
  Widget menuItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    bool active = selectedIndex == index;

    Color activeColor = Colors.green; // <-- Color when selected
    Color defaultColor = Colors.black; // <-- Color when not selected

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: active ? activeColor : defaultColor, // Icon color changes
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: active
                    ? activeColor
                    : defaultColor, // Text color changes
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
