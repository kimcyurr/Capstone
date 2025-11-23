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

//   @override
//   void initState() {
//     super.initState();
//     loadFeatures();
//   }

//   Future<void> loadFeatures() async {
//     final loaded = await widget.featureService.loadFeatures();
//     setState(() => features = loaded);
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
//     await widget.featureService.saveFeature(
//       selectedImageBytes!,
//       titleController.text,
//       descController.text,
//     );
//     setState(() {
//       selectedImageBytes = null;
//       titleController.clear();
//       descController.clear();
//     });
//     await loadFeatures();
//   }

//   Future<void> editFeature(Map<String, dynamic> feature) async {
//     Uint8List? newImageBytes;
//     TextEditingController updateTitle = TextEditingController(
//       text: feature["title"],
//     );
//     TextEditingController updateDesc = TextEditingController(
//       text: feature["description"],
//     );

//     await showDialog(
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
//               onPressed: () async {
//                 await widget.featureService.updateFeature(
//                   feature["id"],
//                   updateTitle.text,
//                   updateDesc.text,
//                   newImageBytes,
//                 );
//                 Navigator.pop(context);
//                 loadFeatures();
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> deleteFeature(String id) async {
//     await widget.featureService.deleteFeature(id);
//     loadFeatures();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Add New Feature",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         GestureDetector(
//           onTap: pickImage,
//           child: Container(
//             height: 180,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: selectedImageBytes == null
//                 ? const Center(child: Text("Tap to pick an image"))
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.memory(selectedImageBytes!, fit: BoxFit.cover),
//                   ),
//           ),
//         ),
//         const SizedBox(height: 12),
//         TextField(
//           controller: titleController,
//           decoration: const InputDecoration(
//             labelText: "Title",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 12),
//         TextField(
//           controller: descController,
//           maxLines: 3,
//           decoration: const InputDecoration(
//             labelText: "Description",
//             border: OutlineInputBorder(),
//           ),
//         ),
//         const SizedBox(height: 12),
//         ElevatedButton(
//           onPressed: addFeature,
//           child: const Text(
//             "Add module",
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//         const SizedBox(height: 25),
//         const Text(
//           "Added Modules",
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Column(
//           children: features.map((feature) {
//             return Card(
//               child: ListTile(
//                 leading: Image.memory(
//                   feature["image"],
//                   width: 60,
//                   fit: BoxFit.cover,
//                 ),
//                 title: Text(feature["title"]),
//                 subtitle: Text(feature["description"]),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.orange),
//                       onPressed: () => editFeature(feature),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete, color: Colors.red),
//                       onPressed: () => deleteFeature(feature["id"]),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }

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
  Uint8List? selectedImageBytes;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  List<Map<String, dynamic>> features = [];

  // Steps for existing features: featureId -> List of controllers
  Map<String, List<TextEditingController>> stepControllers = {};

  // Steps for new feature
  List<TextEditingController> newFeatureSteps = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    loadFeatures();
  }

  Future<void> loadFeatures() async {
    final loaded = await widget.featureService.loadFeatures();
    setState(() {
      features = loaded;

      // Initialize step controllers for existing features
      for (var f in loaded) {
        List steps = f['steps'] ?? [];
        stepControllers[f['id']] = steps
            .map((s) => TextEditingController(text: s))
            .toList();
        if (stepControllers[f['id']]!.isEmpty) {
          stepControllers[f['id']] = [TextEditingController()];
        }
      }
    });
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => selectedImageBytes = bytes);
    }
  }

  Future<void> addFeature() async {
    if (selectedImageBytes == null ||
        titleController.text.isEmpty ||
        descController.text.isEmpty)
      return;

    List<String> steps = newFeatureSteps
        .map((controller) => controller.text)
        .toList();
    print("Adding feature with steps: $steps");

    bool success = await widget.featureService.saveFeature(
      selectedImageBytes!,
      titleController.text,
      descController.text,
      steps: steps,
    );

    print("Feature added: $success");

    if (success) {
      setState(() {
        selectedImageBytes = null;
        titleController.clear();
        descController.clear();
        newFeatureSteps = [TextEditingController()];
      });
      await loadFeatures();
    }
  }

  Future<void> editFeature(Map<String, dynamic> feature) async {
    Uint8List? newImageBytes;
    TextEditingController updateTitle = TextEditingController(
      text: feature["title"],
    );
    TextEditingController updateDesc = TextEditingController(
      text: feature["description"],
    );

    stepControllers[feature['id']] ??= [TextEditingController()];

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            void addStep() {
              setStateDialog(() {
                stepControllers[feature['id']]!.add(TextEditingController());
              });
            }

            void removeStep(int index) {
              setStateDialog(() {
                if (stepControllers[feature['id']]!.length > 1) {
                  stepControllers[feature['id']]!.removeAt(index);
                }
              });
            }

            return AlertDialog(
              title: const Text("Edit Feature"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picked = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          final bytes = await picked.readAsBytes();
                          setStateDialog(() => newImageBytes = bytes);
                        }
                      },
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: newImageBytes != null
                            ? Image.memory(newImageBytes!, fit: BoxFit.cover)
                            : Image.memory(feature["image"], fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: updateTitle,
                      decoration: const InputDecoration(labelText: "Title"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: updateDesc,
                      decoration: const InputDecoration(
                        labelText: "Description",
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      "Steps:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(
                      stepControllers[feature['id']]!.length,
                      (index) => Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  stepControllers[feature['id']]![index],
                              decoration: InputDecoration(
                                labelText: "Step ${index + 1}",
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                            onPressed: () => removeStep(index),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: addStep,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Step"),
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
                    List<String> updatedSteps = stepControllers[feature['id']]!
                        .map((c) => c.text)
                        .toList();
                    print(
                      "Updating feature ${feature['id']} with steps: $updatedSteps",
                    );

                    bool success = await widget.featureService.updateFeature(
                      feature['id'],
                      updateTitle.text,
                      updateDesc.text,
                      newImageBytes,
                      steps: updatedSteps,
                    );

                    print("Feature updated: $success");

                    if (success) {
                      Navigator.pop(context);
                      await loadFeatures();
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

  Future<void> deleteFeature(String id) async {
    print("Deleting feature $id");
    bool success = await widget.featureService.deleteFeature(id);
    print("Deleted: $success");
    if (success) loadFeatures();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Feature",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: pickImage,
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: selectedImageBytes == null
                  ? const Center(child: Text("Tap to pick an image"))
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        selectedImageBytes!,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Title",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Description",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Steps", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(
            newFeatureSteps.length,
            (index) => Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newFeatureSteps[index],
                    decoration: InputDecoration(labelText: "Step ${index + 1}"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () {
                    if (newFeatureSteps.length > 1) {
                      setState(() => newFeatureSteps.removeAt(index));
                    }
                  },
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                setState(() => newFeatureSteps.add(TextEditingController())),
            icon: const Icon(Icons.add),
            label: const Text("Add Step"),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: addFeature,
            child: const Text(
              "Add module",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "Added Modules",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: features.map((feature) {
              return Card(
                child: ListTile(
                  leading: feature["image"] != null
                      ? Image.memory(
                          feature["image"],
                          width: 60,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(feature["title"]),
                  subtitle: Text(feature["description"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => editFeature(feature),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteFeature(feature["id"]),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
