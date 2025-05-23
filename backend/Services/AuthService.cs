using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using StockLandyApi.Data;
using StockLandyApi.DTOs;
using StockLandyApi.Models;
using BC = BCrypt.Net.BCrypt;

namespace StockLandyApi.Services;

public class AuthService : IAuthService
{
    private readonly ApplicationDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthService(ApplicationDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    public async Task<AuthResponseDto> LoginAsync(LoginDto loginDto)
    {
        if (loginDto.Strategy != "local")
        {
            throw new InvalidOperationException("Invalid authentication strategy");
        }

        var user = await _context.Users
            .FirstOrDefaultAsync(u => u.Email == loginDto.Email);

        if (user == null || !BC.Verify(loginDto.Password, user.PasswordHash))
        {
            throw new InvalidOperationException("Invalid email or password");
        }

        var token = GenerateJwtToken(user);
        var (iat, exp) = GetTokenTimestamps(token);

        return new AuthResponseDto
        {
            AccessToken = token,
            Authentication = new AuthenticationDto
            {
                Strategy = "jwt",
                Payload = new JwtPayloadDto
                {
                    Iat = iat,
                    Exp = exp,
                    Aud = "",
                    Sub = user.Id.ToString(),
                    Jti = Guid.NewGuid().ToString()
                }
            },
            User = new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName
            }
        };
    }

    public async Task<AuthResponseDto> RegisterAsync(RegisterDto registerDto)
    {
        if (await _context.Users.AnyAsync(u => u.Username == registerDto.Username))
        {
            throw new InvalidOperationException("Username already exists");
        }

        if (await _context.Users.AnyAsync(u => u.Email == registerDto.Email))
        {
            throw new InvalidOperationException("Email already exists");
        }

        var user = new User
        {
            Username = registerDto.Username,
            Email = registerDto.Email,
            PasswordHash = BC.HashPassword(registerDto.Password),
            FirstName = registerDto.FirstName,
            LastName = registerDto.LastName,
            CreatedAt = DateTime.UtcNow
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        var token = GenerateJwtToken(user);
        var (iat, exp) = GetTokenTimestamps(token);

        return new AuthResponseDto
        {
            AccessToken = token,
            Authentication = new AuthenticationDto
            {
                Strategy = "jwt",
                Payload = new JwtPayloadDto
                {
                    Iat = iat,
                    Exp = exp,
                    Aud = "",
                    Sub = user.Id.ToString(),
                    Jti = Guid.NewGuid().ToString()
                }
            },
            User = new UserDto
            {
                Id = user.Id,
                Username = user.Username,
                Email = user.Email,
                FirstName = user.FirstName,
                LastName = user.LastName
            }
        };
    }

    public Task<bool> ValidateTokenAsync(string token)
    {
        try
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key not found"));
            
            tokenHandler.ValidateToken(token, new TokenValidationParameters
            {
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(key),
                ValidateIssuer = false,
                ValidateAudience = false,
                ClockSkew = TimeSpan.Zero
            }, out _);

            return Task.FromResult(true);
        }
        catch
        {
            return Task.FromResult(false);
        }
    }

    private string GenerateJwtToken(User user)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Key"] ?? throw new InvalidOperationException("JWT Key not found"));
        
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Name, user.Username),
                new Claim(ClaimTypes.Email, user.Email)
            }),
            Expires = DateTime.UtcNow.AddDays(7),
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };

        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }

    private (long iat, long exp) GetTokenTimestamps(string token)
    {
        var handler = new JwtSecurityTokenHandler();
        var jwtToken = handler.ReadJwtToken(token);
        
        var iat = ((DateTimeOffset)jwtToken.ValidFrom).ToUnixTimeSeconds();
        var exp = ((DateTimeOffset)jwtToken.ValidTo).ToUnixTimeSeconds();
        
        return (iat, exp);
    }
} 