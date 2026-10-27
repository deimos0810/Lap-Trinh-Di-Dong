using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DienThoaiAPI.Models
{
    [Table("KhachHang")]
    public class KhachHang
    {
        [Key]
        [MaxLength(20)]
        public string MaKH { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string TenKH { get; set; } = string.Empty;

        [MaxLength(100)]
        public string? Email { get; set; }

        [MaxLength(20)]
        public string? SoDienThoai { get; set; }
    }
}
