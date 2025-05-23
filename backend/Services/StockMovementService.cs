using Microsoft.EntityFrameworkCore;
using StockLandyApi.Data;
using StockLandyApi.DTOs;
using StockLandyApi.Models;

namespace StockLandyApi.Services;

public class StockMovementService : IStockMovementService
{
    private readonly ApplicationDbContext _context;

    public StockMovementService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<StockMovementDto>> GetAllAsync()
    {
        return await _context.StockMovements
            .Include(sm => sm.Product)
            .OrderByDescending(sm => sm.Date)
            .Select(sm => MapToDto(sm))
            .ToListAsync();
    }

    public async Task<StockMovementDto?> GetByIdAsync(int id)
    {
        var movement = await _context.StockMovements
            .Include(sm => sm.Product)
            .FirstOrDefaultAsync(sm => sm.Id == id);

        return movement != null ? MapToDto(movement) : null;
    }

    public async Task<IEnumerable<StockMovementDto>> GetByProductIdAsync(int productId)
    {
        return await _context.StockMovements
            .Include(sm => sm.Product)
            .Where(sm => sm.ProductId == productId)
            .OrderByDescending(sm => sm.Date)
            .Select(sm => MapToDto(sm))
            .ToListAsync();
    }

    public async Task<StockMovementDto> CreateAsync(CreateStockMovementDto createDto, string userId)
    {
        // Vérifier si le produit existe
        var product = await _context.Products.FindAsync(createDto.ProductId);
        if (product == null)
        {
            throw new InvalidOperationException("Le produit spécifié n'existe pas.");
        }

        // Calculer le nouveau stock
        var newStock = product.CurrentStock;
        switch (createDto.Type)
        {
            case MovementType.Entry:
                newStock += createDto.Quantity;
                break;
            case MovementType.Exit:
                if (product.CurrentStock < createDto.Quantity)
                {
                    throw new InvalidOperationException("Stock insuffisant pour effectuer cette sortie.");
                }
                newStock -= createDto.Quantity;
                break;
            case MovementType.Adjustment:
                newStock += createDto.Quantity; // Peut être positif ou négatif pour un ajustement
                break;
        }

        // Créer le mouvement de stock
        var movement = new StockMovement
        {
            ProductId = createDto.ProductId,
            Type = createDto.Type,
            Quantity = createDto.Quantity,
            Date = createDto.Date,
            Notes = createDto.Notes,
            Reference = createDto.Reference,
            CreatedBy = userId
        };

        // Mettre à jour le stock du produit
        product.CurrentStock = newStock;

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            _context.StockMovements.Add(movement);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return MapToDto(movement);
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    public async Task<StockMovementDto?> UpdateAsync(int id, UpdateStockMovementDto updateDto)
    {
        var movement = await _context.StockMovements
            .Include(sm => sm.Product)
            .FirstOrDefaultAsync(sm => sm.Id == id);

        if (movement == null)
            return null;

        // On ne permet que la mise à jour des notes et de la référence
        movement.Notes = updateDto.Notes;
        movement.Reference = updateDto.Reference;

        await _context.SaveChangesAsync();

        return MapToDto(movement);
    }

    public async Task<bool> DeleteAsync(int id)
    {
        var movement = await _context.StockMovements
            .Include(sm => sm.Product)
            .FirstOrDefaultAsync(sm => sm.Id == id);

        if (movement == null)
            return false;

        // Annuler l'effet du mouvement sur le stock
        var product = movement.Product;
        switch (movement.Type)
        {
            case MovementType.Entry:
                if (product.CurrentStock < movement.Quantity)
                {
                    throw new InvalidOperationException("Impossible de supprimer ce mouvement car le stock actuel serait négatif.");
                }
                product.CurrentStock -= movement.Quantity;
                break;
            case MovementType.Exit:
                product.CurrentStock += movement.Quantity;
                break;
            case MovementType.Adjustment:
                product.CurrentStock -= movement.Quantity; // Inverse de l'ajustement original
                break;
        }

        using var transaction = await _context.Database.BeginTransactionAsync();
        try
        {
            _context.StockMovements.Remove(movement);
            await _context.SaveChangesAsync();
            await transaction.CommitAsync();
            return true;
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    private static StockMovementDto MapToDto(StockMovement movement)
    {
        return new StockMovementDto
        {
            Id = movement.Id,
            ProductId = movement.ProductId,
            ProductName = movement.Product.Name,
            ProductSku = movement.Product.Sku,
            Type = movement.Type,
            Quantity = movement.Quantity,
            Date = movement.Date,
            Notes = movement.Notes,
            CreatedBy = movement.CreatedBy,
            Reference = movement.Reference
        };
    }
} 