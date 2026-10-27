using DienThoaiAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DienThoaiAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HoaDonController : ControllerBase
    {
        private readonly CuaHangDbContext _context;

        public HoaDonController(CuaHangDbContext context)
        {
            _context = context;
        }

        // GET: api/HoaDon
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var ds = await _context.HoaDons
                .Include(h => h.KhachHang)
                .Include(h => h.ChiTietHoaDons)
                    .ThenInclude(ct => ct.DienThoai)
                .OrderByDescending(h => h.NgayLap)
                .AsNoTracking()
                .ToListAsync();

            return Ok(ds);
        }

        // GET: api/HoaDon/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var hd = await _context.HoaDons
                .Include(h => h.KhachHang)
                .Include(h => h.ChiTietHoaDons)
                    .ThenInclude(ct => ct.DienThoai)
                .FirstOrDefaultAsync(h => h.MaHD == id);

            if (hd == null)
            {
                return NotFound(new { message = $"Không tìm thấy hóa đơn {id}" });
            }

            return Ok(hd);
        }

        // POST: api/HoaDon (Thanh toan gio hang -> luu hoa don vao SQL Server)
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] TaoHoaDonDto dto)
        {
            if (dto == null || dto.ChiTiet == null || dto.ChiTiet.Count == 0)
            {
                return BadRequest(new { message = "Giỏ hàng rỗng, không thể tạo hóa đơn!" });
            }

            // Kiem tra hoac tao khach hang mac dinh neu chua co
            var maKh = string.IsNullOrWhiteSpace(dto.MaKH) ? "KH01" : dto.MaKH;
            var khachHang = await _context.KhachHangs.FindAsync(maKh);
            if (khachHang == null)
            {
                khachHang = new KhachHang
                {
                    MaKH = maKh,
                    TenKH = "Lương Viễn Đông",
                    Email = "2001230180@huit.edu.vn",
                    SoDienThoai = "0901234567"
                };
                _context.KhachHangs.Add(khachHang);
                await _context.SaveChangesAsync();
            }

            // Tao ma hoa don tu dong theo thoi gian: HDyyyyMMddHHmmss
            var maHd = "HD" + DateTime.Now.ToString("yyyyMMddHHmmss");

            // Tinh tong tien va tao cac chi tiet hoa don
            decimal tongTien = 0;
            var chiTiets = new List<ChiTietHoaDon>();

            foreach (var item in dto.ChiTiet)
            {
                var dt = await _context.DienThoais.FindAsync(item.MaDT);
                var donGia = dt != null ? dt.Gia : item.DonGia;
                var thanhTien = donGia * item.SoLuong;
                tongTien += thanhTien;

                chiTiets.Add(new ChiTietHoaDon
                {
                    MaHD = maHd,
                    MaDT = item.MaDT,
                    SoLuong = item.SoLuong,
                    DonGia = donGia,
                    ThanhTien = thanhTien
                });
            }

            var hoaDon = new HoaDon
            {
                MaHD = maHd,
                NgayLap = DateTime.Now,
                MaKH = maKh,
                TongTien = tongTien,
                TrangThai = "Đã thanh toán",
                ChiTietHoaDons = chiTiets
            };

            _context.HoaDons.Add(hoaDon);
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Đã lưu hóa đơn thành công vào SQL Server!",
                maHD = hoaDon.MaHD,
                ngayLap = hoaDon.NgayLap,
                tongTien = hoaDon.TongTien,
                soLuongSanPham = chiTiets.Count
            });
        }
    }
}
