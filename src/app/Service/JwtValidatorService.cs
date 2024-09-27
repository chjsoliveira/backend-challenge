using AuthCloud.Validators;
using AuthCloud.Validators;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace AuthCloud.Service
{
    public class JwtValidatorService
    {
        private readonly ValidationService _validationService;

        public JwtValidatorService(ValidationService validationService)
        {
            _validationService = validationService;
        }

        public bool ValidateJwt(string token)
        {
            try
            {
                var handler = new JwtSecurityTokenHandler();
                if (!handler.CanReadToken(token))
                    return false;

                var jwtToken = handler.ReadJwtToken(token);
                var claimsIdentity = new ClaimsIdentity(jwtToken.Claims, "jwt");
                var claimsPrincipal = new ClaimsPrincipal(claimsIdentity);

                return _validationService.Validate(claimsPrincipal);
            }
            catch (Exception ex)
            {
                // Log ou manipule a exceção conforme necessário
                Console.WriteLine($"Error validating token: {ex.Message}");
                return false;
            }
        }

    }
}

