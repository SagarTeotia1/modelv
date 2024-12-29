import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // To remove the debug banner
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Model Viewer'),
        ),
        body: const Center(
          child: ModelViewer(
            backgroundColor: Color(0xFFEEEEEE), // Simplified color format
            src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
            alt: 'A 3D model of an astronaut',
            ar: true, // Enables AR functionality
            autoRotate: true, // Auto rotate the model
            iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
            disableZoom: true, // Disable zoom functionality
          ),
        ),
      ),
    );
  }
}
