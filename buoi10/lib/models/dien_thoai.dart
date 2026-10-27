class DienThoai {
  final String maDT;
  final String tenDT;
  final String hangSX;
  final double gia;
  final String moTa;
  final String? hinhAnh;
  final bool noiBat;

  DienThoai({
    required this.maDT,
    required this.tenDT,
    required this.hangSX,
    required this.gia,
    required this.moTa,
    this.hinhAnh,
    this.noiBat = false,
  });

  factory DienThoai.fromJson(Map<String, dynamic> json) {
    return DienThoai(
      maDT: (json['maDT'] ?? json['MaDT'] ?? '').toString(),
      tenDT: (json['tenDT'] ?? json['TenDT'] ?? '').toString(),
      hangSX: (json['hangSX'] ?? json['HangSX'] ?? '').toString(),
      gia: (json['gia'] ?? json['Gia'] ?? 0.0) is num
          ? (json['gia'] ?? json['Gia'] as num).toDouble()
          : double.tryParse((json['gia'] ?? json['Gia']).toString()) ?? 0.0,
      moTa: (json['moTa'] ?? json['MoTa'] ?? '').toString(),
      hinhAnh: json['hinhAnh'] ?? json['HinhAnh'],
      noiBat: json['noiBat'] ?? json['NoiBat'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maDT': maDT,
      'tenDT': tenDT,
      'hangSX': hangSX,
      'gia': gia,
      'moTa': moTa,
      'hinhAnh': hinhAnh,
      'noiBat': noiBat,
    };
  }
}
