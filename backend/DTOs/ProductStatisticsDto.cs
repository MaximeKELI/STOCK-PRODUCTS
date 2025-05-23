namespace StockLandyApi.DTOs;

public class ProductStatisticsDto
{
    public int TotalProducts { get; set; }
    public int LowStockProducts { get; set; }
    public int OutOfStockProducts { get; set; }
    public decimal TotalStockValue { get; set; }
    public int TotalStockItems { get; set; }
    public ProductDto? MostStockedProduct { get; set; }
    public ProductDto? LeastStockedProduct { get; set; }
    public ProductDto? MostExpensiveProduct { get; set; }
    public ProductDto? LeastExpensiveProduct { get; set; }
} 