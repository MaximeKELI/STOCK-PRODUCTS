using StockLandyApi.DTOs;

namespace StockLandyApi.Services;

public interface ISupplierService
{
    Task<IEnumerable<SupplierDto>> GetAllAsync();
    Task<SupplierDto?> GetByIdAsync(int id);
    Task<SupplierDto> CreateAsync(CreateSupplierDto createSupplierDto);
    Task<SupplierDto?> UpdateAsync(int id, UpdateSupplierDto updateSupplierDto);
    Task<bool> DeleteAsync(int id);
} 