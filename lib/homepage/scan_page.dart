// WEB IMPORTS
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  CameraController? mobileCamera;
  bool isMobileReady = false;

  html.VideoElement? webCamera;
  bool isWebReady = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      html.VideoElement videoElement = html.VideoElement();
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'webcam',
        (int viewId) => videoElement,
      );
      webCamera = videoElement;
      initWebCamera();
    } else {
      initMobileCamera();
    }

    // Glow scan animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 260).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> initMobileCamera() async {
    try {
      final cameras = await availableCameras();
      mobileCamera = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await mobileCamera!.initialize();
      setState(() => isMobileReady = true);
    } catch (e) {
      print("Mobile camera error: $e");
    }
  }

  Future<void> initWebCamera() async {
    final stream = await html.window.navigator.mediaDevices?.getUserMedia({
      'video': true,
    });
    if (stream != null) {
      webCamera!
        ..srcObject = stream
        ..autoplay = true
        ..muted = true;
      setState(() => isWebReady = true);
    }
  }

  @override
  void dispose() {
    mobileCamera?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // CAMERA VIEW
          kIsWeb ? buildWebCamera() : buildMobileCamera(),

          // Dark top gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
            ),
          ),

          // MAIN UI
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),

                  const SizedBox(height: 10),

                  // Title
                  const Text(
                    "Auto scan",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Subtitle
                  const Text(
                    "Please fill the camera with the insect",
                    style: TextStyle(color: Colors.white),
                  ),

                  const Spacer(),

                  // Scan frame with glow animation
                  Center(
                    child: SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        children: [
                          Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.9),
                                width: 4,
                              ),
                            ),
                          ),
                          // Glow animation line
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Positioned(
                                top: _animation.value,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.withOpacity(0),
                                        Colors.greenAccent.withOpacity(0.8),
                                        Colors.green.withOpacity(0),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom info panel
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Detected Pest: Armyworm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Description: A caterpillar pest that feeds on corn leaves.",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Suggested Control: Use Bacillus thuringiensis (Bt) or pheromone traps. Avoid excessive pesticide use.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobileCamera() {
    if (!isMobileReady) return const Center(child: CircularProgressIndicator());
    return CameraPreview(mobileCamera!);
  }

  Widget buildWebCamera() {
    if (!isWebReady) return const Center(child: CircularProgressIndicator());
    return const HtmlElementView(viewType: 'webcam');
  }
}
