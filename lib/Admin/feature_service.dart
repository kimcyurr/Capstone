import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class FeatureService {
  final String backendBase;

  FeatureService({required this.backendBase});

  // Load all features
  Future<List<Map<String, dynamic>>> loadFeatures() async {
    final uri = Uri.parse("$backendBase/api/feature/all");
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
    final uri = id == null
        ? Uri.parse("$backendBase/api/feature/add")
        : Uri.parse("$backendBase/api/feature/update/$id");

    final body = {
      "title": title,
      "description": description,
      "image": imageBytes != null ? base64Encode(imageBytes) : null,
      "steps": steps,
    };

    print("=== saveFeature request ===");
    print("URL: $uri");
    print("Body: ${jsonEncode(body)}");

    try {
      final response = await (id == null
          ? http.post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            )
          : http.put(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body),
            ));

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
    final uri = Uri.parse("$backendBase/api/feature/delete/$id");

    try {
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

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// class FeatureService {
//   final String backendBase;

//   FeatureService({required this.backendBase});

//   /// Safe decode: handles base64 or returns null
//   Uint8List? _decodeImage(dynamic imgData) {
//     if (imgData == null) return null;
//     try {
//       if (imgData is String) {
//         if (imgData.isEmpty) return null;
//         if (imgData.startsWith("http")) return null; // URL handled separately
//         return base64Decode(imgData);
//       } else if (imgData is Uint8List) {
//         return imgData;
//       }
//     } catch (_) {}
//     return null;
//   }

//   // ---------------------------------------------------------------------------
//   // Load all features
//   // ---------------------------------------------------------------------------
//   Future<List<Map<String, dynamic>>> loadFeatures() async {
//     final uri = Uri.parse("$backendBase/api/feature/all");

//     try {
//       final response = await http.get(uri);

//       print("=== loadFeatures response ===");
//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");

//       if (response.statusCode == 200) {
//         final raw = jsonDecode(response.body);

//         final List data = raw is List ? raw : [];

//         return data.map<Map<String, dynamic>>((item) {
//           final map = Map<String, dynamic>.from(item);

//           // Main image
//           final mainImage = _decodeImage(map["image"]);

//           // Steps
//           List<Map<String, dynamic>> parsedSteps = [];
//           if (map["steps"] is List) {
//             parsedSteps = (map["steps"] as List).map<Map<String, dynamic>>((
//               step,
//             ) {
//               final stepMap = Map<String, dynamic>.from(step);
//               return {
//                 "title": stepMap["title"],
//                 "content": stepMap["content"],
//                 "image": _decodeImage(stepMap["image"]),
//               };
//             }).toList();
//           }

//           return {...map, "image": mainImage, "steps": parsedSteps};
//         }).toList();
//       }

//       return [];
//     } catch (e, stack) {
//       print("Error loading features: $e");
//       print(stack);
//       return [];
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Save feature (add or update)
//   // ---------------------------------------------------------------------------
//   Future<bool> saveFeature({
//     String? id,
//     required String title,
//     required String description,
//     required Uint8List? imageBytes,
//     required List<Map<String, dynamic>> steps,
//   }) async {
//     final uri = id == null
//         ? Uri.parse("$backendBase/api/feature/add")
//         : Uri.parse("$backendBase/api/feature/update/$id");

//     // Serialize step images
//     final serializedSteps = steps.map((step) {
//       return {
//         "title": step["title"],
//         "content": step["content"],
//         "image": step["image"] != null ? base64Encode(step["image"]) : null,
//       };
//     }).toList();

//     final body = {
//       "title": title,
//       "description": description,
//       "image": imageBytes != null ? base64Encode(imageBytes) : null,
//       "steps": serializedSteps,
//     };

//     print("=== saveFeature REQUEST ===");
//     print("URL: $uri");
//     print("Body: ${jsonEncode(body)}");

//     try {
//       final response = id == null
//           ? await http.post(
//               uri,
//               headers: {'Content-Type': 'application/json'},
//               body: jsonEncode(body),
//             )
//           : await http.put(
//               uri,
//               headers: {'Content-Type': 'application/json'},
//               body: jsonEncode(body),
//             );

//       print("=== saveFeature RESPONSE ===");
//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");

//       return response.statusCode == 200;
//     } catch (e, stack) {
//       print("Error in saveFeature: $e");
//       print(stack);
//       return false;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Delete feature
//   // ---------------------------------------------------------------------------
//   Future<bool> deleteFeature(String id) async {
//     final uri = Uri.parse("$backendBase/api/feature/delete/$id");

//     try {
//       final response = await http.delete(uri);

//       print("=== deleteFeature RESPONSE ===");
//       print("Status: ${response.statusCode}");
//       print("Body: ${response.body}");

//       return response.statusCode == 200;
//     } catch (e, stack) {
//       print("Error deleting feature: $e");
//       print(stack);
//       return false;
//     }
//   }
// }
