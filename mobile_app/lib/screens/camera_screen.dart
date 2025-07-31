import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../providers/plant_provider.dart';
import '../utils/theme.dart';
import 'results_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error initializing camera: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final XFile image = await _controller!.takePicture();
      
      if (mounted) {
        final plantProvider = Provider.of<PlantProvider>(context, listen: false);
        await plantProvider.analyzePlant(File(image.path));
        
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResultsScreen(),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isCapturing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error capturing image: $e'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }

  void _toggleFlash() {
    if (_controller != null && _controller!.value.isInitialized) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      _controller!.setFlashMode(
        _isFlashOn ? FlashMode.torch : FlashMode.off,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 20),
              Text(
                'Initializing camera...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          CameraPreview(_controller!),
          
          // Overlay UI
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: Column(
        children: [
          // Top Bar
          _buildTopBar(),
          
          // Center Frame
          Expanded(
            child: _buildCenterFrame(),
          ),
          
          // Bottom Controls
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          
          // Flash Toggle
          GestureDetector(
            onTap: _toggleFlash,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterFrame() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primaryGreen,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            // Corner Indicators
            Positioned(
              top: 10,
              left: 10,
              child: _buildCornerIndicator(),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: _buildCornerIndicator(),
            ),
            Positioned(
              bottom: 10,
              left: 10,
              child: _buildCornerIndicator(),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: _buildCornerIndicator(),
            ),
            
            // Center Text
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Position plant within frame',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerIndicator() {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Gallery Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.photo_library,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          
          // Capture Button
          GestureDetector(
            onTap: _isCapturing ? null : _captureImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isCapturing 
                    ? AppTheme.textSecondary 
                    : AppTheme.primaryGreen,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: _isCapturing
                  ? CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 36,
                    ),
            ),
          ),
          
          // Settings Button
          GestureDetector(
            onTap: () {
              // TODO: Add camera settings
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}