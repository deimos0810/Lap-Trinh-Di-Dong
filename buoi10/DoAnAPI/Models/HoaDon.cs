using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DienThoaiAPI.Models
{
    [Table("HoaDon")]
    public class HoaDon
    {
        [Key]
        [MaxLength(50)]
        public string MaHD { get; set; } = string.Empty;

        public DateTime NgayLap { get; set; } = DateTime.Now;

        [Required]
        [MaxLength(20)]
        public string MaKH { get; set; } = string.Empty;

        [ForeignKey("MaKH")]
        public virtual KhachHang? KhachHang { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal TongTien { get; set; }

        [MaxLength(50)]
        public string TrangThai { get; set; } = "Đã thanh toán";

        public virtual ICollection<ChiTietHoaDon> ChiTietHoaDons { get; set; } = new List<ChiTietHoaDon>();
    }
}
