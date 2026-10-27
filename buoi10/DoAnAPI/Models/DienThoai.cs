using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace DienThoaiAPI.Models
{
    [Table("DienThoai")]
    public class DienThoai
    {
        [Key]
        [MaxLength(20)]
        public string MaDT { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string TenDT { get; set; } = string.Empty;

        [Required]
        [MaxLength(50)]
        public string HangSX { get; set; } = string.Empty;

        [Column(TypeName = "decimal(18,2)")]
        public decimal Gia { get; set; }

        public string? MoTa { get; set; }

        [MaxLength(500)]
        public string? HinhAnh { get; set; }

        public bool NoiBat { get; set; } = false;
    }
}
