using System.Security.Claims;

namespace authcloud.Validators
{
    public interface IValidationService
    {
        bool Validate(ClaimsPrincipal claims);
    }
}
