// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;

// class AdminDashboard extends StatefulWidget {
//   const AdminDashboard({super.key});

//   @override
//   State<AdminDashboard> createState() => _AdminDashboardState();
// }

// class _AdminDashboardState extends State<AdminDashboard> {
//   Uint8List? selectedImageBytes;

//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descController = TextEditingController();

//   List<Map<String, dynamic>> features = [];

//   // --------------------------
//   // Flutter Web: use localhost
//   // --------------------------
//   final String backendIP = "localhost";

//   // --------------------------
//   // Pick Image
//   // --------------------------
//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final bytes = await picked.readAsBytes();
//       setState(() => selectedImageBytes = bytes);
//     }
//   }

//   // --------------------------
//   // Save Feature to MongoDB
//   // --------------------------
//   Future<void> saveFeatureToMongoDB(
//     Uint8List imageBytes,
//     String title,
//     String desc,
//   ) async {
//     try {
//       if (title.isEmpty || desc.isEmpty || imageBytes.isEmpty) {
//         print("⚠️ One of the fields is empty");
//         return;
//       }

//       String base64Image = base64Encode(imageBytes);

//       final requestBody = {
//         "title": title,
//         "description": desc,
//         "image": base64Image,
//       };

//       final uri = Uri.parse("http://$backendIP:3000/api/feature/add");

//       final response = await http.post(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );

//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         print("✅ Feature saved to MongoDB");
//         await loadFeaturesFromMongo();
//       } else {
//         print("❌ Failed to save feature");
//       }
//     } catch (e) {
//       print("⚠️ Error saving feature: $e");
//     }
//   }

//   // --------------------------
//   // Load Features from MongoDB
//   // --------------------------
//   Future<void> loadFeaturesFromMongo() async {
//     try {
//       final uri = Uri.parse("http://$backendIP:3000/api/feature/all");
//       final response = await http.get(uri);

//       print("GET Features Status: ${response.statusCode}");
//       print("GET Features Body: ${response.body}");

//       if (response.statusCode == 200) {
//         List data = jsonDecode(response.body);
//         List<Map<String, dynamic>> loaded = [];

//         for (var item in data) {
//           if (item["image"] != null && item["image"] != "") {
//             Uint8List img = base64Decode(item["image"]);
//             loaded.add({
//               "id": item["_id"], // add ID for edit/delete
//               "title": item["title"],
//               "description": item["description"],
//               "image": img,
//             });
//           }
//         }

//         setState(() {
//           features = loaded;
//         });
//       }
//     } catch (e) {
//       print("⚠️ Error loading features: $e");
//     }
//   }

//   // --------------------------
//   // DELETE Feature
//   // --------------------------
//   Future<void> deleteFeature(String id) async {
//     try {
//       final uri = Uri.parse("http://$backendIP:3000/api/feature/delete/$id");
//       final response = await http.delete(uri);

//       if (response.statusCode == 200) {
//         print("🗑 Feature deleted");
//         await loadFeaturesFromMongo();
//       }
//     } catch (e) {
//       print("⚠️ Error deleting: $e");
//     }
//   }

//   // --------------------------
//   // EDIT / UPDATE Feature
//   // --------------------------
//   Future<void> editFeature(
//     String id,
//     String newTitle,
//     String newDesc,
//     Uint8List? newImageBytes,
//   ) async {
//     try {
//       String? base64Image = newImageBytes != null
//           ? base64Encode(newImageBytes)
//           : null;

//       final uri = Uri.parse("http://$backendIP:3000/api/feature/update/$id");

//       final requestBody = {
//         "title": newTitle,
//         "description": newDesc,
//         if (base64Image != null) "image": base64Image,
//       };

//       final response = await http.put(
//         uri,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         print("✏ Feature updated");
//         await loadFeaturesFromMongo();
//       }
//     } catch (e) {
//       print("⚠️ Error updating feature: $e");
//     }
//   }

//   // --------------------------
//   // ADD Feature
//   // --------------------------
//   void addFeature() async {
//     if (selectedImageBytes == null ||
//         titleController.text.isEmpty ||
//         descController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please complete all fields")),
//       );
//       return;
//     }

//     await saveFeatureToMongoDB(
//       selectedImageBytes!,
//       titleController.text,
//       descController.text,
//     );

//     setState(() {
//       selectedImageBytes = null;
//       titleController.clear();
//       descController.clear();
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Feature added successfully!")),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadFeaturesFromMongo();
//   }

//   // --------------------------
//   // EDIT Dialog
//   // --------------------------
//   void showEditDialog(Map<String, dynamic> feature) {
//     TextEditingController updateTitle = TextEditingController(
//       text: feature["title"],
//     );
//     TextEditingController updateDesc = TextEditingController(
//       text: feature["description"],
//     );

//     Uint8List? newImageBytes;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Edit Feature"),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 GestureDetector(
//                   onTap: () async {
//                     final picked = await ImagePicker().pickImage(
//                       source: ImageSource.gallery,
//                     );
//                     if (picked != null) {
//                       final bytes = await picked.readAsBytes();
//                       setState(() => newImageBytes = bytes);
//                     }
//                   },
//                   child: Container(
//                     height: 150,
//                     width: double.infinity,
//                     color: Colors.grey[200],
//                     child: newImageBytes != null
//                         ? Image.memory(newImageBytes!, fit: BoxFit.cover)
//                         : Image.memory(feature["image"], fit: BoxFit.cover),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: updateTitle,
//                   decoration: const InputDecoration(labelText: "Title"),
//                 ),
//                 const SizedBox(height: 10),
//                 TextField(
//                   controller: updateDesc,
//                   decoration: const InputDecoration(labelText: "Description"),
//                   maxLines: 3,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 editFeature(
//                   feature["id"],
//                   updateTitle.text,
//                   updateDesc.text,
//                   newImageBytes,
//                 );
//                 Navigator.pop(context);
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // --------------------------
//   // UI
//   // --------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Admin Dashboard")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // --------------------------
//             // 🔹 Gender Analytics (Firestore)
//             // --------------------------
//             const Text(
//               "Gender Analytics",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('users')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Text("No users found");
//                 }

//                 int male = 0, female = 0, other = 0;

//                 for (var doc in snapshot.data!.docs) {
//                   final data = doc.data() as Map<String, dynamic>;
//                   final gender = (data['gender'] ?? 'other')
//                       .toString()
//                       .toLowerCase();

//                   if (gender == 'male')
//                     male++;
//                   else if (gender == 'female')
//                     female++;
//                   else
//                     other++;
//                 }

//                 int total = male + female + other;
//                 double malePercent = total == 0 ? 0 : male / total;
//                 double femalePercent = total == 0 ? 0 : female / total;
//                 double otherPercent = total == 0 ? 0 : other / total;

//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     buildAnalyticsCard(
//                       "Male",
//                       male,
//                       malePercent,
//                       Colors.blue,
//                       Icons.male,
//                     ),
//                     buildAnalyticsCard(
//                       "Female",
//                       female,
//                       femalePercent,
//                       Colors.pink,
//                       Icons.female,
//                     ),
//                     buildAnalyticsCard(
//                       "Other",
//                       other,
//                       otherPercent,
//                       Colors.green,
//                       Icons.transgender,
//                     ),
//                   ],
//                 );
//               },
//             ),

//             const SizedBox(height: 25),

//             // --------------------------
//             // 🔹 Add New Feature (MongoDB)
//             // --------------------------
//             const Text(
//               "Add New Feature",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             GestureDetector(
//               onTap: pickImage,
//               child: Container(
//                 height: 180,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   border: Border.all(color: Colors.grey),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: selectedImageBytes == null
//                     ? const Center(child: Text("Tap to pick an image"))
//                     : ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.memory(
//                           selectedImageBytes!,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(
//                 labelText: "Title",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descController,
//               maxLines: 3,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: addFeature,
//               child: const Text("Add Feature"),
//             ),

//             const SizedBox(height: 25),

//             // --------------------------
//             // 🔹 Feature List (MongoDB) with EDIT + DELETE
//             // --------------------------
//             const Text(
//               "Added Features",
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 12),
//             Column(
//               children: features.map((feature) {
//                 return Card(
//                   child: ListTile(
//                     leading: Image.memory(
//                       feature["image"],
//                       width: 60,
//                       fit: BoxFit.cover,
//                     ),
//                     title: Text(feature["title"]),
//                     subtitle: Text(feature["description"]),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit, color: Colors.orange),
//                           onPressed: () => showEditDialog(feature),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => deleteFeature(feature["id"]),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // --------------------------
//   Widget buildAnalyticsCard(
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
import 'gender_analytics_widget.dart';
import 'feature_crud_widget.dart';
import 'feature_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final featureService = FeatureService(backendIP: "localhost");

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GenderAnalyticsWidget(),
            const SizedBox(height: 25),
            FeatureCrudWidget(featureService: featureService),
          ],
        ),
      ),
    );
  }
}
