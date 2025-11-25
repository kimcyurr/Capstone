// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// class ModuleDetailPage extends StatefulWidget {
//   final dynamic feature;

//   const ModuleDetailPage({super.key, required this.feature});

//   @override
//   State<ModuleDetailPage> createState() => _ModuleDetailPageState();
// }

// class _ModuleDetailPageState extends State<ModuleDetailPage> {
//   bool isExpanded = false; // For Read more / Read less

//   @override
//   Widget build(BuildContext context) {
//     final feature = widget.feature;

//     // DESCRIPTION
//     final String description =
//         feature["description"] ?? "No description provided.";

//     const int previewLength = 120;
//     final bool isLong = description.length > previewLength;
//     final String previewText = isLong
//         ? description.substring(0, previewLength) + "..."
//         : description;

//     // STEPS
//     final List<String> steps = List<String>.from(feature["steps"] ?? []);

//     // IMAGE HANDLING
//     Uint8List? imageBytes;
//     if (feature["image"] is String && feature["image"].isNotEmpty) {
//       imageBytes = base64Decode(feature["image"]);
//     } else if (feature["image"] is Uint8List) {
//       imageBytes = feature["image"];
//     }

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ---------------------------------------------------------
//                 // HEADER IMAGE + BACK BUTTON + TITLE
//                 // ---------------------------------------------------------
//                 Stack(
//                   children: [
//                     imageBytes != null
//                         ? Image.memory(
//                             imageBytes,
//                             width: double.infinity,
//                             height: 280,
//                             fit: BoxFit.cover,
//                           )
//                         : Container(
//                             width: double.infinity,
//                             height: 280,
//                             color: Colors.grey.shade300,
//                             child: const Icon(Icons.image, size: 50),
//                           ),

//                     // Dark gradient overlay
//                     Container(
//                       height: 280,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.black.withOpacity(0.5),
//                             Colors.transparent,
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),

//                     // Back button
//                     Positioned(
//                       top: 50,
//                       left: 20,
//                       child: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: const CircleAvatar(
//                           backgroundColor: Colors.white,
//                           child: Icon(Icons.arrow_back, color: Colors.black),
//                         ),
//                       ),
//                     ),

//                     // Title
//                     Positioned(
//                       bottom: 20,
//                       left: 20,
//                       child: Text(
//                         feature["title"] ?? "Module Title",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // ---------------------------------------------------------
//                 // ABOUT SECTION WITH READ MORE
//                 // ---------------------------------------------------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "About",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF2D5F2E),
//                         ),
//                       ),
//                       const SizedBox(height: 10),

//                       Container(
//                         padding: const EdgeInsets.all(14),
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade200,
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Description with expansion
//                             Text(
//                               isExpanded ? description : previewText,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey.shade700,
//                               ),
//                             ),

//                             if (isLong)
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     isExpanded = !isExpanded;
//                                   });
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 6),
//                                   child: Text(
//                                     isExpanded ? "Read less" : "Read more...",
//                                     style: const TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 20),

//                 // ---------------------------------------------------------
//                 // STEPS SECTION
//                 // ---------------------------------------------------------
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Steps",
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.green,
//                         ),
//                       ),
//                       const SizedBox(height: 10),

//                       if (steps.isNotEmpty)
//                         ...List.generate(
//                           steps.length,
//                           (index) =>
//                               buildStepCard("Step ${index + 1}", steps[index]),
//                         )
//                       else
//                         const Text(
//                           "No steps added yet.",
//                           style: TextStyle(
//                             fontStyle: FontStyle.italic,
//                             color: Colors.grey,
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------------------------------------------------------
//   // STEP CARD WIDGET
//   // ---------------------------------------------------------
//   Widget buildStepCard(String step, String title) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade300,
//             offset: const Offset(0, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               "$step:  $title",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const Icon(Icons.play_arrow),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// ---------------------------------------------------------
// STEP DETAIL PAGE
// ---------------------------------------------------------
class StepDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const StepDetailPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          content.isNotEmpty ? content : "No details provided for this step.",
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// MODULE DETAIL PAGE
// ---------------------------------------------------------
class ModuleDetailPage extends StatefulWidget {
  final dynamic feature;

  const ModuleDetailPage({super.key, required this.feature});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  bool isExpanded = false; // For Read more / Read less

  @override
  Widget build(BuildContext context) {
    final feature = widget.feature;

    // DESCRIPTION
    final String description =
        feature["description"] ?? "No description provided.";

    const int previewLength = 120;
    final bool isLong = description.length > previewLength;
    final String previewText = isLong
        ? description.substring(0, previewLength) + "..."
        : description;

    // STEPS (handle both strings and maps)
    final List stepsRaw = feature["steps"] ?? [];
    final List<Map<String, String>> steps = stepsRaw.map<Map<String, String>>((
      s,
    ) {
      if (s is String) {
        return {"title": s, "content": "No details provided."};
      } else if (s is Map) {
        return Map<String, String>.from(s);
      } else {
        return {"title": "Unknown Step", "content": "No details provided."};
      }
    }).toList();

    // IMAGE HANDLING
    Uint8List? imageBytes;
    if (feature["image"] is String && feature["image"].isNotEmpty) {
      imageBytes = base64Decode(feature["image"]);
    } else if (feature["image"] is Uint8List) {
      imageBytes = feature["image"];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER IMAGE + BACK BUTTON + TITLE
                Stack(
                  children: [
                    imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            width: double.infinity,
                            height: 280,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: double.infinity,
                            height: 280,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image, size: 50),
                          ),
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.transparent,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Text(
                        feature["title"] ?? "Module Title",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ABOUT SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "About",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D5F2E),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded ? description : previewText,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            if (isLong)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    isExpanded ? "Read less" : "Read more...",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // STEPS SECTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Steps",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (steps.isNotEmpty)
                        ...List.generate(steps.length, (index) {
                          final s = steps[index];
                          return buildStepCard(
                            "Step ${index + 1}",
                            s["title"]!,
                            s["content"]!,
                          );
                        })
                      else
                        const Text(
                          "No steps added yet.",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // STEP CARD WIDGET
  Widget buildStepCard(String step, String title, String content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StepDetailPage(title: title, content: content),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "$step:  $title",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
