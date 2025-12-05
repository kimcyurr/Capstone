// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// // ---------------------------------------------------------
// // STEP DETAIL PAGE
// // ---------------------------------------------------------
// class StepDetailPage extends StatelessWidget {
//   final String title;
//   final String content;

//   const StepDetailPage({super.key, required this.title, required this.content});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Text(
//           content.isNotEmpty ? content : "No details provided for this step.",
//           style: const TextStyle(fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------
// // MODULE DETAIL PAGE
// // ---------------------------------------------------------
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

//     // STEPS (handle both strings and maps)
//     final List stepsRaw = feature["steps"] ?? [];
//     final List<Map<String, String>> steps = stepsRaw.map<Map<String, String>>((
//       s,
//     ) {
//       if (s is String) {
//         return {"title": s, "content": "No details provided."};
//       } else if (s is Map) {
//         return Map<String, String>.from(s);
//       } else {
//         return {"title": "Unknown Step", "content": "No details provided."};
//       }
//     }).toList();

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
//                 // HEADER IMAGE + BACK BUTTON + TITLE
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

//                 // ABOUT SECTION
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

//                 // STEPS SECTION
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
//                         ...List.generate(steps.length, (index) {
//                           final s = steps[index];
//                           return buildStepCard(
//                             "Step ${index + 1}",
//                             s["title"]!,
//                             s["content"]!,
//                           );
//                         })
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

//   // STEP CARD WIDGET
//   Widget buildStepCard(String step, String title, String content) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StepDetailPage(title: title, content: content),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               offset: const Offset(0, 2),
//               blurRadius: 4,
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 "$step:  $title",
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             const Icon(Icons.arrow_forward),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// // ---------------------------------------------------------
// // STEP DETAIL PAGE (Learning style)
// // ---------------------------------------------------------
// class StepDetailPage extends StatelessWidget {
//   final String title;
//   final String content;

//   const StepDetailPage({super.key, required this.title, required this.content});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               content,
//               style: const TextStyle(
//                 fontSize: 16,
//                 height: 1.7,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Optional: Add placeholder for images or videos
//             Container(
//               width: double.infinity,
//               height: 180,
//               decoration: BoxDecoration(
//                 color: Colors.green.shade100,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: const Center(
//                 child: Icon(
//                   Icons.play_circle_outline,
//                   color: Colors.white70,
//                   size: 50,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------
// // MODULE DETAIL PAGE (Learning style + fade-in animation)
// // ---------------------------------------------------------
// class ModuleDetailPage extends StatefulWidget {
//   final dynamic feature;

//   const ModuleDetailPage({super.key, required this.feature});

//   @override
//   State<ModuleDetailPage> createState() => _ModuleDetailPageState();
// }

// class _ModuleDetailPageState extends State<ModuleDetailPage>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = false; // For Read more / Read less
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final feature = widget.feature;

//     // DESCRIPTION
//     final String description =
//         feature["description"] ?? "No description provided.";

//     const int previewLength = 120;
//     final bool isLong = description.length > previewLength;
//     final String previewText = isLong
//         ? "${description.substring(0, previewLength)}..."
//         : description;

//     // STEPS (handle both strings and maps)
//     final List stepsRaw = feature["steps"] ?? [];
//     final List<Map<String, String>> steps = stepsRaw.map<Map<String, String>>((
//       s,
//     ) {
//       if (s is String) {
//         return {"title": s, "content": "No details provided."};
//       } else if (s is Map) {
//         return Map<String, String>.from(s);
//       } else {
//         return {"title": "Unknown Step", "content": "No details provided."};
//       }
//     }).toList();

//     // IMAGE HANDLING
//     Uint8List? imageBytes;
//     if (feature["image"] is String && feature["image"].isNotEmpty) {
//       imageBytes = base64Decode(feature["image"]);
//     } else if (feature["image"] is Uint8List) {
//       imageBytes = feature["image"];
//     }

//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // HEADER IMAGE + BACK BUTTON + TITLE
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                         bottom: Radius.circular(24),
//                       ),
//                       child: imageBytes != null
//                           ? Image.memory(
//                               imageBytes,
//                               width: double.infinity,
//                               height: 280,
//                               fit: BoxFit.cover,
//                             )
//                           : Container(
//                               width: double.infinity,
//                               height: 280,
//                               color: Colors.grey.shade300,
//                               child: const Icon(Icons.image, size: 50),
//                             ),
//                     ),
//                     Container(
//                       height: 280,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.vertical(
//                           bottom: Radius.circular(24),
//                         ),
//                         gradient: LinearGradient(
//                           colors: [
//                             // ignore: deprecated_member_use
//                             Colors.black.withOpacity(0.6),
//                             Colors.transparent,
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
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
//                     Positioned(
//                       bottom: 20,
//                       left: 20,
//                       child: Text(
//                         feature["title"] ?? "Module Title",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           shadows: [
//                             Shadow(
//                               blurRadius: 6,
//                               color: Colors.black38,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // ABOUT SECTION
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
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.green.shade50,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade200,
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               isExpanded ? description : previewText,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 height: 1.7,
//                                 color: Colors.grey.shade800,
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
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Text(
//                                     isExpanded ? "Read less" : "Read more...",
//                                     style: const TextStyle(
//                                       color: Colors.green,
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

//                 // STEPS SECTION
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
//                         ...List.generate(steps.length, (index) {
//                           final s = steps[index];
//                           return FadeTransition(
//                             opacity: _fadeAnimation,
//                             child: buildStepCard(
//                               "Step ${index + 1}",
//                               s["title"]!,
//                               s["content"]!,
//                             ),
//                           );
//                         })
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

//   // STEP CARD WIDGET (Learning app style)
//   Widget buildStepCard(String step, String title, String content) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StepDetailPage(title: title, content: content),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               offset: const Offset(0, 3),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.green.shade100,
//               child: Text(
//                 step.split(" ").last,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     content.length > 60
//                         ? content.substring(0, 60) + "..."
//                         : content,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                       height: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';

// // ---------------------------------------------------------
// // STEP DETAIL PAGE (now supports image)
// // ---------------------------------------------------------
// class StepDetailPage extends StatelessWidget {
//   final String title;
//   final String content;
//   final Uint8List? imageBytes;

//   const StepDetailPage({
//     super.key,
//     required this.title,
//     required this.content,
//     this.imageBytes,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Step Image
//             if (imageBytes != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16),
//                 child: Image.memory(
//                   imageBytes!,
//                   width: double.infinity,
//                   height: 200,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             const SizedBox(height: 16),

//             // Title
//             Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Content
//             Text(content, style: const TextStyle(fontSize: 16, height: 1.7)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ---------------------------------------------------------
// // MODULE DETAIL PAGE (Learning style + fade-in animation)
// // ---------------------------------------------------------
// class ModuleDetailPage extends StatefulWidget {
//   final dynamic feature;

//   const ModuleDetailPage({super.key, required this.feature});

//   @override
//   State<ModuleDetailPage> createState() => _ModuleDetailPageState();
// }

// class _ModuleDetailPageState extends State<ModuleDetailPage>
//     with SingleTickerProviderStateMixin {
//   bool isExpanded = false;
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );
//     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final feature = widget.feature;

//     // DESCRIPTION
//     final String description =
//         feature["description"] ?? "No description provided.";

//     const int previewLength = 120;
//     final bool isLong = description.length > previewLength;
//     final String previewText = isLong
//         ? "${description.substring(0, previewLength)}..."
//         : description;

//     // STEPS: supports text, map, and images
//     final List stepsRaw = feature["steps"] ?? [];
//     final List<Map<String, dynamic>> steps = stepsRaw.map<Map<String, dynamic>>(
//       (s) {
//         if (s is Map) {
//           return {
//             "title": s["title"] ?? "Untitled Step",
//             "content": s["content"] ?? "No details provided.",
//             "image": s["image"], // base64
//           };
//         }
//         return {
//           "title": s.toString(),
//           "content": "No details provided.",
//           "image": null,
//         };
//       },
//     ).toList();

//     // MAIN IMAGE
//     Uint8List? imageBytes;
//     if (feature["image"] is String && feature["image"].isNotEmpty) {
//       imageBytes = base64Decode(feature["image"]);
//     }

//     return Scaffold(
//       backgroundColor: Colors.green[50],
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // HEADER IMAGE + TITLE
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(
//                         bottom: Radius.circular(24),
//                       ),
//                       child: imageBytes != null
//                           ? Image.memory(
//                               imageBytes,
//                               width: double.infinity,
//                               height: 280,
//                               fit: BoxFit.cover,
//                             )
//                           : Container(
//                               width: double.infinity,
//                               height: 280,
//                               color: Colors.grey.shade300,
//                               child: const Icon(Icons.image, size: 50),
//                             ),
//                     ),
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
//                     Positioned(
//                       bottom: 20,
//                       left: 20,
//                       child: Text(
//                         feature["title"] ?? "Module Title",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           shadows: [
//                             Shadow(
//                               blurRadius: 6,
//                               color: Colors.black38,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 20),

//                 // ABOUT SECTION (background same as step)
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

//                       // Description Card (Updated design)
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.white, // Same as step card
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.shade300,
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               isExpanded ? description : previewText,
//                               style: const TextStyle(fontSize: 16, height: 1.7),
//                             ),
//                             if (isLong)
//                               GestureDetector(
//                                 onTap: () {
//                                   setState(() => isExpanded = !isExpanded);
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 8),
//                                   child: Text(
//                                     isExpanded ? "Read less" : "Read more...",
//                                     style: const TextStyle(
//                                       color: Colors.green,
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

//                 // STEPS
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

//                       ...List.generate(steps.length, (index) {
//                         final s = steps[index];

//                         Uint8List? stepImage;
//                         if (s["image"] is String && s["image"].isNotEmpty) {
//                           stepImage = base64Decode(s["image"]);
//                         }

//                         return FadeTransition(
//                           opacity: _fadeAnimation,
//                           child: buildStepCard(
//                             index + 1,
//                             s["title"],
//                             s["content"],
//                             stepImage,
//                           ),
//                         );
//                       }),
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

//   // STEP CARD (Now supports image)
//   Widget buildStepCard(
//     int step,
//     String title,
//     String content,
//     Uint8List? imageBytes,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => StepDetailPage(
//               title: title,
//               content: content,
//               imageBytes: imageBytes,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 14),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               offset: const Offset(0, 3),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Step Number
//             CircleAvatar(
//               radius: 18,
//               backgroundColor: Colors.green.shade100,
//               child: Text(
//                 "$step",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.green,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     content.length > 60
//                         ? content.substring(0, 60) + "..."
//                         : content,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade700,
//                       height: 1.5,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Step Image Thumbnail
//             if (imageBytes != null)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.memory(
//                   imageBytes,
//                   width: 50,
//                   height: 50,
//                   fit: BoxFit.cover,
//                 ),
//               ),

//             const SizedBox(width: 8),
//             const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// ---------------------------------------------------------
// STEP DETAIL PAGE (white background card for content)
// ---------------------------------------------------------
class StepDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final Uint8List? imageBytes;

  const StepDetailPage({
    super.key,
    required this.title,
    required this.content,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: Text(title), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Image
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  imageBytes!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),

            // Content with white background card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                content,
                style: const TextStyle(fontSize: 16, height: 1.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// MODULE DETAIL PAGE (step card clean, content not white)
// ---------------------------------------------------------
class ModuleDetailPage extends StatefulWidget {
  final dynamic feature;

  const ModuleDetailPage({super.key, required this.feature});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feature = widget.feature;

    // DESCRIPTION
    final String description =
        feature["description"] ?? "No description provided.";

    const int previewLength = 120;
    final bool isLong = description.length > previewLength;
    final String previewText = isLong
        ? "${description.substring(0, previewLength)}..."
        : description;

    // STEPS: supports text, map, and images
    final List stepsRaw = feature["steps"] ?? [];
    final List<Map<String, dynamic>> steps = stepsRaw.map<Map<String, dynamic>>(
      (s) {
        if (s is Map) {
          return {
            "title": s["title"] ?? "Untitled Step",
            "content": s["content"] ?? "No details provided.",
            "image": s["image"], // base64
          };
        }
        return {
          "title": s.toString(),
          "content": "No details provided.",
          "image": null,
        };
      },
    ).toList();

    // MAIN IMAGE
    Uint8List? imageBytes;
    if (feature["image"] is String && feature["image"].isNotEmpty) {
      imageBytes = base64Decode(feature["image"]);
    }

    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER IMAGE + TITLE
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                      child: imageBytes != null
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
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black38,
                              offset: Offset(0, 2),
                            ),
                          ],
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

                      // Description Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isExpanded ? description : previewText,
                              style: const TextStyle(fontSize: 16, height: 1.7),
                            ),
                            if (isLong)
                              GestureDetector(
                                onTap: () {
                                  setState(() => isExpanded = !isExpanded);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
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

                // STEPS
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
                          color: Color(0xFF2D5F2E),
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...List.generate(steps.length, (index) {
                        final s = steps[index];

                        Uint8List? stepImage;
                        if (s["image"] is String && s["image"].isNotEmpty) {
                          stepImage = base64Decode(s["image"]);
                        }

                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: buildStepCard(
                            index + 1,
                            s["title"],
                            s["content"],
                            stepImage,
                          ),
                        );
                      }),
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

  // STEP CARD (no extra background for content)
  Widget buildStepCard(
    int step,
    String title,
    String content,
    Uint8List? imageBytes,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StepDetailPage(
              title: title,
              content: content,
              imageBytes: imageBytes,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Number
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.green.shade100,
              child: Text(
                "$step",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D5F2E),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Step Image Thumbnail
            if (imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageBytes,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
