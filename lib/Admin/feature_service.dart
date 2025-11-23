// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:http/http.dart' as http;

// class FeatureService {
//   final String backendIP;

//   FeatureService({required this.backendIP});

//   Future<List<Map<String, dynamic>>> loadFeatures() async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/all");
//     final response = await http.get(uri);
//     List<Map<String, dynamic>> loaded = [];

//     if (response.statusCode == 200) {
//       List data = jsonDecode(response.body);
//       for (var item in data) {
//         if (item["image"] != null && item["image"] != "") {
//           loaded.add({
//             "id": item["_id"],
//             "title": item["title"],
//             "description": item["description"],
//             "image": base64Decode(item["image"]),
//           });
//         }
//       }
//     }
//     return loaded;
//   }

//   Future<bool> saveFeature(
//     Uint8List imageBytes,
//     String title,
//     String desc,
//   ) async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/add");
//     final body = {
//       "title": title,
//       "description": desc,
//       "image": base64Encode(imageBytes),
//     };
//     final response = await http.post(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );
//     return response.statusCode == 200;
//   }

//   Future<bool> deleteFeature(String id) async {
//     final uri = Uri.parse("http://$backendIP:3000/api/feature/delete/$id");
//     final response = await http.delete(uri);
//     return response.statusCode == 200;
//   }

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
//       "steps": steps,
//     };
//     final response = await http.put(
//       uri,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode(body),
//     );
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
    final response = await http.get(uri);

    print("Load Features response code: ${response.statusCode}");
    print("Load Features response body: ${response.body}");

    List<Map<String, dynamic>> loaded = [];

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (var item in data) {
        loaded.add({
          "id": item["_id"],
          "title": item["title"],
          "description": item["description"],
          "image": item["image"] != null && item["image"] != ""
              ? base64Decode(item["image"])
              : null,
          "steps": item["steps"] != null
              ? List<String>.from(item["steps"])
              : [],
        });
      }
    }

    return loaded;
  }

  // Add a new feature
  Future<bool> saveFeature(
    Uint8List imageBytes,
    String title,
    String desc, {
    List<String>? steps,
  }) async {
    final uri = Uri.parse("http://$backendIP:3000/api/feature/add");
    final body = {
      "title": title,
      "description": desc,
      "image": base64Encode(imageBytes),
      if (steps != null) "steps": steps, // send as array
    };

    print("Saving Feature: $body");

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("Save Feature response code: ${response.statusCode}");
    print("Save Feature response body: ${response.body}");

    return response.statusCode == 200;
  }

  // Update existing feature
  Future<bool> updateFeature(
    String id,
    String title,
    String desc,
    Uint8List? imageBytes, {
    required List<String> steps,
  }) async {
    final uri = Uri.parse("http://$backendIP:3000/api/feature/update/$id");
    final body = {
      "title": title,
      "description": desc,
      if (imageBytes != null) "image": base64Encode(imageBytes),
      "steps": steps, // send as array
    };

    print("Updating Feature $id: $body");

    final response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("Update Feature response code: ${response.statusCode}");
    print("Update Feature response body: ${response.body}");

    return response.statusCode == 200;
  }

  // Delete a feature
  Future<bool> deleteFeature(String id) async {
    final uri = Uri.parse("http://$backendIP:3000/api/feature/delete/$id");
    print("Deleting Feature ID: $id");

    final response = await http.delete(uri);

    print("Delete Feature response code: ${response.statusCode}");
    print("Delete Feature response body: ${response.body}");

    return response.statusCode == 200;
  }
}
