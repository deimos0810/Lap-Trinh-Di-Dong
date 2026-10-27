using DienThoaiAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DienThoaiAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DienThoaiController : ControllerBase
    {
        private readonly CuaHangDbContext _context;

        public DienThoaiController(CuaHangDbContext context)
        {
            _context = context;
        }

        // GET: api/DienThoai
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var ds = await _context.DienThoais.AsNoTracking().ToListAsync();
            return Ok(ds);
        }

        // GET: api/DienThoai/noibat
        [HttpGet("noibat")]
        public async Task<IActionResult> GetNoiBat()
        {
            var ds = await _context.DienThoais
                .Where(x => x.NoiBat)
                .AsNoTracking()
                .ToListAsync();
            return Ok(ds);
        }

        // GET: api/DienThoai/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var sp = await _context.DienThoais.FindAsync(id);
            if (sp == null)
            {
                return NotFound(new { message = $"Không tìm thấy điện thoại có mã: {id}" });
            }
            return Ok(sp);
        }

        // POST: api/DienThoai
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] DienThoai model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            var tonTai = await _context.DienThoais.AnyAsync(x => x.MaDT == model.MaDT);
            if (tonTai)
            {
                return Conflict(new { message = $"Mã điện thoại {model.MaDT} đã tồn tại!" });
            }

            _context.DienThoais.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.MaDT }, model);
        }

        // PUT: api/DienThoai/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] DienThoai model)
        {
            if (id != model.MaDT)
            {
                return BadRequest(new { message = "Mã điện thoại không khớp!" });
            }

            var sp = await _context.DienThoais.FindAsync(id);
            if (sp == null)
            {
                return NotFound(new { message = $"Không tìm thấy điện thoại có mã: {id}" });
            }

            sp.TenDT = model.TenDT;
            sp.HangSX = model.HangSX;
            sp.Gia = model.Gia;
            sp.MoTa = model.MoTa;
            sp.HinhAnh = model.HinhAnh;
            sp.NoiBat = model.NoiBat;

            await _context.SaveChangesAsync();
            return Ok(sp);
        }

        // DELETE: api/DienThoai/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var sp = await _context.DienThoais.FindAsync(id);
            if (sp == null)
            {
                return NotFound(new { message = $"Không tìm thấy điện thoại có mã: {id}" });
            }

            // Kiem tra rang buoc hoa don
            var dangCoTrongHoaDon = await _context.ChiTietHoaDons.AnyAsync(x => x.MaDT == id);
            if (dangCoTrongHoaDon)
            {
                return BadRequest(new { message = "Không thể xóa sản phẩm này vì đã có trong hóa đơn đã bán!" });
            }

            _context.DienThoais.Remove(sp);
            await _context.SaveChangesAsync();

            return Ok(new { message = $"Đã xóa thành công điện thoại {id}" });
        }
    }
}
