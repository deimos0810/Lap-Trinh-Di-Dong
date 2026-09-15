import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  int currentSong = 0;
  bool isPlaying = false;
  bool isFavorite = false;
  double progress = 0.45;

  final List<Map<String, String>> songs = [
    {
      'artist': 'Kota The Friend',
      'title': 'Birdie',
      'image': 'assets/images/music/birdie_cover.jpg',
      'duration': '4:22',
    },
    {
      'artist': 'Lofi Girl',
      'title': 'Relaxing Evening',
      'image': 'assets/images/music/lofi_cover.jpg',
      'duration': '3:45',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final song = songs[currentSong];

    return Scaffold(
      backgroundColor: const Color(0xfff1f1f1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        centerTitle: true,
        title: const Text(
          'P L A Y L I S T',
          style: TextStyle(
            fontSize: 11,
            letterSpacing: 4,
            color: Colors.black54,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.black87),
              onPressed: () => showMessage('Playlist menu'),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 25),
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 7),
              ],
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 1.12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      song['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.orange.shade300,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.music_note,
                            size: 90,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song['artist']!, style: const TextStyle(fontSize: 12)),
                          Text(
                            song['title']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => isFavorite = !isFavorite),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '0:00',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                song['duration']!,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: Colors.green,
              inactiveTrackColor: Colors.white,
            ),
            child: Slider(
              value: progress,
              onChanged: (value) => setState(() => progress = value),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              controlButton(
                Icons.skip_previous,
                () => setState(() {
                  currentSong = currentSong == 0
                      ? songs.length - 1
                      : currentSong - 1;
                  progress = 0;
                }),
              ),
              controlButton(
                isPlaying ? Icons.pause : Icons.play_arrow,
                () => setState(() => isPlaying = !isPlaying),
                large: true,
              ),
              controlButton(
                Icons.skip_next,
                () => setState(() {
                  currentSong = (currentSong + 1) % songs.length;
                  progress = 0;
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget controlButton(
    IconData icon,
    VoidCallback onPressed, {
    bool large = false,
  }) {
    return Container(
      width: large ? 82 : 62,
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: large ? 30 : 22),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}