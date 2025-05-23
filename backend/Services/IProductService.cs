using StockLandyApi.DTOs;

namespace StockLandyApi.Services;

public interface IProductService
{
    Task<IEnumerable<ProductDto>> GetAllAsync();
    Task<ProductDto?> GetByIdAsync(int id);
    Task<ProductDto?> GetBySkuAsync(string sku);
    Task<ProductDto?> GetByBarcodeAsync(string barcode);
    Task<ProductDto> CreateAsync(CreateProductDto createProductDto);
    Task<ProductDto?> UpdateAsync(int id, UpdateProductDto updateProductDto);
    Task<bool> DeleteAsync(int id);
    Task<ProductSearchResultDto> SearchAsync(ProductSearchDto searchDto);
    Task<IEnumerable<ProductDto>> GetLowStockProductsAsync();
    Task<ProductStatisticsDto> GetStatisticsAsync();
} 