import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ModuleDetailPage.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List features = [];
  List filteredFeatures = [];

  String selectedCategory = "All";
  String searchQuery = "";

  final String backendBase = "http://localhost:3000";

  @override
  void initState() {
    super.initState();
    fetchFeatures();
  }

  Future<void> fetchFeatures() async {
    try {
      final Uri url = Uri.parse("$backendBase/api/feature/all");
      final response = await http.get(url);

      if (!mounted) return; // <--- FIX

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          features = data;
          filteredFeatures = data;
        });
      } else {
        throw Exception("Failed to load features.");
      }
    } catch (e) {
      if (!mounted) return; // <--- FIX
      print("ERROR FETCHING FEATURES: $e");
    }
  }

  void filterFeatures() {
    if (!mounted) return; // <--- FIX

    setState(() {
      filteredFeatures = features.where((item) {
        final title = item["title"].toString().toLowerCase();
        final desc = item["description"].toString().toLowerCase();

        final matchesSearch = title.contains(searchQuery.toLowerCase());
        final matchesCategory =
            selectedCategory == "All" ||
            title.contains(selectedCategory.toLowerCase());

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  Widget buildCategoryButton(String name, IconData icon, bool active) {
    return GestureDetector(
      onTap: () {
        if (!mounted) return; // <--- FIX

        setState(() {
          selectedCategory = name;
        });
        filterFeatures();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: active ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? Colors.white : Colors.green),
            const SizedBox(width: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFeatureCard(dynamic feature) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleDetailPage(feature: feature),
          ),
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6E34),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to AgSecure Learning! ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey.shade600),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search here...",
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            searchQuery = value;
                            filterFeatures();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // buildCategoryButton(
                //   "Fruits",
                //   Icons.local_pizza,
                //   selectedCategory == "Fruits",
                // ),
                // buildCategoryButton(
                //   "Vegetables",
                //   Icons.eco,
                //   selectedCategory == "Vegetables",
                // ),
                GestureDetector(
                  onTap: () {
                    if (!mounted) return; // <--- FIX
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
                          ? Colors.green
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: filteredFeatures.isEmpty
                ? const Center(
                    child: Text(
                      "No items found...",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 30),
                    itemCount: filteredFeatures.length,
                    itemBuilder: (context, index) {
                      return buildFeatureCard(filteredFeatures[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
