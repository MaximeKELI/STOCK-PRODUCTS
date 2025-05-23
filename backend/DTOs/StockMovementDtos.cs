using System.ComponentModel.DataAnnotations;
using StockLandyApi.Models;

namespace StockLandyApi.DTOs;

public class StockMovementDto
{
    public int Id { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public string ProductSku { get; set; } = string.Empty;
    public MovementType Type { get; set; }
    public int Quantity { get; set; }
    public DateTime Date { get; set; }
    public string? Notes { get; set; }
    public string CreatedBy { get; set; } = string.Empty;
    public string? Reference { get; set; }
}

public class CreateStockMovementDto
{
    [Required]
    public int ProductId { get; set; }

    [Required]
    public MovementType Type { get; set; }

    [Required]
    [Range(1, int.MaxValue)]
    public int Quantity { get; set; }

    [Required]
    public DateTime Date { get; set; }

    [StringLength(500)]
    public string? Notes { get; set; }

    public string? Reference { get; set; }
}

public class UpdateStockMovementDto
{
    [StringLength(500)]
    public string? Notes { get; set; }

    public string? Reference { get; set; }
} 