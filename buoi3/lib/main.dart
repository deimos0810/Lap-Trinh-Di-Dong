import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      // home: BaiTap1(),
      // home: BaiTap2(),
      // home: BaiTap3(),
      // home: BaiTap4(),
      home: BaiTap5(),
    );
  }
}

/// =======================================================
/// BÀI TẬP 01
/// Hiển thị thông tin sinh viên và giảng viên.
/// =======================================================
class BaiTap1 extends StatelessWidget {
  const BaiTap1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Thông tin sinh viên'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'THÔNG TIN SINH VIÊN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            ClipOval(
              child: Image.asset(
                'assets/images/student.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Họ và tên: Nguyễn Văn A',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'MSSV: 2001221234',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Lớp: 13DHTH02',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Khóa: 13 Đại học',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Ngành: Công nghệ thông tin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Trường: Đại học Công Thương\nThành phố Hồ Chí Minh',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 25),

            ElevatedButton(onPressed: () {}, child: const Text('Trở về')),

            const SizedBox(height: 20),

            const SizedBox(height: 35),
            const Divider(thickness: 1),
            const SizedBox(height: 20),

            const Text(
              'THÔNG TIN GIẢNG VIÊN',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 20),

            ClipOval(
              child: Image.asset(
                'assets/images/teacher.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Giảng viên Trần Thị A',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Khoa: Công nghệ Thông tin',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Học hàm: Thạc sĩ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Chuyên ngành: CNPM',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Giảng dạy: Nhập môn lập trình,\nLập trình Windows, Lập trình web...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(onPressed: () {}, child: const Text('Trở về')),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// BÀI TẬP 02
/// Hiển thị thông tin của một đề tài đồ án khóa luận.
/// =======================================================
class BaiTap2 extends StatelessWidget {
  const BaiTap2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Thông tin đề tài đồ án'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.assignment, color: Colors.blue, size: 100),
            ),

            const SizedBox(height: 25),

            const Center(
              child: Text(
                'THÔNG TIN ĐỀ TÀI',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Mã đề tài: DT01',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Tên đề tài: Xây dựng hệ thống quản lý tour du lịch trực tuyến',
              style: TextStyle(fontSize: 18, color: Colors.greenAccent),
            ),

            const SizedBox(height: 15),

            const Text(
              'Số lượng sinh viên tối đa: 03 sinh viên',
              style: TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 82, 65, 235),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Chuyên ngành: Công nghệ phần mềm',
              style: TextStyle(fontSize: 18, color: Colors.blueAccent),
            ),

            const SizedBox(height: 15),

            const Text(
              'Giảng viên hướng dẫn: ThS. Nguyễn Thị B',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),

            const SizedBox(height: 15),

            const Text(
              'Yêu cầu đề tài: Xây dựng ứng dụng quản lý khách hàng, tour du lịch, đặt tour và thống kê báo cáo.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Trở về'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// BÀI TẬP 03
/// Hiển thị 03 ảnh sản phẩm, mã, tên, nhà sản xuất,
/// giá bán và mô tả sản phẩm.
/// =======================================================
class BaiTap3 extends StatelessWidget {
  const BaiTap3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Thông tin sản phẩm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'THÔNG TIN SẢN PHẨM',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            // 03 ảnh laptop lấy từ assets/images/
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/laptop1.jpg',
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Image.asset(
                    'assets/images/laptop2.jpg',
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Image.asset(
                    'assets/images/laptop3.jpg',
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mã sản phẩm: LT001',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tên sản phẩm: Laptop Dell Inspiron 15',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nhà sản xuất: Dell Technologies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Giá bán: 18.990.000 VNĐ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Mô tả sản phẩm: Laptop Dell Inspiron 15 có màn hình 15.6 inch, RAM 8GB, SSD 512GB. Sản phẩm phù hợp cho sinh viên và nhân viên văn phòng.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(onPressed: () {}, child: const Text('Trở về')),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// BÀI TẬP 04
/// Thông tin một nhóm gồm 3 thành viên.
/// =======================================================
class BaiTap4 extends StatelessWidget {
  const BaiTap4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Thông tin nhóm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.groups, color: Colors.blue, size: 90),
            ),

            const SizedBox(height: 15),

            const Center(
              child: Text(
                'THÔNG TIN NHÓM',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Mã nhóm: N01',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Tên nhóm: Nhóm Công nghệ phần mềm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Số lượng thành viên: 03 thành viên',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'DANH SÁCH THÀNH VIÊN',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 15),

            memberBox(
              number: '1',
              studentId: '2001221234',
              name: 'Nguyễn Văn A',
              role: 'Nhóm trưởng',
            ),

            const SizedBox(height: 12),

            memberBox(
              number: '2',
              studentId: '2001221235',
              name: 'Trần Thị B',
              role: 'Thành viên',
            ),

            const SizedBox(height: 12),

            memberBox(
              number: '3',
              studentId: '2001221236',
              name: 'Lê Văn C',
              role: 'Thành viên',
            ),

            const SizedBox(height: 25),

            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Trở về'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget memberBox({
    required String number,
    required String studentId,
    required String name,
    required String role,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Text(number),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Mã sinh viên: $studentId',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
                const SizedBox(height: 6),
                Text(
                  'Vai trò: $role',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================================================
/// BÀI TẬP 05
/// Giới thiệu ngành Công nghệ thông tin
/// và ngành An toàn thông tin.
/// =======================================================
class BaiTap5 extends StatelessWidget {
  const BaiTap5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Giới thiệu ngành học'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.school, color: Colors.blue, size: 90),

            const SizedBox(height: 15),

            const Text(
              'KHOA CÔNG NGHỆ THÔNG TIN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Trường Đại học Công Thương Thành phố Hồ Chí Minh',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 25),

            industryBox(
              title: '1. Ngành Công nghệ thông tin',
              icon: Icons.computer,
              color: Colors.blue,
              content:
                  'Ngành Công nghệ thông tin đào tạo sinh viên có kiến thức và kỹ năng về lập trình, phát triển phần mềm, cơ sở dữ liệu, mạng máy tính và xây dựng các hệ thống thông tin.',
              subjects:
                  'Một số lĩnh vực học tập: lập trình, phát triển ứng dụng web, phát triển ứng dụng di động, cơ sở dữ liệu, phân tích và thiết kế hệ thống.',
              careers:
                  'Vị trí việc làm: lập trình viên, kiểm thử phần mềm, phân tích viên hệ thống, quản trị cơ sở dữ liệu và phát triển ứng dụng.',
            ),

            const SizedBox(height: 20),

            industryBox(
              title: '2. Ngành An toàn thông tin',
              icon: Icons.security,
              color: Colors.red,
              content:
                  'Ngành An toàn thông tin đào tạo sinh viên có kiến thức về bảo vệ dữ liệu, bảo mật hệ thống, an ninh mạng và phòng chống các nguy cơ tấn công trong môi trường số.',
              subjects:
                  'Một số lĩnh vực học tập: an toàn mạng, mật mã học, bảo mật hệ điều hành, kiểm thử xâm nhập và điều tra số.',
              careers:
                  'Vị trí việc làm: chuyên viên an toàn thông tin, chuyên viên an ninh mạng, kiểm thử bảo mật, quản trị hệ thống và giám sát an ninh mạng.',
            ),

            const SizedBox(height: 25),

            const Text(
              'Mục tiêu đào tạo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Sinh viên được trang bị kiến thức chuyên môn, kỹ năng thực hành, khả năng làm việc nhóm và khả năng ứng dụng công nghệ để giải quyết các vấn đề thực tế.',
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 17,
                height: 1.5,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(onPressed: () {}, child: const Text('Trở về')),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  static Widget industryBox({
    required String title,
    required IconData icon,
    required Color color,
    required String content,
    required String subjects,
    required String careers,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Text(
            content,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),

          const SizedBox(height: 12),

          Text(
            subjects,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),

          const SizedBox(height: 12),

          Text(
            careers,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16, height: 1.45),
          ),
        ],
      ),
    );
  }
}
