using System.Security.Claims;

namespace AuthCloud.Validators
{
    public interface IClaimValidator
    {
        bool Validate(ClaimsPrincipal claims);
    }
}

