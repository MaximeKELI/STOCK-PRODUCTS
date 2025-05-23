using StockLandyApi.DTOs;

namespace StockLandyApi.Services;

public interface IAuthService
{
    Task<AuthResponseDto> LoginAsync(LoginDto loginDto);
    Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto);
    Task<bool> ValidateTokenAsync(string token);
} 