using System.Security.Claims;

namespace AuthCloud.Validators
{

    public class JwtClaimsValidator : IClaimValidator
    {
        public bool Validate(ClaimsPrincipal claims)
        {
            // Valida a claim "Name"
            if (!IsValidNameClaim(claims.FindFirst("Name")))
                return false;

            // Valida a claim "Role"
            if (!IsValidRoleClaim(claims.FindFirst("Role")))
                return false;

            // Valida a claim "Seed"
            if (!IsValidSeedClaim(claims.FindFirst("Seed")))
                return false;

            // Se todas as validações passaram, retorna true
            return true;
        }

        private bool IsValidNameClaim(Claim nameClaim)
        {
            // Valida se a claim existe, se tem o tamanho correto e se não contém dígitos
            return nameClaim != null &&
                   nameClaim.Value.Length <= 256 &&
                   !nameClaim.Value.Any(char.IsDigit);
        }

        private bool IsValidRoleClaim(Claim roleClaim)
        {
            // Valida se a claim existe e se é um dos valores válidos
            var validRoles = new[] { "Admin", "Member", "External" };
            return roleClaim != null && validRoles.Contains(roleClaim.Value);
        }

        private bool IsValidSeedClaim(Claim seedClaim)
        {
            // Valida se a claim existe, se pode ser convertida para inteiro e se é um número primo
            if (seedClaim == null || !int.TryParse(seedClaim.Value, out int seed))
                return false;

            return IsPrime(seed);
        }

        private bool IsPrime(int number)
        {
            // Valida se um número é primo
            if (number <= 1) return false;
            for (int i = 2; i <= Math.Sqrt(number); i++)
            {
                if (number % i == 0) return false;
            }
            return true;
        }
    }


}
