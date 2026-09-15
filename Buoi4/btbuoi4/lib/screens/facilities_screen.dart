import 'package:flutter/material.dart';

class FacilitiesScreen extends StatefulWidget {
  const FacilitiesScreen({super.key});

  @override
  State<FacilitiesScreen> createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  int selectedIndex = 0;

  final List<String> titles = [
    'Trang chủ',
    'Cơ sở vật chất',
    'Bản đồ',
    'Thông tin',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex]),
      ),
      body: buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Cơ sở',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Bản đồ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Thông tin',
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    if (selectedIndex == 0) {
      return buildHomePage();
    }

    if (selectedIndex == 1) {
      return buildFacilitiesPage();
    }

    if (selectedIndex == 2) {
      return buildMapPage();
    }

    return buildInformationPage();
  }

  Widget buildHomePage() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.school, color: Colors.blue, size: 48),
              SizedBox(height: 12),
              Text(
                'Đại học Công thương TP.HCM',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Ứng dụng giới thiệu các khu vực và cơ sở vật chất của trường.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Tiện ích nổi bật',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Card(
          child: ListTile(
            leading: Icon(Icons.menu_book, color: Colors.blue),
            title: Text('Thư viện'),
            subtitle: Text('Không gian học tập và tra cứu tài liệu.'),
          ),
        ),
        const Card(
          child: ListTile(
            leading: Icon(Icons.computer, color: Colors.blue),
            title: Text('Phòng máy'),
            subtitle: Text('Phòng thực hành máy tính cho sinh viên.'),
          ),
        ),
      ],
    );
  }

  Widget buildFacilitiesPage() {
    final List<Map<String, dynamic>> facilities = [
      {
        'name': 'Thư viện',
        'description': 'Không gian học tập và đọc sách.',
        'icon': Icons.local_library,
      },
      {
        'name': 'Phòng máy',
        'description': 'Trang bị máy tính phục vụ học tập.',
        'icon': Icons.computer,
      },
      {
        'name': 'Hội trường',
        'description': 'Khu vực tổ chức sự kiện và hội thảo.',
        'icon': Icons.business,
      },
      {
        'name': 'Phòng học',
        'description': 'Phòng học được trang bị máy chiếu.',
        'icon': Icons.meeting_room,
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: facilities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final facility = facilities[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.shade50,
              child: Icon(
                facility['icon'] as IconData,
                color: Colors.blue,
              ),
            ),
            title: Text(
              facility['name'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(facility['description'] as String),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }

  Widget buildMapPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Campus map',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/map_sample.png',
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blue.shade50,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.blue),
                        SizedBox(height: 12),
                        Text('Thêm ảnh vào assets/images/map_sample.png'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInformationPage() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thông tin trường',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 18),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.location_on, color: Colors.blue),
            title: Text('Địa chỉ'),
            subtitle: Text('Thành phố Hồ Chí Minh'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.email, color: Colors.blue),
            title: Text('Email'),
            subtitle: Text('contact@example.edu.vn'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.phone, color: Colors.blue),
            title: Text('Điện thoại'),
            subtitle: Text('028 xxxx xxxx'),
          ),
        ],
      ),
    );
  }
}