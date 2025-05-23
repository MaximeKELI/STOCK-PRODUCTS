using Microsoft.EntityFrameworkCore;
using StockLandyApi.Data;
using StockLandyApi.DTOs;
using StockLandyApi.Models;

namespace StockLandyApi.Services;

public class ProductService : IProductService
{
    private readonly ApplicationDbContext _context;

    public ProductService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<ProductDto>> GetAllAsync()
    {
        return await _context.Products
            .Include(p => p.Supplier)
            .Select(p => MapToDto(p))
            .ToListAsync();
    }

    public async Task<ProductDto?> GetByIdAsync(int id)
    {
        var product = await _context.Products
            .Include(p => p.Supplier)
            .FirstOrDefaultAsync(p => p.Id == id);
        
        return product != null ? MapToDto(product) : null;
    }

    public async Task<ProductDto?> GetBySkuAsync(string sku)
    {
        var product = await _context.Products
            .Include(p => p.Supplier)
            .FirstOrDefaultAsync(p => p.Sku == sku);
        
        return product != null ? MapToDto(product) : null;
    }

    public async Task<ProductDto?> GetByBarcodeAsync(string barcode)
    {
        var product = await _context.Products
            .Include(p => p.Supplier)
            .FirstOrDefaultAsync(p => p.Barcode == barcode);
        
        return product != null ? MapToDto(product) : null;
    }

    public async Task<ProductDto> CreateAsync(CreateProductDto createProductDto)
    {
        // Vérifier si le SKU existe déjà
        if (await _context.Products.AnyAsync(p => p.Sku == createProductDto.Sku))
        {
            throw new InvalidOperationException("Un produit avec ce SKU existe déjà.");
        }

        // Vérifier si le code-barres existe déjà (s'il est fourni)
        if (!string.IsNullOrEmpty(createProductDto.Barcode) && 
            await _context.Products.AnyAsync(p => p.Barcode == createProductDto.Barcode))
        {
            throw new InvalidOperationException("Un produit avec ce code-barres existe déjà.");
        }

        // Vérifier si le fournisseur existe
        var supplier = await _context.Suppliers.FindAsync(createProductDto.SupplierId);
        if (supplier == null)
        {
            throw new InvalidOperationException("Le fournisseur spécifié n'existe pas.");
        }

        var product = new Product
        {
            Name = createProductDto.Name,
            Description = createProductDto.Description,
            Sku = createProductDto.Sku,
            Barcode = createProductDto.Barcode,
            Price = createProductDto.Price,
            MinimumStock = createProductDto.MinimumStock,
            CurrentStock = createProductDto.CurrentStock,
            SupplierId = createProductDto.SupplierId
        };

        _context.Products.Add(product);
        await _context.SaveChangesAsync();

        return MapToDto(product);
    }

    public async Task<ProductDto?> UpdateAsync(int id, UpdateProductDto updateProductDto)
    {
        var product = await _context.Products
            .Include(p => p.Supplier)
            .FirstOrDefaultAsync(p => p.Id == id);

        if (product == null)
            return null;

        // Vérifier si le code-barres existe déjà (s'il est fourni et différent)
        if (!string.IsNullOrEmpty(updateProductDto.Barcode) && 
            updateProductDto.Barcode != product.Barcode &&
            await _context.Products.AnyAsync(p => p.Barcode == updateProductDto.Barcode))
        {
            throw new InvalidOperationException("Un produit avec ce code-barres existe déjà.");
        }

        // Vérifier si le fournisseur existe
        var supplier = await _context.Suppliers.FindAsync(updateProductDto.SupplierId);
        if (supplier == null)
        {
            throw new InvalidOperationException("Le fournisseur spécifié n'existe pas.");
        }

        product.Name = updateProductDto.Name;
        product.Description = updateProductDto.Description;
        product.Barcode = updateProductDto.Barcode;
        product.Price = updateProductDto.Price;
        product.MinimumStock = updateProductDto.MinimumStock;
        product.SupplierId = updateProductDto.SupplierId;

        await _context.SaveChangesAsync();

        return MapToDto(product);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var product = await _context.Products.FindAsync(id);
        if (product == null)
            return false;

        // Vérifier s'il y a des mouvements de stock liés
        if (await _context.StockMovements.AnyAsync(sm => sm.ProductId == id))
        {
            throw new InvalidOperationException("Impossible de supprimer ce produit car il a des mouvements de stock associés.");
        }

        _context.Products.Remove(product);
        await _context.SaveChangesAsync();
        return true;
    }

    public async Task<ProductSearchResultDto> SearchAsync(ProductSearchDto searchDto)
    {
        var query = _context.Products
            .Include(p => p.Supplier)
            .AsQueryable();

        // Appliquer les filtres
        if (!string.IsNullOrWhiteSpace(searchDto.SearchTerm))
        {
            var searchTerm = searchDto.SearchTerm.ToLower();
            query = query.Where(p => 
                p.Name.ToLower().Contains(searchTerm) ||
                p.Description.ToLower().Contains(searchTerm) ||
                p.Sku.ToLower().Contains(searchTerm) ||
                (p.Barcode != null && p.Barcode.ToLower().Contains(searchTerm))
            );
        }

        if (searchDto.SupplierId.HasValue)
        {
            query = query.Where(p => p.SupplierId == searchDto.SupplierId);
        }

        if (searchDto.LowStock == true)
        {
            query = query.Where(p => p.CurrentStock <= p.MinimumStock);
        }

        if (searchDto.MinPrice.HasValue)
        {
            query = query.Where(p => p.Price >= searchDto.MinPrice);
        }

        if (searchDto.MaxPrice.HasValue)
        {
            query = query.Where(p => p.Price <= searchDto.MaxPrice);
        }

        // Calculer le nombre total d'éléments
        var totalCount = await query.CountAsync();
        var totalPages = (int)Math.Ceiling(totalCount / (double)searchDto.PageSize);

        // Appliquer le tri
        query = searchDto.SortBy?.ToLower() switch
        {
            "name" => searchDto.SortDescending ? 
                query.OrderByDescending(p => p.Name) : 
                query.OrderBy(p => p.Name),
            "price" => searchDto.SortDescending ? 
                query.OrderByDescending(p => p.Price) : 
                query.OrderBy(p => p.Price),
            "stock" => searchDto.SortDescending ? 
                query.OrderByDescending(p => p.CurrentStock) : 
                query.OrderBy(p => p.CurrentStock),
            "supplier" => searchDto.SortDescending ? 
                query.OrderByDescending(p => p.Supplier.Name) : 
                query.OrderBy(p => p.Supplier.Name),
            _ => query.OrderBy(p => p.Name)
        };

        // Appliquer la pagination
        var products = await query
            .Skip((searchDto.Page - 1) * searchDto.PageSize)
            .Take(searchDto.PageSize)
            .Select(p => MapToDto(p))
            .ToListAsync();

        return new ProductSearchResultDto
        {
            Products = products,
            TotalCount = totalCount,
            TotalPages = totalPages,
            CurrentPage = searchDto.Page,
            HasNextPage = searchDto.Page < totalPages,
            HasPreviousPage = searchDto.Page > 1
        };
    }

    public async Task<IEnumerable<ProductDto>> GetLowStockProductsAsync()
    {
        return await _context.Products
            .Include(p => p.Supplier)
            .Where(p => p.CurrentStock <= p.MinimumStock)
            .Select(p => MapToDto(p))
            .ToListAsync();
    }

    public async Task<ProductStatisticsDto> GetStatisticsAsync()
    {
        var products = await _context.Products
            .Include(p => p.Supplier)
            .ToListAsync();

        if (!products.Any())
        {
            return new ProductStatisticsDto
            {
                TotalProducts = 0,
                LowStockProducts = 0,
                OutOfStockProducts = 0,
                TotalStockValue = 0,
                TotalStockItems = 0
            };
        }

        var lowStockProducts = products.Count(p => p.CurrentStock <= p.MinimumStock);
        var outOfStockProducts = products.Count(p => p.CurrentStock == 0);
        var totalStockValue = products.Sum(p => p.CurrentStock * p.Price);
        var totalStockItems = products.Sum(p => p.CurrentStock);

        var mostStocked = products.OrderByDescending(p => p.CurrentStock).First();
        var leastStocked = products.OrderBy(p => p.CurrentStock).First();
        var mostExpensive = products.OrderByDescending(p => p.Price).First();
        var leastExpensive = products.OrderBy(p => p.Price).First();

        return new ProductStatisticsDto
        {
            TotalProducts = products.Count,
            LowStockProducts = lowStockProducts,
            OutOfStockProducts = outOfStockProducts,
            TotalStockValue = totalStockValue,
            TotalStockItems = totalStockItems,
            MostStockedProduct = MapToDto(mostStocked),
            LeastStockedProduct = MapToDto(leastStocked),
            MostExpensiveProduct = MapToDto(mostExpensive),
            LeastExpensiveProduct = MapToDto(leastExpensive)
        };
    }

    private static ProductDto MapToDto(Product product)
    {
        return new ProductDto
        {
            Id = product.Id,
            Name = product.Name,
            Description = product.Description,
            Sku = product.Sku,
            Barcode = product.Barcode,
            Price = product.Price,
            MinimumStock = product.MinimumStock,
            CurrentStock = product.CurrentStock,
            SupplierId = product.SupplierId,
            SupplierName = product.Supplier?.Name ?? string.Empty
        };
    }
} 