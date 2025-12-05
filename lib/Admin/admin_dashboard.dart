// import 'package:agsecure/Admin/login_history.dart';
// import 'package:flutter/material.dart';
// import 'gender_analytics_widget.dart';
// import 'feature_crud_widget.dart';
// import 'feature_service.dart';
// import 'admin_users_widget.dart';

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int selectedIndex = 0;

//   final featureService = FeatureService(
//     backendBase: "https://agsecure-backend.onrender.com",
//   );

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pages = [
//       const Center(
//         child: Text("Dashboard Home", style: TextStyle(fontSize: 22)),
//       ),

//       // Gender Analytics
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: GenderAnalyticsWidget(),
//       ),

//       // Feature CRUD
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: FeatureCrudWidget(featureService: featureService),
//       ),

//       // Users Page
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: const AdminUsersWidget(),
//       ),
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: const LoginHistoryWidget(limit: 20),
//       ),
//     ];

//     return Scaffold(
//       body: Row(
//         children: [
//           // LEFT MENU (PERMANENT)
//           Container(
//             width: 250,
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DrawerHeader(
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 45,
//                         height: 45,
//                         child: Image.asset(
//                           "assets/logo.png", // <-- put your image file here
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         "AgSecure",
//                         style: TextStyle(
//                           color: Colors.black, // <-- Header text black
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 menuItem(index: 0, icon: Icons.dashboard, title: "Dashboard"),
//                 menuItem(
//                   index: 1,
//                   icon: Icons.bar_chart,
//                   title: "Gender Analytics",
//                 ),
//                 menuItem(index: 2, icon: Icons.add_box, title: "Add Module"),
//                 menuItem(
//                   index: 3,
//                   icon: Icons.people,
//                   title: "Registered Users",
//                 ),
//                 menuItem(
//                   index: 4,
//                   icon: Icons.login,
//                   title: "Login Monitoring",
//                 ),
//               ],
//             ),
//           ),

//           // MAIN CONTENT SECTION
//           Expanded(child: pages[selectedIndex]),
//         ],
//       ),
//     );
//   }

//   // SIDE MENU ITEM BUILDER
//   Widget menuItem({
//     required int index,
//     required IconData icon,
//     required String title,
//   }) {
//     bool active = selectedIndex == index;

//     Color activeColor = Colors.green; // <-- Color when selected
//     Color defaultColor = Colors.black; // <-- Color when not selected

//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: active ? activeColor : defaultColor, // Icon color changes
//             ),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: TextStyle(
//                 color: active
//                     ? activeColor
//                     : defaultColor, // Text color changes
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:agsecure/Admin/login_history.dart';
// import 'package:flutter/material.dart';
// import 'gender_analytics_widget.dart';
// import 'feature_crud_widget.dart';
// import 'feature_service.dart';
// import 'admin_users_widget.dart';
// import 'login_chart_widget.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // For module read count

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   int selectedIndex = 0;

//   final featureService = FeatureService(
//     backendBase: "https://agsecure-backend.onrender.com",
//   );

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> pages = [
//       // ==========================================================
//       // DASHBOARD HOME PAGE (Login Chart + Gender Analytics + Top Module)
//       // ==========================================================
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Overview",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),

//             // LOGIN BAR GRAPH
//             LoginChartWidget(),

//             SizedBox(height: 20),

//             // GENDER ANALYTICS PIE CHART (Compact version)
//             GenderAnalyticsWidget(),

//             SizedBox(height: 20),

//             // TOP MODULE / MOST READ
//             // TopModulesWidget(),
//           ],
//         ),
//       ),

//       // Feature CRUD
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: FeatureCrudWidget(featureService: featureService),
//       ),

//       // Users Page
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: AdminUsersWidget(),
//       ),

//       // Login History Page
//       SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: LoginHistoryWidget(limit: 20),
//       ),
//     ];

//     return Scaffold(
//       body: Row(
//         children: [
//           // LEFT MENU (PERMANENT)
//           Container(
//             width: 250,
//             color: Colors.white,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DrawerHeader(
//                   child: Row(
//                     children: [
//                       SizedBox(
//                         width: 45,
//                         height: 45,
//                         child: Image.asset(
//                           "assets/logo.png",
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       const Text(
//                         "AgSecure",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // MENU ITEMS
//                 menuItem(index: 0, icon: Icons.dashboard, title: "Dashboard"),
//                 menuItem(index: 1, icon: Icons.add_box, title: "Add Module"),
//                 menuItem(
//                   index: 2,
//                   icon: Icons.people,
//                   title: "Registered Users",
//                 ),
//                 menuItem(
//                   index: 3,
//                   icon: Icons.login,
//                   title: "Login Monitoring",
//                 ),
//               ],
//             ),
//           ),

//           // MAIN CONTENT SECTION
//           Expanded(child: pages[selectedIndex]),
//         ],
//       ),
//     );
//   }

//   // SIDE MENU ITEM BUILDER
//   Widget menuItem({
//     required int index,
//     required IconData icon,
//     required String title,
//   }) {
//     bool active = selectedIndex == index;

//     Color activeColor = Colors.green;
//     Color defaultColor = Colors.black;

//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Icon(icon, color: active ? activeColor : defaultColor),
//             const SizedBox(width: 15),
//             Text(
//               title,
//               style: TextStyle(
//                 color: active ? activeColor : defaultColor,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:agsecure/Admin/login_history.dart';
import 'package:flutter/material.dart';
import 'feature_crud_widget.dart';
import 'gender_analytics_widget.dart';
import 'feature_service.dart';
import 'admin_users_widget.dart';
import 'login_chart_widget.dart';

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
      // MAIN DASHBOARD PAGE
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dashboard",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // TOP ROW: LOGIN CHART + GENDER ANALYTICS
            LayoutBuilder(
              builder: (context, constraints) {
                bool isWide = constraints.maxWidth > 800;

                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 🔹 LOGIN ANALYTICS CARD
                    Flexible(
                      fit: FlexFit.loose,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: const [
                              Text(
                                "Login Analytics",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              LoginChartWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),

                    // 🔹 GENDER ANALYTICS CARD
                    Flexible(
                      fit: FlexFit.loose,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: const [
                              Text(
                                "Gender Analytics",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              GenderAnalyticsWidget(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      // ADD MODULE PAGE
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FeatureCrudWidget(featureService: featureService),
      ),

      // REGISTERED USERS PAGE
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: const AdminUsersWidget(),
      ),

      // LOGIN MONITORING PAGE
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LoginHistoryWidget(limit: 20),
      ),
    ];

    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DrawerHeader(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 45,
                        height: 45,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "AgSecure",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                menuItem(index: 0, icon: Icons.dashboard, title: "Dashboard"),
                menuItem(index: 1, icon: Icons.add_box, title: "Add Module"),
                menuItem(
                  index: 2,
                  icon: Icons.people,
                  title: "Registered Users",
                ),
                menuItem(
                  index: 3,
                  icon: Icons.login,
                  title: "Login Monitoring",
                ),
              ],
            ),
          ),

          // MAIN CONTENT AREA
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }

  Widget menuItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    bool active = selectedIndex == index;
    Color activeColor = Colors.green;
    Color defaultColor = Colors.black;

    return InkWell(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: active ? activeColor : defaultColor),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                color: active ? activeColor : defaultColor,
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
