// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// class FeatureService {
//   final String backendIP;

//   FeatureService({required this.backendIP});

//   // Load all features
//   Future<List<Map<String, dynamic>>> loadFeatures() async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/all");
//     final response = await http.get(uri);

//     print("Load Features response code: ${response.statusCode}");
//     print("Load Features response body: ${response.body}");

//     List<Map<String, dynamic>> loaded = [];

//     if (response.statusCode == 200) {
//       List data = jsonDecode(response.body);
//       for (var item in data) {
//         loaded.add({
//           "id": item["_id"],
//           "title": item["title"],
//           "description": item["description"],
//           "image": item["image"] != null && item["image"] != ""
//               ? base64Decode(item["image"])
//               : null,
//           "steps": item["steps"] != null
//               ? List<String>.from(item["steps"])
//               : [],
//         });
//       }
//     }

//     return loaded;
//   }

//   // Add a new feature
//   Future<bool> saveFeature(
//     Uint8List imageBytes,
//     String title,
//     String desc, {
//     List<String>? steps,
//   }) async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/add");
//     final body = {
//       "title": title,
//       "description": desc,
//       "image": base64Encode(imageBytes),
//       if (steps != null) "steps": steps, // send as array
//     };

//     print("Saving Feature: $body");

//     final response = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );

//     print("Save Feature response code: ${response.statusCode}");
//     print("Save Feature response body: ${response.body}");

//     return response.statusCode == 200;
//   }

//   // Update existing feature
//   Future<bool> updateFeature(
//     String id,
//     String title,
//     String desc,
//     Uint8List? imageBytes, {
//     required List<String> steps,
//   }) async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/update/$id");
//     final body = {
//       "title": title,
//       "description": desc,
//       if (imageBytes != null) "image": base64Encode(imageBytes),
//       "steps": steps, // send as array
//     };

//     print("Updating Feature $id: $body");

//     final response = await http.put(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );

//     print("Update Feature response code: ${response.statusCode}");
//     print("Update Feature response body: ${response.body}");

//     return response.statusCode == 200;
//   }

//   // Delete a feature
//   Future<bool> deleteFeature(String id) async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/delete/$id");
//     print("Deleting Feature ID: $id");

//     final response = await http.delete(uri);

//     print("Delete Feature response code: ${response.statusCode}");
//     print("Delete Feature response body: ${response.body}");

//     return response.statusCode == 200;
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class FeatureService {
  final String backendIP;

  FeatureService({required this.backendIP});

  // Load all features
  Future<List<Map<String, dynamic>>> loadFeatures() async {
    final uri = Uri.parse("http://$backendIP:3000/api/feature/all");
    try {
      final response = await http.get(uri);
      print("=== loadFeatures response ===");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        return [];
      }
    } catch (e, stack) {
      print("Error loading features: $e");
      print(stack);
      return [];
    }
  }

  // Save feature (create or update)
  Future<bool> saveFeature({
    String? id,
    required String title,
    required String description,
    required Uint8List? imageBytes,
    required List<Map<String, dynamic>> steps,
  }) async {
    try {
      final uri = id == null
          ? Uri.parse("http://$backendIP:3000/api/feature/add") // create
          : Uri.parse(
              "http://$backendIP:3000/api/feature/update/$id",
            ); // update

      final body = {
        "title": title,
        "description": description,
        "image": imageBytes != null ? base64Encode(imageBytes) : null,
        "steps": steps,
      };

      print("=== saveFeature request ===");
      print("URL: $uri");
      print("Body: ${jsonEncode(body)}");

      final response = id == null
          ? await http.post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            )
          : await http.put(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            );

      print("=== saveFeature response ===");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e, stack) {
      print("Error in saveFeature: $e");
      print(stack);
      return false;
    }
  }

  // Delete feature
  Future<bool> deleteFeature(String id) async {
    try {
      final uri = Uri.parse("http://$backendIP:3000/api/feature/delete/$id");
      final response = await http.delete(uri);
      print("=== deleteFeature response ===");
      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");
      return response.statusCode == 200;
    } catch (e, stack) {
      print("Error deleting feature: $e");
      print(stack);
      return false;
    }
  }
}
