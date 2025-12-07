// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'ModuleDetailPage.dart';
// import 'dart:ui';

// class LearningPage extends StatefulWidget {
//   const LearningPage({Key? key}) : super(key: key);

//   @override
//   State<LearningPage> createState() => _LearningPageState();
// }

// class _LearningPageState extends State<LearningPage> {
//   late Future<List<dynamic>> featuresFuture;
//   List<dynamic> allFeatures = [];
//   List<dynamic> filteredFeatures = [];
//   String selectedCategory = "All";
//   String searchQuery = "";

//   final String backendBase = "https://agsecure-backend.onrender.com";
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//     featuresFuture = fetchFeatures();
//   }

//   Future<List<dynamic>> fetchFeatures() async {
//     try {
//       final Uri url = Uri.parse("$backendBase/api/feature/all");
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List data = json.decode(response.body);
//         allFeatures = data;
//         filteredFeatures = List.from(allFeatures);
//         return data;
//       }
//     } catch (e) {
//       print("ERROR FETCHING FEATURES: $e");
//     }
//     return [];
//   }

//   void filterFeatures() {
//     setState(() {
//       filteredFeatures = allFeatures.where((item) {
//         final title = item["title"].toString().toLowerCase();
//         final matchesSearch = title.contains(searchQuery.toLowerCase());
//         final matchesCategory =
//             selectedCategory == "All" ||
//             title.contains(selectedCategory.toLowerCase());
//         return matchesSearch && matchesCategory;
//       }).toList();
//     });
//   }

//   Future<void> addReadingHistory(String featureId) async {
//     if (currentUser == null) return;

//     try {
//       final uri = Uri.parse("$backendBase/api/reading-history/add");
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"userId": currentUser!.uid, "featureId": featureId}),
//       );

//       if (response.statusCode == 200) print("✅ History added");
//     } catch (e) {
//       print("❌ Error adding history: $e");
//     }
//   }

//   Widget buildFeatureCard(dynamic feature) {
//     return GestureDetector(
//       onTap: () async {
//         await addReadingHistory(feature["_id"]);
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => ModuleDetailPage(feature: feature)),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: feature["image"] != null
//                   ? Image.memory(
//                       base64Decode(feature["image"]),
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     )
//                   : Container(
//                       width: 80,
//                       height: 80,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.image_not_supported, size: 30),
//                     ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     feature["title"] ?? "No Title",
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     feature["description"] ?? "No Description",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Column(
//         children: [
//           // ------------------ UPDATED HEADER WITH IMAGE ------------------
//           Container(
//             height: 200,
//             padding: const EdgeInsets.only(
//               top: 60,
//               left: 20,
//               right: 20,
//               bottom: 20,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               image: const DecorationImage(
//                 image: AssetImage("assets/rice.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Welcome to AgSecure Learning!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 6,
//                         color: Colors.black54,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Search box
//                 // Glassy / Transparent Search Bar for LearningPage
//                 Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     color: Colors.white.withOpacity(0.2),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             child: Icon(Icons.search, color: Colors.white),
//                           ),
//                           Expanded(
//                             child: TextField(
//                               decoration: const InputDecoration(
//                                 hintText: "Search here...",
//                                 hintStyle: TextStyle(color: Colors.white70),
//                                 border: InputBorder.none,
//                               ),
//                               style: const TextStyle(color: Colors.white),
//                               onChanged: (value) {
//                                 searchQuery = value;
//                                 filterFeatures();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // ---------------------------------------------------------------
//           const SizedBox(height: 20),

//           // Category row
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedCategory = "All";
//                     });
//                     filterFeatures();
//                   },
//                   child: Text(
//                     "All",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: selectedCategory == "All"
//                           ? Color(0xFF1A6E34)
//                           : Colors.grey.shade600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 10),

//           // Feature list
//           Expanded(
//             child: FutureBuilder<List<dynamic>>(
//               future: featuresFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No items found..."));
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.only(bottom: 30),
//                   itemCount: filteredFeatures.length,
//                   itemBuilder: (context, index) {
//                     return buildFeatureCard(filteredFeatures[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:http/http.dart' as http;
// import 'ModuleDetailPage.dart';
// import 'dart:ui';
// import 'package:shared_preferences/shared_preferences.dart';

// class LearningPage extends StatefulWidget {
//   const LearningPage({Key? key}) : super(key: key);

//   @override
//   State<LearningPage> createState() => _LearningPageState();
// }

// class _LearningPageState extends State<LearningPage> {
//   late Future<List<dynamic>> featuresFuture;
//   List<dynamic> allFeatures = [];
//   List<dynamic> filteredFeatures = [];
//   Map<String, bool> likedMap = {}; // featureId -> liked
//   Map<String, int> likeCountMap = {}; // featureId -> total likes
//   String selectedCategory = "All";
//   String searchQuery = "";

//   final String backendBase = "https://agsecure-backend.onrender.com";
//   User? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser;
//     featuresFuture = fetchFeatures();
//   }

//   Future<List<dynamic>> fetchFeatures() async {
//     try {
//       final Uri url = Uri.parse("$backendBase/api/feature/all");
//       final response = await http.get(url);

//       if (response.statusCode == 200) {
//         List data = json.decode(response.body);
//         allFeatures = data;
//         filteredFeatures = List.from(allFeatures);

//         // Fetch likes for each feature
//         for (var feature in data) {
//           await fetchLikes(feature["_id"]);
//         }

//         return data;
//       }
//     } catch (e) {
//       print("ERROR FETCHING FEATURES: $e");
//     }
//     return [];
//   }

//   void filterFeatures() {
//     setState(() {
//       filteredFeatures = allFeatures.where((item) {
//         final title = item["title"].toString().toLowerCase();
//         final matchesSearch = title.contains(searchQuery.toLowerCase());
//         final matchesCategory =
//             selectedCategory == "All" ||
//             title.contains(selectedCategory.toLowerCase());
//         return matchesSearch && matchesCategory;
//       }).toList();
//     });
//   }

//   Future<void> addReadingHistory(String featureId) async {
//     if (currentUser == null) return;

//     try {
//       final uri = Uri.parse("$backendBase/api/reading-history/add");
//       await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"userId": currentUser!.uid, "featureId": featureId}),
//       );
//     } catch (e) {
//       print("❌ Error adding history: $e");
//     }
//   }

//   // ❤️ LIKE feature toggle
//   Future<void> toggleLike(String featureId) async {
//     if (currentUser == null) return;
//     bool currentlyLiked = likedMap[featureId] ?? false;

//     final uri = Uri.parse(
//       "$backendBase/api/likes/${currentlyLiked ? 'unlike' : 'like'}",
//     );

//     try {
//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"userId": currentUser!.uid, "moduleId": featureId}),
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           likedMap[featureId] = !currentlyLiked;
//           if (!currentlyLiked) {
//             likeCountMap[featureId] = (likeCountMap[featureId] ?? 0) + 1;
//           } else {
//             likeCountMap[featureId] = (likeCountMap[featureId] ?? 1) - 1;
//           }
//         });
//       }
//     } catch (e) {
//       print("❌ Error toggling like: $e");
//     }
//   }

//   // Fetch initial likes for a feature
//   Future<void> fetchLikes(String featureId) async {
//     if (currentUser == null) return;

//     try {
//       // Check if user liked
//       final checkUri = Uri.parse(
//         "$backendBase/api/likes/check/${currentUser!.uid}/$featureId",
//       );
//       final checkResp = await http.get(checkUri);
//       if (checkResp.statusCode == 200) {
//         final likedData = jsonDecode(checkResp.body);
//         likedMap[featureId] = likedData["liked"] ?? false;
//       }

//       // Get total likes
//       final countUri = Uri.parse("$backendBase/api/likes/count/$featureId");
//       final countResp = await http.get(countUri);
//       if (countResp.statusCode == 200) {
//         final countData = jsonDecode(countResp.body);
//         likeCountMap[featureId] = countData["likes"] ?? 0;
//       }
//     } catch (e) {
//       print("❌ Error fetching likes: $e");
//     }
//   }

//   // ⬇ SAVE MODULE OFFLINE
//   Future<void> saveModuleOffline(dynamic feature) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();

//       List<String> savedModules =
//           prefs.getStringList("downloadedModules") ?? [];

//       savedModules.add(jsonEncode(feature));

//       await prefs.setStringList("downloadedModules", savedModules);
//     } catch (e) {
//       print("❌ Error saving module: $e");
//     }
//   }

//   Widget buildFeatureCard(dynamic feature) {
//     String featureId = feature["_id"];
//     bool liked = likedMap[featureId] ?? false;
//     int likesCount = likeCountMap[featureId] ?? 0;

//     return GestureDetector(
//       onTap: () async {
//         await addReadingHistory(feature["_id"]);
//         if (!mounted) return;
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => ModuleDetailPage(feature: feature)),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Row(
//           children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: feature["image"] != null
//                   ? Image.memory(
//                       base64Decode(feature["image"]),
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     )
//                   : Container(
//                       width: 80,
//                       height: 80,
//                       color: Colors.grey.shade300,
//                       child: const Icon(Icons.image_not_supported, size: 30),
//                     ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     feature["title"] ?? "No Title",
//                     style: const TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     feature["description"] ?? "No Description",
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
//                   ),
//                   const SizedBox(height: 10),
//                   // ❤️ LIKE + ⬇ DOWNLOAD BUTTONS
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: Icon(
//                           liked ? Icons.favorite : Icons.favorite_border,
//                         ),
//                         color: Colors.red,
//                         onPressed: () => toggleLike(featureId),
//                       ),
//                       Text("$likesCount"),
//                       const SizedBox(width: 12),
//                       IconButton(
//                         icon: const Icon(Icons.download),
//                         color: Colors.green,
//                         onPressed: () => saveModuleOffline(feature),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Column(
//         children: [
//           Container(
//             height: 200,
//             padding: const EdgeInsets.only(
//               top: 60,
//               left: 20,
//               right: 20,
//               bottom: 20,
//             ),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//               image: const DecorationImage(
//                 image: AssetImage("assets/rice.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Welcome to AgSecure Learning!",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 6,
//                         color: Colors.black54,
//                         offset: Offset(2, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   height: 48,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(14),
//                     color: Colors.white.withOpacity(0.2),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(14),
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                       child: Row(
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 12),
//                             child: Icon(Icons.search, color: Colors.white),
//                           ),
//                           Expanded(
//                             child: TextField(
//                               decoration: const InputDecoration(
//                                 hintText: "Search here...",
//                                 hintStyle: TextStyle(color: Colors.white70),
//                                 border: InputBorder.none,
//                               ),
//                               style: const TextStyle(color: Colors.white),
//                               onChanged: (value) {
//                                 searchQuery = value;
//                                 filterFeatures();
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedCategory = "All";
//                     });
//                     filterFeatures();
//                   },
//                   child: Text(
//                     "All",
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: selectedCategory == "All"
//                           ? const Color(0xFF1A6E34)
//                           : Colors.grey.shade600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Expanded(
//             child: FutureBuilder<List<dynamic>>(
//               future: featuresFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No items found..."));
//                 }
//                 return ListView.builder(
//                   padding: const EdgeInsets.only(bottom: 30),
//                   itemCount: filteredFeatures.length,
//                   itemBuilder: (context, index) {
//                     return buildFeatureCard(filteredFeatures[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'ModuleDetailPage.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late Future<List<dynamic>> featuresFuture;
  List<dynamic> allFeatures = [];
  List<dynamic> filteredFeatures = [];
  Map<String, bool> likedMap = {}; // featureId -> liked
  Map<String, int> likeCountMap = {}; // featureId -> total likes
  String selectedCategory = "All";
  String searchQuery = "";

  final String backendBase = "https://agsecure-backend.onrender.com";
  User? currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    featuresFuture = fetchFeatures();
  }

  Future<List<dynamic>> fetchFeatures() async {
    try {
      final Uri url = Uri.parse("$backendBase/api/feature/all");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        allFeatures = data;
        filteredFeatures = List.from(allFeatures);

        // Fetch likes for each feature
        for (var feature in data) {
          await fetchLikes(feature["_id"]);
        }

        return data;
      }
    } catch (e) {
      print("ERROR FETCHING FEATURES: $e");
    }
    return [];
  }

  void filterFeatures() {
    setState(() {
      filteredFeatures = allFeatures.where((item) {
        final title = item["title"].toString().toLowerCase();
        final matchesSearch = title.contains(searchQuery.toLowerCase());
        final matchesCategory =
            selectedCategory == "All" ||
            title.contains(selectedCategory.toLowerCase());
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Future<void> addReadingHistory(String featureId) async {
    if (currentUser == null) return;

    try {
      final uri = Uri.parse("$backendBase/api/reading-history/add");
      await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": currentUser!.uid, "featureId": featureId}),
      );
    } catch (e) {
      print("❌ Error adding history: $e");
    }
  }

  // ❤️ LIKE feature toggle
  Future<void> toggleLike(String featureId) async {
    if (currentUser == null) return;
    bool currentlyLiked = likedMap[featureId] ?? false;

    final uri = Uri.parse(
      "$backendBase/api/likes/${currentlyLiked ? 'unlike' : 'like'}",
    );

    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": currentUser!.uid, "moduleId": featureId}),
      );

      if (response.statusCode == 200) {
        // Update liked state
        likedMap[featureId] = !currentlyLiked;

        // Fetch the updated total like count from server
        final countUri = Uri.parse("$backendBase/api/likes/count/$featureId");
        final countResp = await http.get(countUri);
        if (countResp.statusCode == 200) {
          final countData = jsonDecode(countResp.body);
          likeCountMap[featureId] = countData["likes"] ?? 0;
        }

        if (mounted) setState(() {});
      }
    } catch (e) {
      print("❌ Error toggling like: $e");
    }
  }

  // Fetch initial likes for a feature
  Future<void> fetchLikes(String featureId) async {
    if (currentUser == null) return;

    try {
      // Check if user liked
      final checkUri = Uri.parse(
        "$backendBase/api/likes/check/${currentUser!.uid}/$featureId",
      );
      final checkResp = await http.get(checkUri);
      if (checkResp.statusCode == 200) {
        final likedData = jsonDecode(checkResp.body);
        likedMap[featureId] = likedData["liked"] ?? false;
      }

      // Get total likes
      final countUri = Uri.parse("$backendBase/api/likes/count/$featureId");
      final countResp = await http.get(countUri);
      if (countResp.statusCode == 200) {
        final countData = jsonDecode(countResp.body);
        likeCountMap[featureId] = countData["likes"] ?? 0;
      }

      if (mounted) setState(() {});
    } catch (e) {
      print("❌ Error fetching likes: $e");
    }
  }

  // ⬇ SAVE MODULE OFFLINE
  Future<void> saveModuleOffline(dynamic feature) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String> savedModules =
          prefs.getStringList("downloadedModules") ?? [];

      savedModules.add(jsonEncode(feature));

      await prefs.setStringList("downloadedModules", savedModules);
    } catch (e) {
      print("❌ Error saving module: $e");
    }
  }

  Widget buildFeatureCard(dynamic feature) {
    String featureId = feature["_id"];
    bool liked = likedMap[featureId] ?? false;
    int likesCount = likeCountMap[featureId] ?? 0;

    return GestureDetector(
      onTap: () async {
        await addReadingHistory(feature["_id"]);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ModuleDetailPage(feature: feature)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: feature["image"] != null
                  ? Image.memory(
                      base64Decode(feature["image"]),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image_not_supported, size: 30),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature["title"] ?? "No Title",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    feature["description"] ?? "No Description",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  // ❤️ LIKE + ⬇ DOWNLOAD BUTTONS
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          liked ? Icons.favorite : Icons.favorite_border,
                        ),
                        color: Colors.red,
                        onPressed: () => toggleLike(featureId),
                      ),
                      Text("$likesCount"),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.download),
                        color: Colors.green,
                        onPressed: () => saveModuleOffline(feature),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          Container(
            height: 200,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              image: const DecorationImage(
                image: AssetImage("assets/rice.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to AgSecure Learning!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 6,
                        color: Colors.black54,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(Icons.search, color: Colors.white),
                          ),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                hintText: "Search here...",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) {
                                searchQuery = value;
                                filterFeatures();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = "All";
                    });
                    filterFeatures();
                  },
                  child: Text(
                    "All",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selectedCategory == "All"
                          ? const Color(0xFF1A6E34)
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: featuresFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No items found..."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 30),
                  itemCount: filteredFeatures.length,
                  itemBuilder: (context, index) {
                    return buildFeatureCard(filteredFeatures[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
