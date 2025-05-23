using System.ComponentModel.DataAnnotations;

namespace StockLandyApi.DTOs;

public class ProductDto
{
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string Sku { get; set; } = string.Empty;
    public string? Barcode { get; set; }
    public decimal Price { get; set; }
    public int MinimumStock { get; set; }
    public int CurrentStock { get; set; }
    public int SupplierId { get; set; }
    public string SupplierName { get; set; } = string.Empty;
}

public class CreateProductDto
{
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

    [Range(0, 999999.99)]
    public decimal Price { get; set; }

    [Range(0, 999999)]
    public int MinimumStock { get; set; }

    [Range(0, 999999)]
    public int CurrentStock { get; set; }

    [Required]
    public int SupplierId { get; set; }
}

public class UpdateProductDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = string.Empty;

    [StringLength(500)]
    public string Description { get; set; } = string.Empty;

    [StringLength(50)]
    public string? Barcode { get; set; }

    [Range(0, 999999.99)]
    public decimal Price { get; set; }

    [Range(0, 999999)]
    public int MinimumStock { get; set; }

    [Required]
    public int SupplierId { get; set; }
} 