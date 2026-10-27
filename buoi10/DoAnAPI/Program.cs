using DienThoaiAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// 1. Cấu hình DbContext kết nối SQL Server CuaHangDienThoaiDB (LocalDB)
var connectionString = builder.Configuration.GetConnectionString("CuaHangDbConnection") 
    ?? "Server=(localdb)\\MSSQLLocalDB;Database=CuaHangDienThoaiDB;Trusted_Connection=True;TrustServerCertificate=True;";

builder.Services.AddDbContext<CuaHangDbContext>(options =>
    options.UseSqlServer(connectionString));

// 2. Cấu hình CORS để Flutter Web / Windows / Android truy cập được API
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// 3. Cấu hình bỏ qua vòng lặp JSON khi serialize entity quan hệ
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
        options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
        options.JsonSerializerOptions.PropertyNameCaseInsensitive = true;
    });

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// 4. Kích hoạt Swagger UI
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "CuaHangDienThoai API v1");
    c.RoutePrefix = "swagger";
});

// Chuyển hướng trang chủ về /swagger để mở http://localhost:5183 là vào ngay Swagger
app.MapGet("/", () => Results.Redirect("/swagger"));

// Kích hoạt CORS
app.UseCors("AllowAll");

app.UseAuthorization();

app.MapControllers();

// Lắng nghe cổng 5183 trên tất cả IP (localhost, 10.0.2.2 máy ảo Android, mạng LAN)
app.Run("http://0.0.0.0:5183");
