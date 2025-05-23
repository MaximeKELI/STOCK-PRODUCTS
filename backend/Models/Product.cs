using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StockLandyApi.Models;

public class Product
{
    [Key]
    public int Id { get; set; }

    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;

    [StringLength(500)]
    public string Description { get; set; } = string.Empty;

    [Required]
    [StringLength(50)]
    public string Sku { get; set; } = string.Empty;

    [StringLength(50)]
    public string? Barcode { get; set; }

    [Column(TypeName = "decimal(18,2)")]
    public decimal Price { get; set; }

    public int MinimumStock { get; set; }

    public int CurrentStock { get; set; }

    [Required]
    public int SupplierId { get; set; }

    [ForeignKey("SupplierId")]
    public Supplier Supplier { get; set; } = null!;

    public ICollection<StockMovement> StockMovements { get; set; } = new List<StockMovement>();
} 