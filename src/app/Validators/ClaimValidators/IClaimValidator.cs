using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace AuthCloud.Validators
{
    public interface IClaimValidator
    {
        bool Validate(ClaimsPrincipal claims);
    }
}

