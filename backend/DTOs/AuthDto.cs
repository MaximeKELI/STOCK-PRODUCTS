namespace StockLandyApi.DTOs;

public class LoginDto
{
    public required string Email { get; set; }
    public required string Password { get; set; }
    public string Strategy { get; set; } = "local";
}

public class RegisterDto
{
    public required string Username { get; set; }
    public required string Email { get; set; }
    public required string Password { get; set; }
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
}

public class AuthResponseDto
{
    public string AccessToken { get; set; } = string.Empty;
    public AuthenticationDto Authentication { get; set; } = new();
    public UserDto User { get; set; } = new();
}

public class AuthenticationDto
{
    public string Strategy { get; set; } = "jwt";
    public JwtPayloadDto Payload { get; set; } = new();
}

public class JwtPayloadDto
{
    public long Iat { get; set; }
    public long Exp { get; set; }
    public string Aud { get; set; } = string.Empty;
    public string Sub { get; set; } = string.Empty;
    public string Jti { get; set; } = string.Empty;
}

public class UserDto
{
    public int Id { get; set; }
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string? FirstName { get; set; }
    public string? LastName { get; set; }
} 