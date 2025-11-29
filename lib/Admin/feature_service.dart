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
