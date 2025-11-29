// import 'package:flutter/material.dart';
// import 'gender_analytics_widget.dart';
// import 'feature_crud_widget.dart';

// class AdminScaffold extends StatelessWidget {
//   final String title;
//   final Widget body;

//   const AdminScaffold({super.key, required this.title, required this.body});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//         leading: Builder(
//           builder: (context) => IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () => Scaffold.of(context).openDrawer(),
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.green),
//               child: Text(
//                 "Admin Menu",
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.analytics),
//               title: const Text("Gender Analytics"),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => GenderAnalyticsWidget()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.list),
//               title: const Text("Feature CRUD"),
//               onTap: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (_) => FeatureCrudWidget(featureService: null,)),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       body: body,
//     );
//   }
// }
