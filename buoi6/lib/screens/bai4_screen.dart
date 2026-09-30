import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class Bai4Screen extends StatefulWidget {
  const Bai4Screen({super.key});

  @override
  State<Bai4Screen> createState() => _Bai4ScreenState();
}

class _Bai4ScreenState extends State<Bai4Screen> {
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickVideo(ImageSource source) async {
    if (source == ImageSource.camera) {
      await Permission.camera.request();
      await Permission.microphone.request();
    } else {
      await Permission.videos.request();
      await Permission.photos.request();
    }

    final XFile? pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      await _videoController?.dispose();
      final controller = VideoPlayerController.file(File(pickedFile.path));
      await controller.initialize();
      setState(() => _videoController = controller);
      _videoController!.play();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Recorder & Playback')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : Container(
                    height: 220,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: Text('Chưa có video nào được chọn.')),
                  ),
            const SizedBox(height: 16),
            if (_videoController != null && _videoController!.value.isInitialized)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _videoController!.value.isPlaying ? _videoController!.pause() : _videoController!.play();
                  });
                },
                icon: Icon(_videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(_videoController!.value.isPlaying ? 'Tạm dừng' : 'Phát'),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _pickVideo(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Chọn video từ Gallery'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => _pickVideo(ImageSource.camera),
              icon: const Icon(Icons.videocam),
              label: const Text('Quay video từ Camera'),
            ),
          ],
        ),
      ),
    );
  }
}