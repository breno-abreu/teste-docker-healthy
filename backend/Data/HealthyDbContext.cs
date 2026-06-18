using HealthyApi.Models;
using Microsoft.EntityFrameworkCore;

namespace HealthyApi.Data;

public class HealthyDbContext : DbContext
{
    public HealthyDbContext(DbContextOptions<HealthyDbContext> options) : base(options)
    {
    }

    public DbSet<HealtyItem> HealtyItems => Set<HealtyItem>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<HealtyItem>(entity =>
        {
            entity.ToTable("HealtyTable");
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Message).HasColumnName("message").IsRequired();
        });
    }
}
