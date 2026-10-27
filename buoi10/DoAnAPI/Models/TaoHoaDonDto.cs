using System.Collections.Generic;

namespace DienThoaiAPI.Models
{
    public class TaoHoaDonDto
    {
        public string? MaKH { get; set; } = "KH01";
        public List<ItemGioHangDto> ChiTiet { get; set; } = new List<ItemGioHangDto>();
    }

    public class ItemGioHangDto
    {
        public string MaDT { get; set; } = string.Empty;
        public int SoLuong { get; set; } = 1;
        public decimal DonGia { get; set; }
    }
}
