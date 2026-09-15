import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  int selectedNav = 0;
  String selectedMood = 'Well';
  String keyword = '';

  final List<Map<String, String>> moods = [
    {'emoji': '😣', 'name': 'Bad'},
    {'emoji': '🙂', 'name': 'Fine'},
    {'emoji': '😄', 'name': 'Well'},
    {'emoji': '🥳', 'name': 'Excellent'},
  ];

  final List<Map<String, dynamic>> exercises = [
    {
      'title': 'Speaking Skills',
      'count': '16 Exercises',
      'icon': Icons.favorite,
      'color': Color(0xffff9418),
    },
    {
      'title': 'Reading Skills',
      'count': '8 Exercises',
      'icon': Icons.person,
      'color': Color(0xff43b957),
    },
    {
      'title': 'Writing Skills',
      'count': '20 Exercises',
      'icon': Icons.star,
      'color': Color(0xffe91e63),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredExercises = exercises.where((exercise) {
      return exercise['title']
          .toString()
          .toLowerCase()
          .contains(keyword.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff4f4f4),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Exercises',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => showMessage('Exercise options'),
                      icon: const Icon(Icons.more_horiz),
                    ),
                  ],
                ),
                ...filteredExercises.map(buildExerciseCard),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 68,
        backgroundColor: Colors.white,
        indicatorColor: Colors.transparent,
        selectedIndex: selectedNav,
        onDestinationSelected: (value) {
          setState(() => selectedNav = value);
          if (value == 1) showMessage('Messages');
          if (value == 2) showMessage('Profile');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xff1976d2)),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: Color(0xff1976d2)),
            label: '',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xff1976d2)),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 48, 18, 20),
      color: const Color(0xff1767bd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, Jared!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '23 Jan, 2021',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff2583df),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child: IconButton(
                  onPressed: () => showMessage('Không có thông báo mới'),
                  icon: const Icon(Icons.notifications, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            onChanged: (value) => setState(() => keyword = value),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(color: Colors.white70, fontSize: 12),
              prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 18),
              filled: true,
              fillColor: const Color(0xff2583df),
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'How do you feel?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => showMessage('Mood options'),
                icon: const Icon(Icons.more_horiz, color: Colors.white, size: 19),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: moods.map((mood) {
              final String name = mood['name']!;
              final bool selected = selectedMood == name;

              return GestureDetector(
                onTap: () => setState(() => selectedMood = name),
                child: Column(
                  children: [
                    Container(
                      width: 43,
                      height: 43,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.white24
                            : const Color(0xff2583df),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Text(
                        mood['emoji']!,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildExerciseCard(Map<String, dynamic> exercise) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: exercise['color'] as Color,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(exercise['icon'] as IconData, color: Colors.white),
        ),
        title: Text(
          exercise['title'] as String,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          exercise['count'] as String,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
        trailing: IconButton(
          onPressed: () => showMessage(exercise['title'] as String),
          icon: const Icon(Icons.more_horiz, size: 18),
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}