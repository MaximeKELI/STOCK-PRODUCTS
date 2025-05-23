using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using StockLandyApi.DTOs;
using StockLandyApi.Services;

namespace StockLandyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
[Authorize]
public class ProductController : ControllerBase
{
    private readonly IProductService _productService;

    public ProductController(IProductService productService)
    {
        _productService = productService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<ProductDto>>> GetAll()
    {
        var products = await _productService.GetAllAsync();
        return Ok(products);
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<ProductDto>> GetById(int id)
    {
        var product = await _productService.GetByIdAsync(id);
        if (product == null)
            return NotFound();
        return Ok(product);
    }

    [HttpPost]
    public async Task<ActionResult<ProductDto>> Create(CreateProductDto createProductDto)
    {
        try
        {
            var product = await _productService.CreateAsync(createProductDto);
            return CreatedAtAction(nameof(GetById), new { id = product.Id }, product);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPut("{id}")]
    public async Task<ActionResult<ProductDto>> Update(int id, UpdateProductDto updateProductDto)
    {
        try
        {
            var product = await _productService.UpdateAsync(id, updateProductDto);
            if (product == null)
                return NotFound();
            return Ok(product);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpDelete("{id}")]
    public async Task<ActionResult> Delete(int id)
    {
        var result = await _productService.DeleteAsync(id);
        if (!result)
            return NotFound();
        return NoContent();
    }

    [HttpGet("sku/{sku}")]
    public async Task<ActionResult<ProductDto>> GetBySku(string sku)
    {
        var product = await _productService.GetBySkuAsync(sku);
        if (product == null)
            return NotFound();
        return Ok(product);
    }

    [HttpGet("barcode/{barcode}")]
    public async Task<ActionResult<ProductDto>> GetByBarcode(string barcode)
    {
        var product = await _productService.GetByBarcodeAsync(barcode);
        if (product == null)
            return NotFound();
        return Ok(product);
    }

    [HttpGet("search")]
    public async Task<ActionResult<ProductSearchResultDto>> Search([FromQuery] ProductSearchDto searchDto)
    {
        var result = await _productService.SearchAsync(searchDto);
        return Ok(result);
    }

    [HttpGet("low-stock")]
    public async Task<ActionResult<IEnumerable<ProductDto>>> GetLowStockProducts()
    {
        var products = await _productService.GetLowStockProductsAsync();
        return Ok(products);
    }

    [HttpGet("statistics")]
    public async Task<ActionResult<ProductStatisticsDto>> GetStatistics()
    {
        var statistics = await _productService.GetStatisticsAsync();
        return Ok(statistics);
    }
} 