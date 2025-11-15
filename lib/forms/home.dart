// //
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';

// class HomePage extends StatefulWidget {
//   final String userName; // 👈 username from Firestore
//   const HomePage({super.key, required this.userName});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String cityName = "Oroquieta City";
//   String weatherDescription = "";
//   double temperature = 0;
//   bool isLoadingWeather = true;

//   final TextEditingController searchController = TextEditingController();
//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();
//     fetchWeather();
//   }

//   Future<void> fetchWeather() async {
//     const apiKey = "a7bb72460433159aee012cbda57cdfd8"; // Replace with your key
//     final url = Uri.parse(
//       "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
//     );

//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           temperature = data['main']['temp'];
//           weatherDescription = data['weather'][0]['description'] ?? "Unknown";
//           isLoadingWeather = false;
//         });
//       } else {
//         setState(() => isLoadingWeather = false);
//         debugPrint('Weather API error: ${response.statusCode}');
//       }
//     } catch (e) {
//       setState(() => isLoadingWeather = false);
//       debugPrint("Weather fetch error: $e");
//     }
//   }

//   Stream<QuerySnapshot> getTutorials() {
//     return FirebaseFirestore.instance.collection('tutorials').snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F5E8),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Greeting Section — now uses username!
//               Text(
//                 "Welcome, ${widget.userName}!",
//                 style: const TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF2D5F2E),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 "${DateTime.now().toLocal().toString().split(' ')[0]}",
//                 style: const TextStyle(color: Colors.black54),
//               ),
//               const SizedBox(height: 20),

//               // Search Bar
//               TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   hintText: "Search here...",
//                   prefixIcon: const Icon(Icons.search),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                 ),
//                 onChanged: (value) => setState(() => searchQuery = value),
//               ),

//               const SizedBox(height: 20),

//               // Weather Card
//               Container(
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: isLoadingWeather
//                     ? const Center(child: CircularProgressIndicator())
//                     : Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 cityName,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF2D5F2E),
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 "${temperature.toStringAsFixed(1)}°C | ${weatherDescription.isNotEmpty ? '${weatherDescription[0].toUpperCase()}${weatherDescription.substring(1)}' : 'No data'}",
//                                 style: const TextStyle(fontSize: 16),
//                               ),
//                             ],
//                           ),
//                           const Icon(
//                             Icons.cloud,
//                             color: Colors.blueAccent,
//                             size: 50,
//                           ),
//                         ],
//                       ),
//               ),

//               const SizedBox(height: 25),

//               // Tutorial Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: const [
//                   Text(
//                     "Tutorial",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     "View all",
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),

//               // Firestore Tutorials
//               StreamBuilder<QuerySnapshot>(
//                 stream: getTutorials(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text("No tutorials available."));
//                   }

//                   final docs = snapshot.data!.docs.where((doc) {
//                     final title = doc['title'].toString().toLowerCase();
//                     return title.contains(searchQuery.toLowerCase());
//                   }).toList();

//                   if (docs.isEmpty) {
//                     return const Center(child: Text("No results found."));
//                   }

//                   return GridView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: docs.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           mainAxisSpacing: 10,
//                           crossAxisSpacing: 10,
//                           childAspectRatio: 0.9,
//                         ),
//                     itemBuilder: (context, index) {
//                       final data =
//                           docs[index].data() as Map<String, dynamic>? ?? {};
//                       final imageUrl = data['image'] ?? '';
//                       final title = data['title'] ?? 'Untitled';
//                       final desc = data['description'] ?? '';

//                       return Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             ClipRRect(
//                               borderRadius: const BorderRadius.vertical(
//                                 top: Radius.circular(20),
//                               ),
//                               child: Image.network(
//                                 imageUrl,
//                                 height: 100,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) =>
//                                     Container(
//                                       color: Colors.grey.shade300,
//                                       height: 100,
//                                       child: const Center(
//                                         child: Icon(
//                                           Icons.broken_image,
//                                           color: Colors.grey,
//                                         ),
//                                       ),
//                                     ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     title,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     desc,
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: const TextStyle(fontSize: 12),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'learn_page.dart';

class HomePage extends StatefulWidget {
  final String userName;
  const HomePage({super.key, required this.userName});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String cityName = "Oroquieta City";
  String weatherDescription = "";
  double temperature = 0;
  int humidity = 0;
  double windSpeed = 0;
  double precipitation = 0;
  bool isLoadingWeather = true;

  int selectedIndex = 0; // Track selected nav button

  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    const apiKey = "a7bb72460433159aee012cbda57cdfd8";
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          temperature = data['main']['temp'];
          weatherDescription = data['weather'][0]['description'] ?? "Unknown";
          humidity = data['main']['humidity'] ?? 0;
          windSpeed = (data['wind']['speed'] ?? 0).toDouble();
          precipitation = (data['rain']?['1h'] ?? 0).toDouble();
          isLoadingWeather = false;
        });
      } else {
        setState(() => isLoadingWeather = false);
      }
    } catch (e) {
      setState(() => isLoadingWeather = false);
    }
  }

  Stream<QuerySnapshot> getTutorials() {
    return FirebaseFirestore.instance.collection('tutorials').snapshots();
  }

  // Handle navigation tap
  void onNavTap(int index) {
    setState(() {
      selectedIndex = index;
    });

    // Navigate to LearnPage when Learn button is tapped
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LearnPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              iconPath: "image/image/house-solid-full.png",
              label: "Home",
              active: selectedIndex == 0,
              onTap: () => onNavTap(0),
            ),
            _NavItem(
              iconPath: "image/image/book-open-solid-full.png",
              label: "Learn",
              active: selectedIndex == 1,
              onTap: () => onNavTap(1),
            ),
            _NavItem(
              iconPath: "image/image/camera-solid-full.png",
              label: "Scan",
              active: selectedIndex == 2,
              onTap: () => onNavTap(2),
            ),
            _NavItem(
              iconPath: "image/image/calculator-solid-full.png",
              label: "Calculate",
              active: selectedIndex == 3,
              onTap: () => onNavTap(3),
            ),
            _NavItem(
              iconPath: "image/image/user-solid-full.png",
              label: "Profile",
              active: selectedIndex == 4,
              onTap: () => onNavTap(4),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 80,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1A6E34),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, ${widget.userName}",
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Wednesday, 11 Nov 2025",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2E8B57),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: (v) => setState(() => searchQuery = v),
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: "Search here...",
                              hintStyle: TextStyle(color: Colors.white70),
                              icon: Icon(Icons.search, color: Colors.white),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: -90,
                    child: _buildWeatherCard(),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Tutorial",
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "View all",
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    StreamBuilder<QuerySnapshot>(
                      stream: getTutorials(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final docs = snapshot.data!.docs.where((doc) {
                          return doc['title'].toString().toLowerCase().contains(
                            searchQuery.toLowerCase(),
                          );
                        }).toList();
                        if (docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text("No results found."),
                          );
                        }
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: docs.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            return _TutorialCard(data: data);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: isLoadingWeather
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              cityName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${temperature.toStringAsFixed(1)}°C | $weatherDescription",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.cloud_outlined,
                      size: 48,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _weatherInfoItem(Icons.opacity, "Humidity", "$humidity%"),
                    _weatherInfoItem(
                      Icons.grain,
                      "Precip",
                      "$precipitation mm",
                    ),
                    _weatherInfoItem(Icons.air, "Wind", "$windSpeed m/s"),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _weatherInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

// ----------------- NAV ITEM -----------------
class _NavItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({
    required this.iconPath,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            height: 26,
            color: active ? const Color(0xFF1A6E34) : Colors.grey,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: active ? const Color(0xFF1A6E34) : Colors.grey,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- TUTORIAL CARD -----------------
class _TutorialCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TutorialCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              data['image'] ?? '',
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              data['title'] ?? "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data['description'] ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
