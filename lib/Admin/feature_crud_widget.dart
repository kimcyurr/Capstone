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
//   Uint8List? selectedImageBytes;
//   final TextEditingController titleController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   List<Map<String, dynamic>> features = [];

//   Map<String, List<TextEditingController>> stepControllers = {};
//   List<TextEditingController> newFeatureSteps = [TextEditingController()];

//   @override
//   void initState() {
//     super.initState();
//     loadFeatures();
//   }

//   Future<void> loadFeatures() async {
//     final loaded = await widget.featureService.loadFeatures();
//     setState(() {
//       features = loaded;

//       for (var f in loaded) {
//         List steps = f['steps'] ?? [];
//         stepControllers[f['id']] = steps
//             .map((s) => TextEditingController(text: s))
//             .toList();

//         if (stepControllers[f['id']]!.isEmpty) {
//           stepControllers[f['id']] = [TextEditingController()];
//         }
//       }
//     });
//   }

//   Future<void> pickImage() async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       final bytes = await picked.readAsBytes();
//       setState(() => selectedImageBytes = bytes);
//     }
//   }

//   Future<void> addFeature() async {
//     if (selectedImageBytes == null ||
//         titleController.text.isEmpty ||
//         descController.text.isEmpty)
//       return;

//     List<String> steps = newFeatureSteps.map((c) => c.text).toList();

//     bool success = await widget.featureService.saveFeature(
//       selectedImageBytes!,
//       titleController.text,
//       descController.text,
//       steps: steps,
//     );

//     if (success) {
//       setState(() {
//         selectedImageBytes = null;
//         titleController.clear();
//         descController.clear();
//         newFeatureSteps = [TextEditingController()];
//       });
//       await loadFeatures();
//     }
//   }

//   Future<void> editFeature(Map<String, dynamic> feature) async {
//     Uint8List? newImageBytes;

//     TextEditingController updateTitle = TextEditingController(
//       text: feature["title"],
//     );
//     TextEditingController updateDesc = TextEditingController(
//       text: feature["description"],
//     );

//     stepControllers[feature['id']] ??= [TextEditingController()];

//     await showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateDialog) {
//             void addStep() {
//               setStateDialog(() {
//                 stepControllers[feature['id']]!.add(TextEditingController());
//               });
//             }

//             void removeStep(int index) {
//               if (stepControllers[feature['id']]!.length > 1) {
//                 setStateDialog(() {
//                   stepControllers[feature['id']]!.removeAt(index);
//                 });
//               }
//             }

//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: const Text(
//                 "Edit Feature",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               content: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     GestureDetector(
//                       onTap: () async {
//                         final picked = await ImagePicker().pickImage(
//                           source: ImageSource.gallery,
//                         );
//                         if (picked != null) {
//                           final bytes = await picked.readAsBytes();
//                           setStateDialog(() => newImageBytes = bytes);
//                         }
//                       },
//                       child: Container(
//                         height: 150,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(14),
//                           color: Colors.grey[200],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(14),
//                           child: newImageBytes != null
//                               ? Image.memory(newImageBytes!, fit: BoxFit.cover)
//                               : Image.memory(
//                                   feature["image"],
//                                   fit: BoxFit.cover,
//                                 ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: updateTitle,
//                       decoration: InputDecoration(
//                         labelText: "Title",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     TextField(
//                       controller: updateDesc,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         labelText: "Description",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     const Text(
//                       "Steps",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     ...List.generate(
//                       stepControllers[feature['id']]!.length,
//                       (index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller:
//                                     stepControllers[feature['id']]![index],
//                                 decoration: InputDecoration(
//                                   labelText: "Step ${index + 1}",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.remove_circle,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () => removeStep(index),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: addStep,
//                       icon: const Icon(Icons.add),
//                       label: const Text(
//                         "Add Step",
//                         style: TextStyle(color: Colors.white),
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
//                     List<String> updatedSteps = stepControllers[feature['id']]!
//                         .map((c) => c.text)
//                         .toList();

//                     bool success = await widget.featureService.updateFeature(
//                       feature['id'],
//                       updateTitle.text,
//                       updateDesc.text,
//                       newImageBytes,
//                       steps: updatedSteps,
//                     );

//                     if (success) {
//                       Navigator.pop(context);
//                       await loadFeatures();
//                     }
//                   },
//                   child: const Text(
//                     "Save",
//                     // style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> deleteFeature(String id) async {
//     bool success = await widget.featureService.deleteFeature(id);
//     if (success) loadFeatures();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // -------------------------
//             // HEADER
//             // -------------------------
//             const Text(
//               "Add New Feature",
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             // -------------------------
//             // ADD FEATURE CARD
//             // -------------------------
//             Card(
//               elevation: 3,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   children: [
//                     // IMAGE PICKER
//                     GestureDetector(
//                       onTap: pickImage,
//                       child: Container(
//                         height: 180,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade300),
//                         ),
//                         child: selectedImageBytes == null
//                             ? const Center(
//                                 child: Text(
//                                   "Tap to pick an image",
//                                   style: TextStyle(color: Colors.black54),
//                                 ),
//                               )
//                             : ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.memory(
//                                   selectedImageBytes!,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Title
//                     TextField(
//                       controller: titleController,
//                       decoration: InputDecoration(
//                         labelText: "Title",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // Description
//                     TextField(
//                       controller: descController,
//                       maxLines: 3,
//                       decoration: InputDecoration(
//                         labelText: "Description",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Steps",
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 8),

//                     // Steps UI
//                     ...List.generate(
//                       newFeatureSteps.length,
//                       (index) => Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: TextField(
//                                 controller: newFeatureSteps[index],
//                                 decoration: InputDecoration(
//                                   labelText: "Step ${index + 1}",
//                                   border: OutlineInputBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(
//                                 Icons.remove_circle,
//                                 color: Colors.red,
//                               ),
//                               onPressed: () {
//                                 if (newFeatureSteps.length > 1) {
//                                   setState(
//                                     () => newFeatureSteps.removeAt(index),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: ElevatedButton.icon(
//                         onPressed: () => setState(
//                           () => newFeatureSteps.add(TextEditingController()),
//                         ),
//                         icon: const Icon(Icons.add),
//                         label: const Text(
//                           "Add Step",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // ADD MODULE BUTTON
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 14),
//                           backgroundColor: const Color(0xFF2D5F2E),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         onPressed: addFeature,
//                         child: const Text(
//                           "Add Module",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             const SizedBox(height: 35),

//             // -------------------------
//             // ADDED MODULES
//             // -------------------------
//             const Text(
//               "Added Modules",
//               style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),

//             Column(
//               children: features.map((feature) {
//                 return Card(
//                   elevation: 2,
//                   margin: const EdgeInsets.only(bottom: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(14),
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: feature["image"] != null
//                           ? Image.memory(
//                               feature["image"],
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                             )
//                           : Container(
//                               width: 60,
//                               height: 60,
//                               color: Colors.grey[300],
//                             ),
//                     ),
//                     title: Text(
//                       feature["title"],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16,
//                       ),
//                     ),
//                     subtitle: Text(
//                       feature["description"],
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(
//                             Icons.edit,
//                             color: Colors.orangeAccent,
//                           ),
//                           onPressed: () => editFeature(feature),
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
// }

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
                        label: const Text("Add Step"),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
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
                  child: const Text("Save"),
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
              label: const Text("Add Step"),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: addFeature,
              child: const Text("Add Module"),
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
