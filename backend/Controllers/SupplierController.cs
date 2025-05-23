using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StockLandyApi.DTOs;
using StockLandyApi.Services;

namespace StockLandyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class SupplierController : ControllerBase
{
    private readonly ISupplierService _supplierService;

    public SupplierController(ISupplierService supplierService)
    {
        _supplierService = supplierService;
    }

    [HttpGet]
    public async Task<ActionResult<List<SupplierDto>>> GetAll()
    {
        try
        {
            var suppliers = await _supplierService.GetAllAsync();
            return Ok(suppliers);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An error occurred while retrieving suppliers", error = ex.Message });
        }
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<SupplierDto>> GetById(int id)
    {
        try
        {
            var supplier = await _supplierService.GetByIdAsync(id);
            if (supplier == null)
            {
                return NotFound(new { message = "Supplier not found" });
            }
            return Ok(supplier);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An error occurred while retrieving the supplier", error = ex.Message });
        }
    }

    [HttpPost]
    public async Task<ActionResult<SupplierDto>> Create(CreateSupplierDto dto)
    {
        try
        {
            var supplier = await _supplierService.CreateAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = supplier.Id }, supplier);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An error occurred while creating the supplier", error = ex.Message });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<SupplierDto>> Update(int id, UpdateSupplierDto dto)
    {
        try
        {
            var supplier = await _supplierService.UpdateAsync(id, dto);
            if (supplier == null)
            {
                return NotFound(new { message = "Supplier not found" });
            }
            return Ok(supplier);
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An error occurred while updating the supplier", error = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        try
        {
            var result = await _supplierService.DeleteAsync(id);
            if (!result)
            {
                return NotFound(new { message = "Supplier not found" });
            }
            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (Exception ex)
        {
            return StatusCode(500, new { message = "An error occurred while deleting the supplier", error = ex.Message });
        }
    }
} 