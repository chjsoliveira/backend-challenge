using AuthCloud.Validators;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace authcloud.UnitTests.Validators.ClaimValidators
{
    public class JwtClaimsValidatorTests
    {
        private readonly JwtClaimsValidator _jwtClaimsValidator;

        public JwtClaimsValidatorTests()
        {
            _jwtClaimsValidator = new JwtClaimsValidator();
        }

        [Fact]
        public void Validate_ReturnsTrue_WhenAllClaimsAreValid()
        {
            // Arrange
            var claims = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim("Name", "ValidName"),
                new Claim("Role", "Admin"),
                new Claim("Seed", "5") // 5 é um número primo
            }));

            // Act
            var result = _jwtClaimsValidator.Validate(claims);

            // Assert
            Assert.True(result);
        }

        [Fact]
        public void Validate_ReturnsFalse_WhenNameClaimIsInvalid()
        {
            // Arrange
            var claims = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim("Name", "Invalid123"), // Nome contém dígitos
                new Claim("Role", "Admin"),
                new Claim("Seed", "5")
            }));

            // Act
            var result = _jwtClaimsValidator.Validate(claims);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void Validate_ReturnsFalse_WhenRoleClaimIsInvalid()
        {
            // Arrange
            var claims = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim("Name", "ValidName"),
                new Claim("Role", "InvalidRole"), // Cargo inválido
                new Claim("Seed", "5")
            }));

            // Act
            var result = _jwtClaimsValidator.Validate(claims);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void Validate_ReturnsFalse_WhenSeedClaimIsInvalid()
        {
            // Arrange
            var claims = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim("Name", "ValidName"),
                new Claim("Role", "Admin"),
                new Claim("Seed", "4") // 4 não é um número primo
            }));

            // Act
            var result = _jwtClaimsValidator.Validate(claims);

            // Assert
            Assert.False(result);
        }

        [Fact]
        public void Validate_ReturnsFalse_WhenSeedClaimCannotBeParsedToInt()
        {
            // Arrange
            var claims = new ClaimsPrincipal(new ClaimsIdentity(new[]
            {
                new Claim("Name", "ValidName"),
                new Claim("Role", "Admin"),
                new Claim("Seed", "NotANumber") // Seed não é um número válido
            }));

            // Act
            var result = _jwtClaimsValidator.Validate(claims);

            // Assert
            Assert.False(result);
        }
    }
}
