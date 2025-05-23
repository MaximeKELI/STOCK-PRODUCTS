namespace StockLandyApi.DTOs;

public class ProductSearchDto
{
    public string? SearchTerm { get; set; }
    public int? SupplierId { get; set; }
    public bool? LowStock { get; set; }
    public decimal? MinPrice { get; set; }
    public decimal? MaxPrice { get; set; }
    public string? SortBy { get; set; }
    public bool SortDescending { get; set; }
    public int Page { get; set; } = 1;
    public int PageSize { get; set; } = 10;
}

public class ProductSearchResultDto
{
    public IEnumerable<ProductDto> Products { get; set; } = new List<ProductDto>();
    public int TotalCount { get; set; }
    public int TotalPages { get; set; }
    public int CurrentPage { get; set; }
    public bool HasNextPage { get; set; }
    public bool HasPreviousPage { get; set; }
} 