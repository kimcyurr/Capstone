import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ModuleDetailPage.dart';

class DownloadsPage extends StatefulWidget {
  const DownloadsPage({Key? key}) : super(key: key);

  @override
  State<DownloadsPage> createState() => _DownloadsPageState();
}

class _DownloadsPageState extends State<DownloadsPage> {
  List<dynamic> downloadedModules = [];

  @override
  void initState() {
    super.initState();
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedModules = prefs.getStringList("downloadedModules") ?? [];

    setState(() {
      downloadedModules = savedModules.map((e) => jsonDecode(e)).toList();
    });
  }

  Future<void> deleteModule(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    downloadedModules.removeAt(index);

    List<String> savedModules = downloadedModules
        .map((e) => jsonEncode(e))
        .toList();

    await prefs.setStringList("downloadedModules", savedModules);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: const Text("Downloaded Modules"),
        centerTitle: true,
      ),
      body: downloadedModules.isEmpty
          ? const Center(
              child: Text(
                "No downloaded modules yet...",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: downloadedModules.length,
              itemBuilder: (context, index) {
                final feature = downloadedModules[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: feature["image"] != null
                          ? Image.memory(
                              base64Decode(feature["image"]),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image_not_supported),
                            ),
                    ),
                    title: Text(
                      feature["title"] ?? "No Title",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      feature["description"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteModule(index),
                    ),
                    onTap: () {
                      // Open offline module
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ModuleDetailPage(feature: feature),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
