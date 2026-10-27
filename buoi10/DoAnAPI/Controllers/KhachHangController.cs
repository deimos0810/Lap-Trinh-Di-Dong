using DienThoaiAPI.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DienThoaiAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class KhachHangController : ControllerBase
    {
        private readonly CuaHangDbContext _context;

        public KhachHangController(CuaHangDbContext context)
        {
            _context = context;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var ds = await _context.KhachHangs.AsNoTracking().ToListAsync();
            return Ok(ds);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var kh = await _context.KhachHangs.FindAsync(id);
            if (kh == null)
            {
                return NotFound(new { message = $"Không tìm thấy khách hàng: {id}" });
            }
            return Ok(kh);
        }
    }
}
