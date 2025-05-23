using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StockLandyApi.DTOs;
using StockLandyApi.Services;
using System.Security.Claims;

namespace StockLandyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class StockMovementController : ControllerBase
{
    private readonly IStockMovementService _stockMovementService;

    public StockMovementController(IStockMovementService stockMovementService)
    {
        _stockMovementService = stockMovementService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<StockMovementDto>>> GetAll()
    {
        var movements = await _stockMovementService.GetAllAsync();
        return Ok(movements);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<StockMovementDto>> GetById(int id)
    {
        var movement = await _stockMovementService.GetByIdAsync(id);
        if (movement == null)
            return NotFound();
        return Ok(movement);
    }

    [HttpGet("product/{productId}")]
    public async Task<ActionResult<IEnumerable<StockMovementDto>>> GetByProductId(int productId)
    {
        var movements = await _stockMovementService.GetByProductIdAsync(productId);
        return Ok(movements);
    }

    [HttpPost]
    public async Task<ActionResult<StockMovementDto>> Create(CreateStockMovementDto createDto)
    {
        try
        {
            var userId = User.FindFirst(ClaimTypes.NameIdentifier)?.Value ?? "unknown";
            var movement = await _stockMovementService.CreateAsync(createDto, userId);
            return CreatedAtAction(nameof(GetById), new { id = movement.Id }, movement);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<StockMovementDto>> Update(int id, UpdateStockMovementDto updateDto)
    {
        try
        {
            var movement = await _stockMovementService.UpdateAsync(id, updateDto);
            if (movement == null)
                return NotFound();
            return Ok(movement);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        try
        {
            var result = await _stockMovementService.DeleteAsync(id);
            if (!result)
                return NotFound();
            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }
} 