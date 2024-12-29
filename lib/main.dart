import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:model_viewer_plus/model_viewer_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Model Viewer with Interactive Circular UI'),
        ),
        body: Column(
        
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: ModelViewer(
                          backgroundColor: const Color(0xFFEEEEEE),
                          src: 'assets/images/talking_male_character_with_pointing_gestures.glb',
                          alt: 'A 3D model of a character',
                          ar: true,
                          autoRotate: false,
                          iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                          disableZoom: false,
                          cameraOrbit: '5x',
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              height: 200,
              width: 200,
              child: AnimatedButton(
                pauseIcon: Icon(Icons.mic, color: Colors.black, size: 90),
                playIcon: Icon(Icons.mic, color: Colors.black, size: 90),
                onPressed: null,
              ),
            ),
            const SizedBox(height: 16), // Add spacing below the button
          ],
        ),
      ),
    );
  }
}

class AnimatedButton extends StatefulWidget {
  final Icon playIcon;
  final Icon pauseIcon;
  final VoidCallback? onPressed;

  const AnimatedButton({
    Key? key,
    required this.onPressed,
    this.playIcon = const Icon(Icons.play_arrow),
    this.pauseIcon = const Icon(Icons.pause),
  }) : super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  bool isPlaying = false;

  late final AnimationController _rotationController;
  late final AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.6; // Reduce the scale for smaller blobs

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.6; // Adjust scale for smaller size

  @override
  void initState() {
    _rotationController = AnimationController(vsync: this, duration: _kRotationDuration)
      ..addListener(() => setState(_updateRotation))
      ..repeat();

    _scaleController = AnimationController(vsync: this, duration: _kToggleDuration)
      ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    setState(() => isPlaying = !isPlaying);

    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }

    if (widget.onPressed != null) widget.onPressed!();
  }

  Widget _buildIcon() {
    return IconButton(
      icon: isPlaying ? widget.pauseIcon : widget.playIcon,
      onPressed: _onToggle,
      iconSize: 24, // Reduce icon size
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40), // Adjust the minimum size of the button
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: const Color(0xff0092ff), scale: _scale, rotation: _rotation),
            Blob(color: const Color(0xff4ac7b7), scale: _scale, rotation: _rotation * 2 - 30),
            Blob(color: const Color(0xffa4a6f6), scale: _scale, rotation: _rotation * 3 - 45),
          ],
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: AnimatedSwitcher(
              duration: _kToggleDuration,
              child: _buildIcon(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({
    Key? key,
    required this.color,
    this.rotation = 0,
    this.scale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
