using authcloud.Validators;
using System.Security.Claims;

namespace AuthCloud.Validators
{
    public class ValidationService : IValidationService
    {
        private readonly IEnumerable<IClaimValidator> _validators;

        public ValidationService(IEnumerable<IClaimValidator> validators)
        {
            _validators = validators;
        }

        public bool Validate(ClaimsPrincipal claims)
        {
            foreach (var validator in _validators)
            {
                if (!validator.Validate(claims))
                {
                    return false;
                }
            }
            return true;
        }
    }

}
