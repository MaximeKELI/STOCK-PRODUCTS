using Microsoft.EntityFrameworkCore;
using StockLandyApi.Data;
using StockLandyApi.DTOs;
using StockLandyApi.Models;

namespace StockLandyApi.Services;

public class SupplierService : ISupplierService
{
    private readonly ApplicationDbContext _context;

    public SupplierService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<SupplierDto>> GetAllAsync()
    {
        var suppliers = await _context.Suppliers
            .Select(s => new SupplierDto
            {
                Id = s.Id,
                Name = s.Name,
                Email = s.Email,
                Phone = s.Phone,
                Address = s.Address,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            })
            .ToListAsync();

        return suppliers;
    }

    public async Task<SupplierDto?> GetByIdAsync(int id)
    {
        var supplier = await _context.Suppliers
            .Where(s => s.Id == id)
            .Select(s => new SupplierDto
            {
                Id = s.Id,
                Name = s.Name,
                Email = s.Email,
                Phone = s.Phone,
                Address = s.Address,
                CreatedAt = s.CreatedAt,
                UpdatedAt = s.UpdatedAt
            })
            .FirstOrDefaultAsync();

        return supplier;
    }

    public async Task<SupplierDto> CreateAsync(CreateSupplierDto createSupplierDto)
    {
        var supplier = new Supplier
        {
            Name = createSupplierDto.Name,
            Email = createSupplierDto.Email,
            Phone = createSupplierDto.Phone,
            Address = createSupplierDto.Address,
            CreatedAt = DateTime.UtcNow
        };

        _context.Suppliers.Add(supplier);
        await _context.SaveChangesAsync();

        return new SupplierDto
        {
            Id = supplier.Id,
            Name = supplier.Name,
            Email = supplier.Email,
            Phone = supplier.Phone,
            Address = supplier.Address,
            CreatedAt = supplier.CreatedAt,
            UpdatedAt = supplier.UpdatedAt
        };
    }

    public async Task<SupplierDto?> UpdateAsync(int id, UpdateSupplierDto updateSupplierDto)
    {
        var supplier = await _context.Suppliers.FindAsync(id);
        if (supplier == null) return null;

        if (updateSupplierDto.Name != null) supplier.Name = updateSupplierDto.Name;
        if (updateSupplierDto.Email != null) supplier.Email = updateSupplierDto.Email;
        if (updateSupplierDto.Phone != null) supplier.Phone = updateSupplierDto.Phone;
        supplier.Address = updateSupplierDto.Address;
        supplier.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        return new SupplierDto
        {
            Id = supplier.Id,
            Name = supplier.Name,
            Email = supplier.Email,
            Phone = supplier.Phone,
            Address = supplier.Address,
            CreatedAt = supplier.CreatedAt,
            UpdatedAt = supplier.UpdatedAt
        };
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var supplier = await _context.Suppliers
            .Include(s => s.Products)
            .FirstOrDefaultAsync(s => s.Id == id);

        if (supplier == null) return false;

        if (supplier.Products.Any())
        {
            throw new InvalidOperationException("Cannot delete supplier with associated products");
        }

        _context.Suppliers.Remove(supplier);
        await _context.SaveChangesAsync();
        return true;
    }
} 