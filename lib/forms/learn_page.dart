// import 'package:flutter/material.dart';

// class LearnPage extends StatelessWidget {
//   const LearnPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F5E8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF8F5E8),
//         elevation: 0,
//         title: const Text(
//           'Learn',
//           style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // 🔍 Search Bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 4,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: const Row(
//                 children: [
//                   Icon(Icons.search, color: Colors.black54),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: 'Search',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),

//             // 🌿 List of Cards
//             Expanded(
//               child: ListView(
//                 children: [
//                   _buildLearnCard(
//                     image:
//                         'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Hong_Kong_Okra_Aug_25_2012.JPG/1200px-Hong_Kong_Okra_Aug_25_2012.JPG',
//                     title: 'Okra',
//                     description:
//                         'Okra is a green, finger-shaped vegetable known for its edible pods that contain small seeds and a sticky juice used to thicken soups and stews.',
//                   ),
//                   _buildLearnCard(
//                     image:
//                         'data:image/jpeg;base64,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',
//                     title: 'Sibuyas',
//                     description:
//                         'Carl Linnaeus, from Latin cepa), also known as the bulb onion or common onion, is a vegetable that is the most widely cultivated species of the genus Allium.',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLearnCard({
//     required String image,
//     required String title,
//     required String description,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFE9E7D0),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.network(
//               image,
//               height: 150,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 12.0,
//               vertical: 8.0,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: const TextStyle(fontSize: 13, color: Colors.black54),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//skjfsijkfnsfnsf
import 'package:flutter/material.dart';

void main() {
  runApp(const AgSecureApp());
}

class AgSecureApp extends StatelessWidget {
  const AgSecureApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgSecure Learning',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LearnPage extends StatelessWidget {
  const LearnPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F5E8),
        elevation: 0,
        title: const Text(
          'Learn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.black54),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List of Cards
            Expanded(
              child: ListView(
                children: [
                  _buildLearnCard(
                    image:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Hong_Kong_Okra_Aug_25_2012.JPG/1200px-Hong_Kong_Okra_Aug_25_2012.JPG',
                    title: 'Okra',
                    description:
                        'Okra is a green, finger-shaped vegetable known for its edible pods that contain small seeds and a sticky juice used to thicken soups and stews.',
                  ),
                  _buildLearnCard(
                    image:
                        'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=500',
                    title: 'Sibuyas',
                    description:
                        'Carl Linnaeus, from Latin cepa), also known as the bulb onion or common onion, is a vegetable that is the most widely cultivated species of the genus Allium.',
                  ),
                  _buildLearnCard(
                    image:
                        'https://images.unsplash.com/photo-1599931468087-4ac7c8ac70d1?w=500',
                    title: 'Upo',
                    description:
                        'Calabash, or bottle gourd, is a tropical vine fruit.',
                  ),
                  _buildLearnCard(
                    image:
                        'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=500',
                    title: 'Black pepper',
                    description:
                        'A flowering vine cultivated for its fruit, used as a spice.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnCard({
    required String image,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E7D0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              image,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D7A4F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                children: [
                  // Welcome Text
                  const Text(
                    'Welcome to AgSecure Learning! 🌾',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E6B3F),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 4,
                    ),
                    child: const TextField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search here...',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Category Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: CategoryButton(
                      label: 'Fruits',
                      icon: '🍊',
                      color: const Color(0xFFD4964D),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CategoryButton(
                      label: 'Vegetables',
                      icon: '🥬',
                      color: const Color(0xFF2D7A4F),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LearnPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // All Link
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'All',
                    style: TextStyle(
                      color: Color(0xFF2D7A4F),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Items List
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    ItemCard(
                      image:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Hong_Kong_Okra_Aug_25_2012.JPG/1200px-Hong_Kong_Okra_Aug_25_2012.JPG',
                      title: 'Okra',
                      description:
                          "Okra, or lady's finger, is a green pod vegetable used to thicken soups and stews.",
                    ),
                    ItemCard(
                      image:
                          'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=500',
                      title: 'Sibuyas',
                      description:
                          'The onion is a commonly grown bulb vegetable from the Allium genus.',
                    ),
                    ItemCard(
                      image:
                          'https://images.unsplash.com/photo-1599931468087-4ac7c8ac70d1?w=500',
                      title: 'Upo',
                      description:
                          'Calabash, or bottle gourd, is a tropical vine fruit.',
                    ),
                    ItemCard(
                      image:
                          'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=500',
                      title: 'Black pepper',
                      description:
                          'A flowering vine cultivated for its fruit, used as a spice.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: const Color(0xFF2D7A4F),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LearnPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculate',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 35)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const ItemCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 85,
              height: 75,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 85,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'mongo_service.dart';

// class LearnPage extends StatefulWidget {
//   const LearnPage({super.key});

//   @override
//   State<LearnPage> createState() => _LearnPageState();
// }

// class _LearnPageState extends State<LearnPage> {
//   List<Map<String, dynamic>> lessons = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchLessons();
//   }

//   // Fetch lessons from MongoDB
//   Future<void> fetchLessons() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       final data = await MongoService.getLessons();
//       setState(() {
//         lessons = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       debugPrint('Error fetching lessons: $e');
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Failed to fetch lessons: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Learning Page'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: fetchLessons, // Refresh lessons from MongoDB
//             tooltip: 'Refresh',
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : lessons.isEmpty
//           ? const Center(child: Text('No lessons found'))
//           : ListView.builder(
//               itemCount: lessons.length,
//               itemBuilder: (context, index) {
//                 final lesson = lessons[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   child: ListTile(
//                     title: Text(lesson['title'] ?? 'No Title'),
//                     subtitle: Text(lesson['description'] ?? ''),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           // Example: Add a new lesson (optional)
//           await MongoService.addagescuredb(
//             'New Lesson',
//             'This lesson was added from the app.',
//           );
//           fetchLessons(); // Refresh after adding
//         },
//         child: const Icon(Icons.add),
//         tooltip: 'Add Lesson',
//       ),
//     );
//   }
// }
