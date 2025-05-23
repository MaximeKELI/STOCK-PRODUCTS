using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace StockLandyApi.Models;

public enum MovementType
{
    Entry,      // Entrée de stock
    Exit,       // Sortie de stock
    Adjustment  // Ajustement de stock
}

public class StockMovement
{
    [Key]
    public int Id { get; set; }

    [Required]
    public int ProductId { get; set; }

    [ForeignKey("ProductId")]
    public Product Product { get; set; } = null!;

    [Required]
    public MovementType Type { get; set; }

    [Required]
    public int Quantity { get; set; }

    [Required]
    public DateTime Date { get; set; }

    [StringLength(500)]
    public string? Notes { get; set; }

    [Required]
    public string CreatedBy { get; set; } = string.Empty;

    public string? Reference { get; set; }
} 