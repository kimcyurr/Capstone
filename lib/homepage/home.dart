// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'ModuleDetailPage.dart';
// import 'profile_page.dart' hide ModuleDetailPage;
// import 'learn_page.dart';
// import 'dart:math';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String userName = "Loading...";

//   String cityName = "Oroquieta City";
//   String weatherDescription = "";
//   double temperature = 0;
//   int humidity = 0;
//   double windSpeed = 0;
//   double precipitation = 0;
//   bool isLoadingWeather = true;

//   // ==== RANDOM FEATURES (from backend) ====
//   List randomFeatures = [];
//   final String backendBase = "http://localhost:3000";

//   int selectedIndex = 0;
//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//     loadUserName();
//     loadRandomFeatures(); //  Added
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

//         if (doc.exists) {
//           setState(() {
//             userName = doc['userName'] ?? "User";
//           });
//         } else {
//           setState(() => userName = "User");
//         }
//       } catch (e) {
//         setState(() => userName = "User");
//         print("Error fetching username: $e");
//       }
//     }
//   }

//   // ====== LOAD RANDOM FEATURES FROM BACKEND ======
//   Future<void> loadRandomFeatures() async {
//     try {
//       final Uri url = Uri.parse("$backendBase/api/feature/all");
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List data = json.decode(response.body);

//         data.shuffle(Random());
//         setState(() {
//           randomFeatures = data.take(3).toList();
//         });
//       }
//     } catch (e) {
//       print("Error loading random features: $e");
//     }
//   }

//   // Fetch weather from OpenWeatherMap
//   Future<void> fetchWeather() async {
//     const apiKey = "a7bb72460433159aee012cbda57cdfd8";
//     final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
//     );

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           temperature = data['main']['temp'];
//           weatherDescription = data['weather'][0]['description'] ?? "Unknown";
//           humidity = data['main']['humidity'] ?? 0;
//           windSpeed = (data['wind']['speed'] ?? 0).toDouble();
//           precipitation = (data['rain']?['1h'] ?? 0).toDouble();
//           isLoadingWeather = false;
//         });
//       } else {
//         setState(() => isLoadingWeather = false);
//       }
//     } catch (e) {
//       setState(() => isLoadingWeather = false);
//     }
//   }

//   Stream<QuerySnapshot> getTutorials() {
//     return FirebaseFirestore.instance.collection('tutorials').snapshots();
//   }

//   Widget buildPage() {
//     switch (selectedIndex) {
//       case 0:
//         return buildHomeContent();
//       case 1:
//         return const LearningPage();
//       case 2:
//         return const Center(child: Text("Scanning ni diri "));
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
//       backgroundColor: const Color(0xFFD9D9D9),
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
//           _NavItem(
//             iconPath: "image/image/camera-solid-full.png",
//             label: "Scan",
//             active: selectedIndex == 2,
//             onTap: () => setState(() => selectedIndex = 2),
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
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.only(
//                   top: 20,
//                   left: 20,
//                   right: 20,
//                   bottom: 80,
//                 ),
//                 decoration: const BoxDecoration(
//                   color: Color(0xFF1A6E34),
//                   borderRadius: BorderRadius.vertical(
//                     bottom: Radius.circular(40),
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
//                           fontWeight: FontWeight.normal, // normal for 'Welcome'
//                         ),
//                         children: [
//                           TextSpan(
//                             text: userName, // bold for username
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
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF2E8B57),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: TextField(
//                         controller: searchController,
//                         onChanged: (v) => setState(() => searchQuery = v),
//                         style: const TextStyle(color: Colors.white),
//                         decoration: const InputDecoration(
//                           hintText: "Search here...",
//                           hintStyle: TextStyle(color: Colors.white70),
//                           icon: Icon(Icons.search, color: Colors.white),
//                           border: InputBorder.none,
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

//           // ========= RANDOM TUTORIAL SECTION =========
//           buildTutorialSection(),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   // ================== BUILD RANDOM TUTORIAL SECTION ==================
//   Widget buildTutorialSection() {
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
//             itemCount: randomFeatures.length,
//             padding: const EdgeInsets.only(left: 20),
//             itemBuilder: (context, index) {
//               final item = randomFeatures[index];

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
//                         child: Image.memory(
//                           base64Decode(item["image"]),
//                           width: 245,
//                           height: 160,
//                           fit: BoxFit.cover,
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       Text(
//                         item["title"],
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
//                       ),

//                       Text(
//                         item["description"],
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

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ModuleDetailPage.dart';
import 'profile_page.dart' hide ModuleDetailPage;
import 'learn_page.dart';

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
  final String backendBase = "http://localhost:3000";
  late Future<List<dynamic>> randomFeaturesFuture;

  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

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
        return data.take(3).toList();
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
        return const Center(child: Text("Scanning ni diri "));
      case 3:
        return const Center(child: Text("Seeds estimator"));
      case 4:
        return const ProfilePage();
      default:
        return buildHomeContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
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
          _NavItem(
            iconPath: "image/image/camera-solid-full.png",
            label: "Scan",
            active: selectedIndex == 2,
            onTap: () => setState(() => selectedIndex = 2),
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
                  color: Color(0xFF1A6E34),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(40),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E8B57),
                        borderRadius: BorderRadius.circular(15),
                      ),
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
                  ],
                ),
              ),

              // Weather Card
              Positioned(
                left: 16,
                right: 16,
                bottom: -90,
                child: _buildWeatherCard(),
              ),
            ],
          ),
          const SizedBox(height: 120),

          // RANDOM FEATURE SECTION
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
                  color: Colors.green,
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

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isLoadingWeather
          ? const Center(child: CircularProgressIndicator())
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${temperature.toStringAsFixed(1)}°C | $weatherDescription",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.cloud_outlined,
                      size: 48,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherInfoItem(Icons.opacity, "Humidity", "$humidity%"),
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
    );
  }

  Widget _weatherInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

// Nav item
class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  });

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
