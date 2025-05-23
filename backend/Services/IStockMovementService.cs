using StockLandyApi.DTOs;

namespace StockLandyApi.Services;

public interface IStockMovementService
{
    Task<IEnumerable<StockMovementDto>> GetAllAsync();
    Task<StockMovementDto?> GetByIdAsync(int id);
    Task<IEnumerable<StockMovementDto>> GetByProductIdAsync(int productId);
    Task<StockMovementDto> CreateAsync(CreateStockMovementDto createDto, string userId);
    Task<StockMovementDto?> UpdateAsync(int id, UpdateStockMovementDto updateDto);
    Task<bool> DeleteAsync(int id);
} 