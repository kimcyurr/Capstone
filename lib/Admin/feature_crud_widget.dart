import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'feature_service.dart';

class FeatureCrudWidget extends StatefulWidget {
  final FeatureService featureService;

  const FeatureCrudWidget({super.key, required this.featureService});

  @override
  State<FeatureCrudWidget> createState() => _FeatureCrudWidgetState();
}

class _FeatureCrudWidgetState extends State<FeatureCrudWidget> {
  List<Map<String, dynamic>> features = [];
  final _formKey = GlobalKey<FormState>();

  // Form state for creating a new feature
  Uint8List? newImageBytes;
  final TextEditingController newTitleController = TextEditingController();
  final TextEditingController newDescController = TextEditingController();
  List<Map<String, TextEditingController>> newFeatureSteps = [
    {"title": TextEditingController(), "content": TextEditingController()},
  ];

  // Controllers for editing existing features: featureId -> list of step controllers
  Map<String, List<Map<String, TextEditingController>>> stepControllers = {};

  // For edit mode (holds currently editing feature id)
  String? editingFeatureId;
  Uint8List? editingImageBytes;
  final TextEditingController editingTitleController = TextEditingController();
  final TextEditingController editingDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllFeatures();
  }

  @override
  void dispose() {
    newTitleController.dispose();
    newDescController.dispose();
    for (var s in newFeatureSteps) {
      s["title"]!.dispose();
      s["content"]!.dispose();
    }
    editingTitleController.dispose();
    editingDescController.dispose();
    for (var controllers in stepControllers.values) {
      for (var c in controllers) {
        c["title"]!.dispose();
        c["content"]!.dispose();
      }
    }
    super.dispose();
  }

  Future<void> loadAllFeatures() async {
    final data = await widget.featureService.loadFeatures();
    setState(() {
      features = data;
      stepControllers.clear();

      // Initialize controllers for existing features
      for (var f in features) {
        final id = f["_id"] ?? f["id"] ?? "";
        final rawSteps = f["steps"] ?? [];

        List<Map<String, TextEditingController>> controllers = [];

        // handle old/new format:
        // - old format might be ["Step title", "Another step"]
        // - new format is [{"title":"...","content":"..."}, ...]
        if (rawSteps is List) {
          for (var s in rawSteps) {
            if (s is String) {
              controllers.add({
                "title": TextEditingController(text: s),
                "content": TextEditingController(text: ""),
              });
            } else if (s is Map) {
              controllers.add({
                "title": TextEditingController(text: s["title"] ?? ""),
                "content": TextEditingController(text: s["content"] ?? ""),
              });
            } else {
              controllers.add({
                "title": TextEditingController(text: s.toString()),
                "content": TextEditingController(text: ""),
              });
            }
          }
        }

        if (controllers.isEmpty) {
          controllers = [
            {
              "title": TextEditingController(),
              "content": TextEditingController(),
            },
          ];
        }

        stepControllers[id] = controllers;
      }
    });
  }

  Future<void> pickNewImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => newImageBytes = bytes);
    }
  }

  Future<void> pickEditingImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => editingImageBytes = bytes);
    }
  }

  // Create feature
  Future<void> addFeature() async {
    if (newTitleController.text.trim().isEmpty ||
        newDescController.text.trim().isEmpty ||
        newImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide title, description and image'),
        ),
      );
      return;
    }

    final steps = newFeatureSteps.map((s) {
      return {
        "title": s["title"]!.text.trim(),
        "content": s["content"]!.text.trim(),
      };
    }).toList();

    final success = await widget.featureService.saveFeature(
      title: newTitleController.text.trim(),
      description: newDescController.text.trim(),
      imageBytes: newImageBytes,
      steps: steps,
    );

    if (success) {
      setState(() {
        newImageBytes = null;
        newTitleController.clear();
        newDescController.clear();
        for (var s in newFeatureSteps) {
          s["title"]!.clear();
          s["content"]!.clear();
        }
        newFeatureSteps = [
          {
            "title": TextEditingController(),
            "content": TextEditingController(),
          },
        ];
      });
      await loadAllFeatures();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save feature')));
    }
  }

  Future<void> deleteFeature(String id) async {
    final ok = await widget.featureService.deleteFeature(id);
    if (ok) {
      await loadAllFeatures();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete feature')));
    }
  }

  void openEditDialog(Map<String, dynamic> feature) {
    final id = feature["_id"] ?? feature["id"];
    if (id == null) return; // safety check

    editingFeatureId = id;
    editingTitleController.text = feature["title"] ?? "";
    editingDescController.text = feature["description"] ?? "";
    editingImageBytes =
        (feature["image"] != null &&
            feature["image"] is String &&
            (feature["image"] as String).isNotEmpty)
        ? base64Decode(feature["image"])
        : null;

    stepControllers[id] ??= [
      {"title": TextEditingController(), "content": TextEditingController()},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void addStep() {
              setStateDialog(() {
                stepControllers[id]!.add({
                  "title": TextEditingController(),
                  "content": TextEditingController(),
                });
              });
            }

            void removeStep(int index) {
              if (stepControllers[id]!.length > 1) {
                setStateDialog(() {
                  stepControllers[id]!.removeAt(index);
                });
              }
            }

            return AlertDialog(
              title: const Text("Edit Feature"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final p = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (p != null) {
                          final b = await p.readAsBytes();
                          setStateDialog(() => editingImageBytes = b);
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: editingImageBytes != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  editingImageBytes!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(child: Text("Tap to pick image")),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: editingTitleController,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: editingDescController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Steps",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(stepControllers[id]!.length, (index) {
                      final s = stepControllers[id]![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          children: [
                            TextField(
                              controller: s["title"],
                              decoration: InputDecoration(
                                labelText: "Step ${index + 1} Title",
                              ),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: s["content"],
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: "Step ${index + 1} Content",
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => removeStep(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton.icon(
                        onPressed: addStep,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "Add Step",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (editingFeatureId == null) return;

                    // Safely collect steps
                    final updatedSteps = stepControllers[editingFeatureId!]!
                        .map(
                          (s) => {
                            "title": s["title"]?.text.trim() ?? "",
                            "content": s["content"]?.text.trim() ?? "",
                          },
                        )
                        .toList();

                    final success = await widget.featureService.saveFeature(
                      id: editingFeatureId,
                      title: editingTitleController.text.trim(),
                      description: editingDescController.text.trim(),
                      imageBytes: editingImageBytes,
                      steps: updatedSteps,
                    );

                    if (success) {
                      Navigator.pop(context);
                      await loadAllFeatures();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update feature'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _newStepEditor(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          TextField(
            controller: newFeatureSteps[index]["title"],
            decoration: InputDecoration(labelText: "Step ${index + 1} Title"),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: newFeatureSteps[index]["content"],
            maxLines: 3,
            decoration: InputDecoration(labelText: "Step ${index + 1} Content"),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () {
                if (newFeatureSteps.length > 1) {
                  setState(() => newFeatureSteps.removeAt(index));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Module",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: pickNewImage,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: newImageBytes == null
                  ? const Center(child: Text("Tap to pick an image"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(newImageBytes!, fit: BoxFit.cover),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: newTitleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: newDescController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          const SizedBox(height: 12),
          const Text("Steps", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(
            newFeatureSteps.length,
            (index) => _newStepEditor(index),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () => setState(() {
                newFeatureSteps.add({
                  "title": TextEditingController(),
                  "content": TextEditingController(),
                });
              }),
              icon: const Icon(Icons.add),
              label: const Text(
                "Add Step",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addFeature,
              child: const Text(
                "Add Module",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            "Added Modules",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...features.map((f) {
            final id = f["_id"] ?? f["id"] ?? "";
            final imgBytes =
                (f["image"] != null &&
                    (f["image"] is String) &&
                    (f["image"] as String).isNotEmpty)
                ? base64Decode(f["image"])
                : null;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: imgBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          imgBytes,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(width: 60, height: 60, color: Colors.grey[300]),
                title: Text(
                  f["title"] ?? "No Title",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      f["description"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (f["steps"] != null &&
                        (f["steps"] is List) &&
                        (f["steps"] as List).isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Steps preview:",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ...((f["steps"] as List).take(2).map((s) {
                            if (s is String) {
                              return Text(
                                "- ${s.toString()}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else if (s is Map) {
                              return Text(
                                "- ${s['title'] ?? ''}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else {
                              return Text(
                                "- ${s.toString()}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }
                          }).toList()),
                        ],
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orangeAccent),
                      onPressed: () => openEditDialog(f),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => deleteFeature(id),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'feature_service.dart';

// class FeatureCrudWidget extends StatefulWidget {
//   final FeatureService featureService;

//   const FeatureCrudWidget({super.key, required this.featureService});

//   @override
//   State<FeatureCrudWidget> createState() => _FeatureCrudWidgetState();
// }

// class _FeatureCrudWidgetState extends State<FeatureCrudWidget> {
//   List<Map<String, dynamic>> features = [];
//   final _formKey = GlobalKey<FormState>();

//   // New feature
//   Uint8List? newImageBytes;
//   final TextEditingController newTitleController = TextEditingController();
//   final TextEditingController newDescController = TextEditingController();
//   List<Map<String, dynamic>> newFeatureSteps = [
//     {
//       "title": TextEditingController(),
//       "content": TextEditingController(),
//       "image": null,
//     },
//   ];

//   // Editing existing features
//   String? editingFeatureId;
//   Uint8List? editingImageBytes;
//   final TextEditingController editingTitleController = TextEditingController();
//   final TextEditingController editingDescController = TextEditingController();
//   Map<String, List<Map<String, dynamic>>> stepControllers = {};

//   @override
//   void initState() {
//     super.initState();
//     loadAllFeatures();
//   }

//   @override
//   void dispose() {
//     newTitleController.dispose();
//     newDescController.dispose();
//     for (var s in newFeatureSteps) {
//       s["title"]?.dispose();
//       s["content"]?.dispose();
//     }
//     editingTitleController.dispose();
//     editingDescController.dispose();
//     for (var controllers in stepControllers.values) {
//       for (var c in controllers) {
//         c["title"]?.dispose();
//         c["content"]?.dispose();
//       }
//     }
//     super.dispose();
//   }

//   /// Decode image safely (base64 or Uint8List), returns null if invalid
//   Uint8List? _decodeImage(dynamic imgData) {
//     if (imgData == null) return null;
//     try {
//       if (imgData is String) {
//         if (imgData.isEmpty) return null;
//         if (imgData.startsWith("http"))
//           return null; // URL will be handled separately
//         return base64Decode(imgData);
//       } else if (imgData is Uint8List) {
//         return imgData;
//       }
//     } catch (_) {}
//     return null;
//   }

//   Future<void> loadAllFeatures() async {
//     final data = await widget.featureService.loadFeatures();
//     setState(() {
//       features = data;
//       stepControllers.clear();

//       for (var f in features) {
//         final id = (f["_id"] ?? f["id"] ?? "").toString();
//         final rawSteps = f["steps"] ?? [];
//         List<Map<String, dynamic>> controllers = [];

//         if (rawSteps is List) {
//           for (var s in rawSteps) {
//             if (s is Map) {
//               controllers.add({
//                 "title": TextEditingController(text: s["title"] ?? ""),
//                 "content": TextEditingController(text: s["content"] ?? ""),
//                 "image": _decodeImage(s["image"]),
//               });
//             } else {
//               controllers.add({
//                 "title": TextEditingController(text: s.toString()),
//                 "content": TextEditingController(text: ""),
//                 "image": null,
//               });
//             }
//           }
//         }

//         if (controllers.isEmpty) {
//           controllers = [
//             {
//               "title": TextEditingController(),
//               "content": TextEditingController(),
//               "image": null,
//             },
//           ];
//         }

//         stepControllers[id] = controllers;
//       }
//     });
//   }

//   Future<void> pickNewImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final bytes = await picked.readAsBytes();
//       setState(() => newImageBytes = bytes);
//     }
//   }

//   Future<void> pickEditingImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final bytes = await picked.readAsBytes();
//       setState(() => editingImageBytes = bytes);
//     }
//   }

//   Future<void> addFeature() async {
//     if (newTitleController.text.trim().isEmpty ||
//         newDescController.text.trim().isEmpty ||
//         newImageBytes == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please provide title, description and image'),
//         ),
//       );
//       return;
//     }

//     final steps = newFeatureSteps.map((s) {
//       final Uint8List? img = s["image"];
//       return {
//         "title": s["title"]!.text.trim(),
//         "content": s["content"]!.text.trim(),
//         "image": img != null ? base64Encode(img) : null,
//       };
//     }).toList();

//     final success = await widget.featureService.saveFeature(
//       title: newTitleController.text.trim(),
//       description: newDescController.text.trim(),
//       imageBytes: newImageBytes,
//       steps: steps,
//     );

//     if (success) {
//       setState(() {
//         newImageBytes = null;
//         newTitleController.clear();
//         newDescController.clear();
//         for (var s in newFeatureSteps) {
//           s["title"]?.clear();
//           s["content"]?.clear();
//         }
//         newFeatureSteps = [
//           {
//             "title": TextEditingController(),
//             "content": TextEditingController(),
//             "image": null,
//           },
//         ];
//       });
//       await loadAllFeatures();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Failed to save feature')));
//     }
//   }

//   Future<void> deleteFeature(String id) async {
//     final ok = await widget.featureService.deleteFeature(id);
//     if (ok) {
//       await loadAllFeatures();
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text('Failed to delete feature')));
//     }
//   }

//   void openEditDialog(Map<String, dynamic> feature) {
//     final id = (feature["_id"] ?? feature["id"] ?? "").toString();
//     if (id.isEmpty) return;

//     editingFeatureId = id;
//     editingTitleController.text = feature["title"] ?? "";
//     editingDescController.text = feature["description"] ?? "";

//     editingImageBytes = _decodeImage(feature["image"]);

//     // Ensure controllers exist
//     stepControllers[id] ??= [
//       {
//         "title": TextEditingController(),
//         "content": TextEditingController(),
//         "image": null,
//       },
//     ];

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateDialog) {
//             void addStep() {
//               setStateDialog(() {
//                 stepControllers[id]!.add({
//                   "title": TextEditingController(),
//                   "content": TextEditingController(),
//                   "image": null,
//                 });
//               });
//             }

//             void removeStep(int index) {
//               if (stepControllers[id]!.length > 1) {
//                 stepControllers[id]![index]["title"]?.dispose();
//                 stepControllers[id]![index]["content"]?.dispose();
//                 setStateDialog(() => stepControllers[id]!.removeAt(index));
//               }
//             }

//             Future<void> pickStepImage(int index) async {
//               final p = await ImagePicker().pickImage(
//                 source: ImageSource.gallery,
//               );
//               if (p != null) {
//                 final b = await p.readAsBytes();
//                 setStateDialog(() => stepControllers[id]![index]["image"] = b);
//               }
//             }

//             return AlertDialog(
//               title: const Text("Edit Feature"),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: pickEditingImage,
//                       child: Container(
//                         height: 150,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[200],
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: editingImageBytes != null
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.memory(
//                                   editingImageBytes!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : (feature["image"] is String &&
//                                   (feature["image"] as String).startsWith(
//                                     "http",
//                                   ))
//                             ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.network(
//                                   feature["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             : const Center(child: Text("Tap to pick image")),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: editingTitleController,
//                       decoration: const InputDecoration(labelText: "Title"),
//                     ),
//                     const SizedBox(height: 8),
//                     TextField(
//                       controller: editingDescController,
//                       maxLines: 3,
//                       decoration: const InputDecoration(
//                         labelText: "Description",
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Steps",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     ...List.generate(stepControllers[id]!.length, (index) {
//                       final s = stepControllers[id]![index];
//                       final stepImg = s["image"] as Uint8List?;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             GestureDetector(
//                               onTap: () => pickStepImage(index),
//                               child: Container(
//                                 height: 140,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[200],
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: stepImg != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.memory(
//                                           stepImg,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : (feature["steps"] != null &&
//                                           feature["steps"] is List &&
//                                           (feature["steps"] as List).length >
//                                               index &&
//                                           (feature["steps"][index]["image"]
//                                               is String) &&
//                                           (feature["steps"][index]["image"]
//                                                   as String)
//                                               .startsWith("http"))
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.network(
//                                           feature["steps"][index]["image"],
//                                           fit: BoxFit.cover,
//                                         ),
//                                       )
//                                     : const Center(
//                                         child: Text("Tap to add step image"),
//                                       ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             TextField(
//                               controller: s["title"],
//                               decoration: InputDecoration(
//                                 labelText: "Step ${index + 1} Title",
//                               ),
//                             ),
//                             const SizedBox(height: 6),
//                             TextField(
//                               controller: s["content"],
//                               maxLines: 3,
//                               decoration: InputDecoration(
//                                 labelText: "Step ${index + 1} Content",
//                               ),
//                             ),
//                             Align(
//                               alignment: Alignment.centerRight,
//                               child: IconButton(
//                                 icon: const Icon(
//                                   Icons.remove_circle,
//                                   color: Colors.red,
//                                 ),
//                                 onPressed: () => removeStep(index),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: ElevatedButton.icon(
//                         onPressed: addStep,
//                         icon: const Icon(Icons.add),
//                         label: const Text("Add Step"),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text(
//                     "Cancel",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (editingFeatureId == null) return;

//                     final updatedSteps = stepControllers[editingFeatureId!]!
//                         .map(
//                           (s) => {
//                             "title": s["title"]?.text.trim() ?? "",
//                             "content": s["content"]?.text.trim() ?? "",
//                             "image": s["image"] != null
//                                 ? base64Encode(s["image"])
//                                 : null,
//                           },
//                         )
//                         .toList();

//                     final success = await widget.featureService.saveFeature(
//                       id: editingFeatureId,
//                       title: editingTitleController.text.trim(),
//                       description: editingDescController.text.trim(),
//                       imageBytes: editingImageBytes,
//                       steps: updatedSteps,
//                     );

//                     if (success) {
//                       Navigator.pop(context);
//                       await loadAllFeatures();
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Failed to update feature'),
//                         ),
//                       );
//                     }
//                   },
//                   child: const Text(
//                     "Save",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _newStepEditor(int index) {
//     final step = newFeatureSteps[index];
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               final pick = await ImagePicker().pickImage(
//                 source: ImageSource.gallery,
//               );
//               if (pick != null) {
//                 final bytes = await pick.readAsBytes();
//                 setState(() => newFeatureSteps[index]["image"] = bytes);
//               }
//             },
//             child: Container(
//               height: 140,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: step["image"] != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.memory(step["image"], fit: BoxFit.cover),
//                     )
//                   : const Center(child: Text("Tap to add step image")),
//             ),
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: step["title"],
//             decoration: InputDecoration(labelText: "Step ${index + 1} Title"),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             controller: step["content"],
//             maxLines: 3,
//             decoration: InputDecoration(labelText: "Step ${index + 1} Content"),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: IconButton(
//               icon: const Icon(Icons.remove_circle, color: Colors.red),
//               onPressed: () {
//                 if (newFeatureSteps.length > 1) {
//                   newFeatureSteps[index]["title"]?.dispose();
//                   newFeatureSteps[index]["content"]?.dispose();
//                   setState(() => newFeatureSteps.removeAt(index));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Add New Module",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           GestureDetector(
//             onTap: pickNewImage,
//             child: Container(
//               height: 180,
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: newImageBytes != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.memory(newImageBytes!, fit: BoxFit.cover),
//                     )
//                   : const Center(child: Text("Tap to pick an image")),
//             ),
//           ),
//           const SizedBox(height: 12),
//           TextField(
//             controller: newTitleController,
//             decoration: const InputDecoration(labelText: "Title"),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: newDescController,
//             maxLines: 3,
//             decoration: const InputDecoration(labelText: "Description"),
//           ),
//           const SizedBox(height: 12),
//           const Text("Steps", style: TextStyle(fontWeight: FontWeight.bold)),
//           const SizedBox(height: 8),
//           ...List.generate(
//             newFeatureSteps.length,
//             (index) => _newStepEditor(index),
//           ),
//           Align(
//             alignment: Alignment.centerLeft,
//             child: ElevatedButton.icon(
//               onPressed: () => setState(() {
//                 newFeatureSteps.add({
//                   "title": TextEditingController(),
//                   "content": TextEditingController(),
//                   "image": null,
//                 });
//               }),
//               icon: const Icon(Icons.add),
//               label: const Text(
//                 "Add Step",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 12),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: addFeature,
//               child: const Text(
//                 "Add Module",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           const SizedBox(height: 28),
//           const Text(
//             "Added Modules",
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 12),
//           ...features.map((f) {
//             final id = (f["_id"] ?? f["id"] ?? "").toString();
//             final mainImage = _decodeImage(f["image"]);
//             return Card(
//               margin: const EdgeInsets.only(bottom: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: ListTile(
//                 contentPadding: const EdgeInsets.all(12),
//                 leading: mainImage != null
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.memory(
//                           mainImage,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : (f["image"] is String &&
//                           (f["image"] as String).startsWith("http"))
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           f["image"],
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                     : Container(width: 60, height: 60, color: Colors.grey[300]),
//                 title: Text(
//                   f["title"] ?? "No Title",
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const SizedBox(height: 6),
//                     Text(
//                       f["description"] ?? "",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     if (f["steps"] != null &&
//                         f["steps"] is List &&
//                         (f["steps"] as List).isNotEmpty)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Steps preview:",
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           ...((f["steps"] as List).take(2).map((s) {
//                             final stepImg = _decodeImage(s["image"]);
//                             if (s is Map) {
//                               return Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   if (stepImg != null)
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                         right: 8.0,
//                                         top: 6.0,
//                                         bottom: 6.0,
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(6),
//                                         child: Image.memory(
//                                           stepImg,
//                                           width: 40,
//                                           height: 40,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     )
//                                   else if (s["image"] is String &&
//                                       (s["image"] as String).startsWith("http"))
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                         right: 8.0,
//                                         top: 6.0,
//                                         bottom: 6.0,
//                                       ),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.circular(6),
//                                         child: Image.network(
//                                           s["image"],
//                                           width: 40,
//                                           height: 40,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   Flexible(
//                                     child: Text(
//                                       s["title"] ?? "",
//                                       maxLines: 1,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             } else {
//                               return const SizedBox();
//                             }
//                           })),
//                         ],
//                       ),
//                   ],
//                 ),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => openEditDialog(f),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => deleteFeature(id),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
