using authcloud.Validators;
using AuthCloud.Interface;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace AuthCloud.Service
{
    public class JwtValidatorService : IJwtValidatorService
    {
        private readonly IValidationService _validationService;

        public JwtValidatorService(IValidationService validationService)
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
                // Log ou manipule a exce��o conforme necess�rio
                Console.WriteLine($"Error validating token: {ex.Message}");
                return false;
            }
        }

    }
}

