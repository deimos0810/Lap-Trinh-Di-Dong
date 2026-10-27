using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DienThoaiAPI.Models
{
    [Table("ChiTietHoaDon")]
    public class ChiTietHoaDon
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string MaHD { get; set; } = string.Empty;

        [ForeignKey("MaHD")]
        public virtual HoaDon? HoaDon { get; set; }

        [Required]
        [MaxLength(20)]
        public string MaDT { get; set; } = string.Empty;

        [ForeignKey("MaDT")]
        public virtual DienThoai? DienThoai { get; set; }

        public int SoLuong { get; set; } = 1;

        [Column(TypeName = "decimal(18,2)")]
        public decimal DonGia { get; set; }

        [Column(TypeName = "decimal(18,2)")]
        public decimal ThanhTien { get; set; }
    }
}
