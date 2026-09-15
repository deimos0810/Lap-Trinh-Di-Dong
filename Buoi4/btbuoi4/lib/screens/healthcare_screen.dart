import 'package:flutter/material.dart';

class HealthcareScreen extends StatefulWidget {
  const HealthcareScreen({super.key});

  @override
  State<HealthcareScreen> createState() => _HealthcareScreenState();
}

class _HealthcareScreenState extends State<HealthcareScreen> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';

  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Mitch Kiko',
      'specialty': 'Psychologist',
      'rating': '4.4',
      'experience': '7 y.e.',
      'image': 'assets/images/doctors/doctor_1.png',
    },
    {
      'name': 'Dr. Steve Jobs',
      'specialty': 'Surgeon',
      'rating': '5.0',
      'experience': '7 y.e.',
      'image': 'assets/images/doctors/doctor_2.png',
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String keyword = searchController.text.toLowerCase();
    final filteredDoctors = doctors.where((doctor) {
      final bool matchCategory =
          selectedCategory == 'All' || doctor['specialty'] == selectedCategory;
      final bool matchKeyword = doctor['name']!.toLowerCase().contains(keyword);
      return matchCategory && matchKeyword;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hello,\nMitch Koko',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffc9b5e9),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: IconButton(
                    onPressed: () => showMessage('Trang cá nhân'),
                    icon: const Icon(Icons.person, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            buildHealthBanner(),
            const SizedBox(height: 14),
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'How can we help you?',
                hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: const Color(0xffded0f3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 58,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  categoryButton('All', Icons.apps),
                  categoryButton('Dentist', Icons.health_and_safety),
                  categoryButton('Surgeon', Icons.medical_services),
                  categoryButton('Psychologist', Icons.psychology),
                ],
              ),
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Doctor list',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () => showMessage('Hiển thị tất cả bác sĩ'),
                  child: const Text('See all', style: TextStyle(fontSize: 11)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (filteredDoctors.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(child: Text('Không tìm thấy bác sĩ phù hợp')),
              )
            else
              SizedBox(
                height: 235,
                child: Row(
                  children: filteredDoctors
                      .map((doctor) => doctorCard(doctor))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildHealthBanner() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xffffa0c9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: const Color(0xffa88ad3),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How do you feel?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                SizedBox(height: 3),
                Text(
                  'Fill out your medical card\nright now',
                  style: TextStyle(fontSize: 9),
                ),
                SizedBox(height: 7),
                Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryButton(String title, IconData icon) {
    final bool selected = selectedCategory == title;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => selectedCategory = title),
        child: Container(
          width: 82,
          decoration: BoxDecoration(
            color: selected ? const Color(0xffc4a9e5) : const Color(0xffded0f3),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 19, color: Colors.purple),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  Widget doctorCard(Map<String, String> doctor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => showMessage('Đặt lịch với ${doctor['name']}'),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
          decoration: BoxDecoration(
            color: const Color(0xffc4b2df),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    doctor['image']!,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.purple.shade100,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 7),
              Text('⭐ ${doctor['rating']}', style: const TextStyle(fontSize: 11)),
              Text(
                doctor['name']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              Text(
                '${doctor['specialty']} ${doctor['experience']}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 9, color: Colors.black54),
              ),
            ],
          ),
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