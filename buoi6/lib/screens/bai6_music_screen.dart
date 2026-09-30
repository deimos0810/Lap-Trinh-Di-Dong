import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class Bai6MusicScreen extends StatefulWidget {
  const Bai6MusicScreen({super.key});

  @override
  State<Bai6MusicScreen> createState() => _Bai6MusicScreenState();
}

class _Bai6MusicScreenState extends State<Bai6MusicScreen> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _rotationController;

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Map<String, String>> _playlist = [
    {'title': 'Sample Track 1', 'artist': 'Artist A', 'path': 'audios/sample1.mp3', 'duration': '03:15'},
    {'title': 'Sample Track 2', 'artist': 'Artist B', 'path': 'audios/sample2.mp3', 'duration': '02:45'},
    {'title': 'Sample Track 3', 'artist': 'Artist C', 'path': 'audios/sample3.mp3', 'duration': '04:10'},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
        _isPlaying ? _rotationController.repeat() : _rotationController.stop();
      }
    });

    _audioPlayer.onDurationChanged.listen((d) => setState(() => _duration = d));
    _audioPlayer.onPositionChanged.listen((p) => setState(() => _position = p));
    _audioPlayer.onPlayerComplete.listen((_) => _nextSong());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _playSong(int index) async {
    setState(() => _currentIndex = index);
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(_playlist[index]['path']!));
  }

  void _nextSong() => _playSong((_currentIndex + 1) % _playlist.length);
  void _prevSong() => _playSong((_currentIndex - 1 + _playlist.length) % _playlist.length);

  String _formatDuration(Duration d) {
    return "${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final song = _playlist[_currentIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFF2C003E), Color(0xFF121212)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(title: const Text('ALBUM / PLAYLIST'), backgroundColor: Colors.transparent, elevation: 0, centerTitle: true),
              Expanded(
                flex: 4,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _rotationController,
                    builder: (_, child) => Transform.rotate(angle: _rotationController.value * 2 * pi, child: child),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, border: Border.all(color: Colors.purpleAccent, width: 4)),
                      child: const Center(child: Icon(Icons.music_note, color: Colors.purpleAccent, size: 50)),
                    ),
                  ),
                ),
              ),
              Text(song['title']!, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(song['artist']!, style: const TextStyle(color: Colors.white60)),
              Slider(
                activeColor: Colors.purpleAccent,
                min: 0.0,
                max: _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0,
                value: _position.inSeconds.toDouble().clamp(0.0, _duration.inSeconds > 0 ? _duration.inSeconds.toDouble() : 1.0),
                onChanged: (val) => _audioPlayer.seek(Duration(seconds: val.toInt())),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(_formatDuration(_position)), Text(_formatDuration(_duration))],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(iconSize: 36, icon: const Icon(Icons.skip_previous), onPressed: _prevSong),
                  IconButton(
                    iconSize: 56,
                    icon: Icon(_isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, color: Colors.purpleAccent),
                    onPressed: () => _isPlaying ? _audioPlayer.pause() : _audioPlayer.play(AssetSource(song['path']!)),
                  ),
                  IconButton(iconSize: 36, icon: const Icon(Icons.skip_next), onPressed: _nextSong),
                ],
              ),
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: _playlist.length,
                  itemBuilder: (context, index) {
                    final item = _playlist[index];
                    final isSel = index == _currentIndex;
                    return ListTile(
                      title: Text(item['title']!, style: TextStyle(color: isSel ? Colors.purpleAccent : Colors.white)),
                      subtitle: Text(item['artist']!),
                      trailing: Text(item['duration']!),
                      onTap: () => _playSong(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}