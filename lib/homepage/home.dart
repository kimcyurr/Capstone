// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'ModuleDetailPage.dart';
// import 'profile_page.dart' hide ModuleDetailPage;
// import 'learn_page.dart';
// import 'scan_page.dart';
// import 'dart:ui';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String userName = "Loading...";
//   String cityName = "Oroquieta City";

//   // Weather
//   String weatherDescription = "";
//   double temperature = 0;
//   int humidity = 0;
//   double windSpeed = 0;
//   double precipitation = 0;
//   bool isLoadingWeather = true;

//   // Backend
//   final String backendBase = "http://localhost:3000";
//   late Future<List<dynamic>> randomFeaturesFuture;

//   int selectedIndex = 0;
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//     loadUserName();
//     randomFeaturesFuture = loadRandomFeatures();
//   }

//   // Fetch username from Firestore
//   Future<void> loadUserName() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DocumentSnapshot doc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .get();
//         if (doc.exists) userName = doc['userName'] ?? "User";
//       } catch (_) {
//         userName = "User";
//       }
//       if (mounted) setState(() {});
//     }
//   }

//   // Load 3 random features from backend
//   Future<List<dynamic>> loadRandomFeatures() async {
//     try {
//       final Uri url = Uri.parse("$backendBase/api/feature/all");
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         List data = json.decode(response.body);
//         data.shuffle(Random());
//         return data.take(3).toList();
//       }
//     } catch (e) {
//       print("Error loading random features: $e");
//     }
//     return [];
//   }

//   // Fetch weather
//   Future<void> fetchWeather() async {
//     const apiKey = "a7bb72460433159aee012cbda57cdfd8";
//     final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
//     );

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         weatherDescription = data['weather'][0]['description'] ?? "";
//         temperature = data['main']['temp']?.toDouble() ?? 0;
//         humidity = data['main']['humidity'] ?? 0;
//         windSpeed = (data['wind']['speed'] ?? 0).toDouble();
//         precipitation = (data['rain']?['1h'] ?? 0).toDouble();
//       }
//     } catch (_) {}
//     if (mounted) setState(() => isLoadingWeather = false);
//   }

//   Widget buildPage() {
//     switch (selectedIndex) {
//       case 0:
//         return buildHomeContent();
//       case 1:
//         return const LearningPage();
//       case 2:
//         return const ScanPage();
//       case 3:
//         return const Center(child: Text("Seeds estimator"));
//       case 4:
//         return const ProfilePage();
//       default:
//         return buildHomeContent();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: SafeArea(child: buildPage()),
//       bottomNavigationBar: buildBottomNavigation(),
//     );
//   }

//   Widget buildBottomNavigation() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavItem(
//             iconPath: "image/image/house-solid-full.png",
//             label: "Home",
//             active: selectedIndex == 0,
//             onTap: () => setState(() => selectedIndex = 0),
//           ),
//           _NavItem(
//             iconPath: "image/image/book-open-solid-full.png",
//             label: "Learn",
//             active: selectedIndex == 1,
//             onTap: () => setState(() => selectedIndex = 1),
//           ),
//           // Bigger Scan Button
//           GestureDetector(
//             onTap: () => setState(() => selectedIndex = 2),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: selectedIndex == 2
//                     ? const Color(0xFF1A6E34)
//                     : Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Image.asset(
//                 "image/image/camera-solid-full.png",
//                 height: 40, // bigger icon
//                 color: selectedIndex == 2 ? Colors.white : Colors.green,
//               ),
//             ),
//           ),
//           _NavItem(
//             iconPath: "image/image/calculator-solid-full.png",
//             label: "Calculate",
//             active: selectedIndex == 3,
//             onTap: () => setState(() => selectedIndex = 3),
//           ),
//           _NavItem(
//             iconPath: "image/image/user-solid-full.png",
//             label: "Profile",
//             active: selectedIndex == 4,
//             onTap: () => setState(() => selectedIndex = 4),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildHomeContent() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // Background image container
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   bottom: 80,
//                 ),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(40),
//                   ),
//                   image: DecorationImage(
//                     image: AssetImage("assets/rice.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         text: "Welcome, ",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: userName,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "Saturday, 22 Nov 2025",
//                       style: TextStyle(fontSize: 14, color: Colors.white70),
//                     ),
//                     const SizedBox(height: 22),

//                     // Glassy / Transparent Search Bar
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.white.withOpacity(0.2),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                           child: TextField(
//                             controller: searchController,
//                             onChanged: (v) => setState(() => searchQuery = v),
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               hintText: "Search here...",
//                               hintStyle: TextStyle(color: Colors.white70),
//                               icon: Icon(Icons.search, color: Colors.white),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Weather Card
//               Positioned(
//                 left: 16,
//                 right: 16,
//                 bottom: -90,
//                 child: _buildWeatherCard(),
//               ),
//             ],
//           ),

//           const SizedBox(height: 120),

//           // RANDOM FEATURE SECTION
//           FutureBuilder<List<dynamic>>(
//             future: randomFeaturesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const SizedBox(
//                   height: 260,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const SizedBox(
//                   height: 260,
//                   child: Center(child: Text("No features found")),
//                 );
//               }

//               final features = snapshot.data!;
//               return buildRandomFeatures(features);
//             },
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget buildRandomFeatures(List features) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 "Get Started",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "View all",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 259,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: features.length,
//             padding: const EdgeInsets.only(left: 20),
//             itemBuilder: (context, index) {
//               final item = features[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ModuleDetailPage(feature: item),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 263,
//                   margin: const EdgeInsets.only(right: 15),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: item["image"] != null
//                             ? Image.memory(
//                                 base64Decode(item["image"]),
//                                 width: 245,
//                                 height: 160,
//                                 fit: BoxFit.cover,
//                               )
//                             : Container(
//                                 width: 245,
//                                 height: 160,
//                                 color: Colors.grey.shade300,
//                                 child: const Icon(Icons.image_not_supported),
//                               ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         item["title"] ?? "",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         item["description"] ?? "",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWeatherCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: isLoadingWeather
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(
//                               Icons.location_on,
//                               color: Colors.red,
//                               size: 18,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               cityName,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 6),
//                         Text(
//                           "${temperature.toStringAsFixed(1)}°C | $weatherDescription",
//                           style: const TextStyle(
//                             fontSize: 15,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Icon(
//                       Icons.cloud_outlined,
//                       size: 48,
//                       color: Colors.blueGrey,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _weatherInfoItem(Icons.opacity, "Humidity", "$humidity%"),
//                     _weatherInfoItem(
//                       Icons.grain,
//                       "Precip",
//                       "$precipitation mm",
//                     ),
//                     _weatherInfoItem(Icons.air, "Wind", "$windSpeed m/s"),
//                   ],
//                 ),
//               ],
//             ),
//     );
//   }

//   Widget _weatherInfoItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: Colors.blueGrey),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
//         ),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 10, color: Colors.black54),
//         ),
//       ],
//     );
//   }
// }

// // Nav item
// class _NavItem extends StatelessWidget {
//   final String iconPath;
//   final String label;
//   final bool active;
//   final VoidCallback? onTap;

//   const _NavItem({
//     required this.iconPath,
//     required this.label,
//     this.active = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             iconPath,
//             height: 26,
//             color: active ? const Color(0xFF1A6E34) : Colors.grey,
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: active ? const Color(0xFF1A6E34) : Colors.grey,
//               fontWeight: active ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'ModuleDetailPage.dart';
// import 'profile_page.dart' hide ModuleDetailPage;
// import 'learn_page.dart';
// import 'scan_page.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String userName = "Loading...";
//   String cityName = "Oroquieta City";

//   // Weather
//   String weatherDescription = "";
//   double temperature = 0;
//   int humidity = 0;
//   double windSpeed = 0;
//   double precipitation = 0;
//   bool isLoadingWeather = true;

//   // Backend
//   final String backendBase = "https://agsecure-backend.onrender.com";
//   late Future<List<dynamic>> randomFeaturesFuture;

//   int selectedIndex = 0;
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//     loadUserName();
//     randomFeaturesFuture = loadRandomFeatures();
//   }

//   // Fetch username from Firestore
//   Future<void> loadUserName() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       try {
//         DocumentSnapshot doc = await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .get();
//         if (doc.exists) userName = doc['userName'] ?? "User";
//       } catch (_) {
//         userName = "User";
//       }
//       if (mounted) setState(() {});
//     }
//   }

//   // Load 3 random features from backend
//   Future<List<dynamic>> loadRandomFeatures() async {
//     try {
//       final Uri url = Uri.parse("$backendBase/api/feature/all");
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         List data = json.decode(response.body);
//         data.shuffle(Random());
//         return data.take(3).toList();
//       }
//     } catch (e) {
//       print("Error loading random features: $e");
//     }
//     return [];
//   }

//   // Fetch weather
//   Future<void> fetchWeather() async {
//     const apiKey = "a7bb72460433159aee012cbda57cdfd8";
//     final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
//     );

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         weatherDescription = data['weather'][0]['description'] ?? "";
//         temperature = data['main']['temp']?.toDouble() ?? 0;
//         humidity = data['main']['humidity'] ?? 0;
//         windSpeed = (data['wind']['speed'] ?? 0).toDouble();
//         precipitation = (data['rain']?['1h'] ?? 0).toDouble();
//       }
//     } catch (_) {}
//     if (mounted) setState(() => isLoadingWeather = false);
//   }

//   Widget buildPage() {
//     switch (selectedIndex) {
//       case 0:
//         return buildHomeContent();
//       case 1:
//         return const LearningPage();
//       case 2:
//         return const ScanPage();
//       case 3:
//         return const Center(child: Text("Seeds estimator"));
//       case 4:
//         return const ProfilePage();
//       default:
//         return buildHomeContent();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: SafeArea(child: buildPage()),
//       bottomNavigationBar: buildBottomNavigation(),
//     );
//   }

//   Widget buildBottomNavigation() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _NavItem(
//             iconPath: "image/image/house-solid-full.png",
//             label: "Home",
//             active: selectedIndex == 0,
//             onTap: () => setState(() => selectedIndex = 0),
//           ),
//           _NavItem(
//             iconPath: "image/image/book-open-solid-full.png",
//             label: "Learn",
//             active: selectedIndex == 1,
//             onTap: () => setState(() => selectedIndex = 1),
//           ),
//           // Bigger Scan Button
//           GestureDetector(
//             onTap: () => setState(() => selectedIndex = 2),
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: selectedIndex == 2
//                     ? const Color(0xFF1A6E34)
//                     : Colors.white,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 5,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Image.asset(
//                 "image/image/camera-solid-full.png",
//                 height: 40,
//                 color: selectedIndex == 2 ? Colors.white : Color(0xFF1A6E34),
//               ),
//             ),
//           ),
//           _NavItem(
//             iconPath: "image/image/calculator-solid-full.png",
//             label: "Calculate",
//             active: selectedIndex == 3,
//             onTap: () => setState(() => selectedIndex = 3),
//           ),
//           _NavItem(
//             iconPath: "image/image/user-solid-full.png",
//             label: "Profile",
//             active: selectedIndex == 4,
//             onTap: () => setState(() => selectedIndex = 4),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildHomeContent() {
//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Stack(
//             clipBehavior: Clip.none,
//             children: [
//               // Background image container
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   bottom: 80,
//                 ),
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(40),
//                   ),
//                   image: DecorationImage(
//                     image: AssetImage("assets/rice.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     RichText(
//                       text: TextSpan(
//                         text: "Welcome, ",
//                         style: const TextStyle(
//                           fontSize: 20,
//                           color: Colors.white,
//                           fontWeight: FontWeight.normal,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: userName,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "Saturday, 22 Nov 2025",
//                       style: TextStyle(fontSize: 14, color: Colors.white70),
//                     ),
//                     const SizedBox(height: 22),

//                     // Glassy / Transparent Search Bar
//                     Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         color: Colors.white.withOpacity(0.2),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(15),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                           child: TextField(
//                             controller: searchController,
//                             onChanged: (v) => setState(() => searchQuery = v),
//                             style: const TextStyle(color: Colors.white),
//                             decoration: const InputDecoration(
//                               hintText: "Search here...",
//                               hintStyle: TextStyle(color: Colors.white70),
//                               icon: Icon(Icons.search, color: Colors.white),
//                               border: InputBorder.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Glassy Weather Card
//               Positioned(
//                 left: 16,
//                 right: 16,
//                 bottom: -90,
//                 child: _buildWeatherCard(),
//               ),
//             ],
//           ),

//           const SizedBox(height: 120),

//           // RANDOM FEATURE SECTION
//           FutureBuilder<List<dynamic>>(
//             future: randomFeaturesFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const SizedBox(
//                   height: 260,
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                 return const SizedBox(
//                   height: 260,
//                   child: Center(child: Text("No features found")),
//                 );
//               }

//               final features = snapshot.data!;
//               return buildRandomFeatures(features);
//             },
//           ),

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget buildRandomFeatures(List features) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: const [
//               Text(
//                 "Get Started",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 "View all",
//                 style: TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF1A6E34),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 259,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: features.length,
//             padding: const EdgeInsets.only(left: 20),
//             itemBuilder: (context, index) {
//               final item = features[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ModuleDetailPage(feature: item),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 263,
//                   margin: const EdgeInsets.only(right: 15),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.shade300,
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: item["image"] != null
//                             ? Image.memory(
//                                 base64Decode(item["image"]),
//                                 width: 245,
//                                 height: 160,
//                                 fit: BoxFit.cover,
//                               )
//                             : Container(
//                                 width: 245,
//                                 height: 160,
//                                 color: Colors.grey.shade300,
//                                 child: const Icon(Icons.image_not_supported),
//                               ),
//                       ),
//                       const SizedBox(height: 6),
//                       Text(
//                         item["title"] ?? "",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),
//                       Text(
//                         item["description"] ?? "",
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // Glassy Weather Card
//   Widget _buildWeatherCard() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 6,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: isLoadingWeather
//               ? const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 )
//               : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(
//                                   Icons.location_on,
//                                   color: Colors.red,
//                                   size: 18,
//                                 ),
//                                 const SizedBox(width: 4),
//                                 Text(
//                                   cityName,
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 6),
//                             Text(
//                               "${temperature.toStringAsFixed(1)}°C | $weatherDescription",
//                               style: const TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const Icon(
//                           Icons.cloud_outlined,
//                           size: 48,
//                           color: Colors.white70,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         _weatherInfoItem(
//                           Icons.opacity,
//                           "Humidity",
//                           "$humidity%",
//                         ),
//                         _weatherInfoItem(
//                           Icons.grain,
//                           "Precip",
//                           "$precipitation mm",
//                         ),
//                         _weatherInfoItem(Icons.air, "Wind", "$windSpeed m/s"),
//                       ],
//                     ),
//                   ],
//                 ),
//         ),
//       ),
//     );
//   }

//   Widget _weatherInfoItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Icon(icon, size: 20, color: Colors.black87),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         Text(label, style: const TextStyle(fontSize: 10, color: Colors.black)),
//       ],
//     );
//   }
// }

// // Nav Item (top-level class)
// class _NavItem extends StatelessWidget {
//   final String iconPath;
//   final String label;
//   final bool active;
//   final VoidCallback? onTap;

//   const _NavItem({
//     Key? key,
//     required this.iconPath,
//     required this.label,
//     this.active = false,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Image.asset(
//             iconPath,
//             height: 26,
//             color: active ? const Color(0xFF1A6E34) : Colors.grey,
//           ),
//           const SizedBox(height: 3),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: active ? const Color(0xFF1A6E34) : Colors.grey,
//               fontWeight: active ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ModuleDetailPage.dart';
import 'profile_page.dart' hide ModuleDetailPage;
import 'learn_page.dart';
import 'scan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "Loading...";
  String cityName = "Oroquieta City";

  // Weather
  String weatherDescription = "";
  double temperature = 0;
  int humidity = 0;
  double windSpeed = 0;
  double precipitation = 0;
  bool isLoadingWeather = true;

  // Backend
  final String backendBase = "https://agsecure-backend.onrender.com";
  late Future<List<dynamic>> randomFeaturesFuture;

  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  // Seeds Estimator
  String selectedCrop = "Rice";
  final TextEditingController fieldAreaController = TextEditingController();
  double? totalSeedsRequired;

  @override
  void initState() {
    super.initState();
    fetchWeather();
    loadUserName();
    randomFeaturesFuture = loadRandomFeatures();
  }

  // Fetch username from Firestore
  Future<void> loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .get();
        if (doc.exists) userName = doc['userName'] ?? "User";
      } catch (_) {
        userName = "User";
      }
      if (mounted) setState(() {});
    }
  }

  // Load 3 random features from backend
  Future<List<dynamic>> loadRandomFeatures() async {
    try {
      final Uri url = Uri.parse("$backendBase/api/feature/all");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        data.shuffle(Random());
        return data.take(10).toList();
      }
    } catch (e) {
      print("Error loading random features: $e");
    }
    return [];
  }

  // Fetch weather
  Future<void> fetchWeather() async {
    const apiKey = "a7bb72460433159aee012cbda57cdfd8";
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        weatherDescription = data['weather'][0]['description'] ?? "";
        temperature = data['main']['temp']?.toDouble() ?? 0;
        humidity = data['main']['humidity'] ?? 0;
        windSpeed = (data['wind']['speed'] ?? 0).toDouble();
        precipitation = (data['rain']?['1h'] ?? 0).toDouble();
      }
    } catch (_) {}
    if (mounted) setState(() => isLoadingWeather = false);
  }

  Widget buildPage() {
    switch (selectedIndex) {
      case 0:
        return buildHomeContent();
      case 1:
        return const LearningPage();
      case 2:
        return const ScanPage();
      case 3:
        return const Text("Seeds estimator ni diri pero wapay sure");
      case 4:
        return const ProfilePage();
      default:
        return buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: SafeArea(child: buildPage()),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            iconPath: "image/image/house-solid-full.png",
            label: "Home",
            active: selectedIndex == 0,
            onTap: () => setState(() => selectedIndex = 0),
          ),
          _NavItem(
            iconPath: "image/image/book-open-solid-full.png",
            label: "Learn",
            active: selectedIndex == 1,
            onTap: () => setState(() => selectedIndex = 1),
          ),
          GestureDetector(
            onTap: () => setState(() => selectedIndex = 2),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: selectedIndex == 2
                    ? const Color(0xFF1A6E34)
                    : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Image.asset(
                "image/image/camera-solid-full.png",
                height: 40,
                color: selectedIndex == 2 ? Colors.white : Color(0xFF1A6E34),
              ),
            ),
          ),
          _NavItem(
            iconPath: "image/image/calculator-solid-full.png",
            label: "Calculate",
            active: selectedIndex == 3,
            onTap: () => setState(() => selectedIndex = 3),
          ),
          _NavItem(
            iconPath: "image/image/user-solid-full.png",
            label: "Profile",
            active: selectedIndex == 4,
            onTap: () => setState(() => selectedIndex = 4),
          ),
        ],
      ),
    );
  }

  Widget buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 80,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/rice.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Welcome, ",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            text: userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Saturday, 22 Nov 2025",
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) => setState(() => searchQuery = v),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              hintStyle: TextStyle(color: Colors.white70),
                              icon: Icon(Icons.search, color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: -90,
                child: _buildWeatherCard(),
              ),
            ],
          ),
          const SizedBox(height: 120),
          FutureBuilder<List<dynamic>>(
            future: randomFeaturesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 260,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox(
                  height: 260,
                  child: Center(child: Text("No features found")),
                );
              }
              final features = snapshot.data!;
              return buildRandomFeatures(features);
            },
          ),
          const SizedBox(height: 20),
          buildSeedsEstimatorFeature(context),
        ],
      ),
    );
  }

  Widget buildRandomFeatures(List features) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Get Started",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "View all",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A6E34),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 259,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: features.length,
            padding: const EdgeInsets.only(left: 20),
            itemBuilder: (context, index) {
              final item = features[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ModuleDetailPage(feature: item),
                    ),
                  );
                },
                child: Container(
                  width: 263,
                  margin: const EdgeInsets.only(right: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: item["image"] != null
                            ? Image.memory(
                                base64Decode(item["image"]),
                                width: 245,
                                height: 160,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 245,
                                height: 160,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item["title"] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        item["description"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Seeds Estimator showing pieces and kg
  Widget buildSeedsEstimatorFeature(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85;

    final Map<String, int> seedsPerHectare = {
      "Rice": 500000,
      "Corn": 6000,
      "Wheat": 200000,
      "Soybean": 250000,
    };

    final Map<String, double> seedWeightGrams = {
      "Rice": 0.03,
      "Corn": 0.3,
      "Wheat": 0.04,
      "Soybean": 0.15,
    };

    String formatNumber(num number) {
      return number.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Seeds Estimator",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: cardWidth,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Crop",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedCrop,
                  isExpanded: true,
                  items: seedsPerHectare.keys.map((crop) {
                    return DropdownMenuItem(value: crop, child: Text(crop));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCrop = value!;
                      totalSeedsRequired = null;
                      fieldAreaController.clear();
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: fieldAreaController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Field Area (ha)",
                  ),
                  onChanged: (value) {
                    final area = double.tryParse(value);
                    if (area != null) {
                      setState(() {
                        totalSeedsRequired =
                            (area * seedsPerHectare[selectedCrop]!).toDouble();
                      });
                    } else {
                      setState(() {
                        totalSeedsRequired = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: totalSeedsRequired != null
                        ? "${formatNumber(totalSeedsRequired!)} pieces\n"
                              "${((totalSeedsRequired! * seedWeightGrams[selectedCrop]!) / 1000).toStringAsFixed(2)} kg"
                        : "Result",
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isLoadingWeather
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 18,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  cityName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "${temperature.toStringAsFixed(1)}°C | $weatherDescription",
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.cloud_outlined,
                          size: 48,
                          color: Colors.white70,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _weatherInfoItem(
                          Icons.opacity,
                          "Humidity",
                          "$humidity%",
                        ),
                        _weatherInfoItem(
                          Icons.grain,
                          "Precip",
                          "$precipitation mm",
                        ),
                        _weatherInfoItem(Icons.air, "Wind", "$windSpeed m/s"),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _weatherInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.black)),
      ],
    );
  }
}

// Nav Item
class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    Key? key,
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 26,
            color: active ? const Color(0xFF1A6E34) : Colors.grey,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? const Color(0xFF1A6E34) : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
