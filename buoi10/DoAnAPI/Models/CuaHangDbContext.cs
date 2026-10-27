using Microsoft.EntityFrameworkCore;

namespace DienThoaiAPI.Models
{
    public class CuaHangDbContext : DbContext
    {
        public CuaHangDbContext(DbContextOptions<CuaHangDbContext> options) : base(options)
        {
        }

        public DbSet<DienThoai> DienThoais { get; set; } = null!;
        public DbSet<KhachHang> KhachHangs { get; set; } = null!;
        public DbSet<HoaDon> HoaDons { get; set; } = null!;
        public DbSet<ChiTietHoaDon> ChiTietHoaDons { get; set; } = null!;

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<DienThoai>(entity =>
            {
                entity.HasKey(e => e.MaDT);
                entity.Property(e => e.Gia).HasPrecision(18, 2);
            });

            modelBuilder.Entity<KhachHang>(entity =>
            {
                entity.HasKey(e => e.MaKH);
            });

            modelBuilder.Entity<HoaDon>(entity =>
            {
                entity.HasKey(e => e.MaHD);
                entity.Property(e => e.TongTien).HasPrecision(18, 2);

                entity.HasOne(d => d.KhachHang)
                    .WithMany()
                    .HasForeignKey(d => d.MaKH)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            modelBuilder.Entity<ChiTietHoaDon>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.DonGia).HasPrecision(18, 2);
                entity.Property(e => e.ThanhTien).HasPrecision(18, 2);

                entity.HasOne(d => d.HoaDon)
                    .WithMany(p => p.ChiTietHoaDons)
                    .HasForeignKey(d => d.MaHD)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(d => d.DienThoai)
                    .WithMany()
                    .HasForeignKey(d => d.MaDT)
                    .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}
