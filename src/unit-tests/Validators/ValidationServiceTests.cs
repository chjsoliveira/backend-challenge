using AuthCloud.Validators;
using Moq;
using System.Collections.Generic;
using System.Security.Claims;
using Xunit;

namespace authcloud.UnitTests.Validators
{
    public class ValidationServiceTests
    {
        private readonly Mock<IClaimValidator> _mockValidator1;
        private readonly Mock<IClaimValidator> _mockValidator2;
        private readonly ValidationService _validationService;

        public ValidationServiceTests()
        {
            _mockValidator1 = new Mock<IClaimValidator>();
            _mockValidator2 = new Mock<IClaimValidator>();
            var validators = new List<IClaimValidator> { _mockValidator1.Object, _mockValidator2.Object };

            _validationService = new ValidationService(validators);
        }

        [Fact]
        public void Validate_ReturnsTrue_WhenAllValidatorsReturnTrue()
        {
            // Arrange
            var claimsPrincipal = new ClaimsPrincipal();

            _mockValidator1.Setup(v => v.Validate(claimsPrincipal)).Returns(true);
            _mockValidator2.Setup(v => v.Validate(claimsPrincipal)).Returns(true);

            // Act
            var result = _validationService.Validate(claimsPrincipal);

            // Assert
            Assert.True(result);
            _mockValidator1.Verify(v => v.Validate(claimsPrincipal), Times.Once);
            _mockValidator2.Verify(v => v.Validate(claimsPrincipal), Times.Once);
        }

        [Fact]
        public void Validate_ReturnsFalse_WhenAnyValidatorReturnsFalse()
        {
            // Arrange
            var claimsPrincipal = new ClaimsPrincipal();

            _mockValidator1.Setup(v => v.Validate(claimsPrincipal)).Returns(true);
            _mockValidator2.Setup(v => v.Validate(claimsPrincipal)).Returns(false);

            // Act
            var result = _validationService.Validate(claimsPrincipal);

            // Assert
            Assert.False(result);
            _mockValidator1.Verify(v => v.Validate(claimsPrincipal), Times.Once);
            _mockValidator2.Verify(v => v.Validate(claimsPrincipal), Times.Once);
        }

        [Fact]
        public void Validate_ReturnsTrue_WhenNoValidatorsAreProvided()
        {
            // Arrange
            var validationService = new ValidationService(new List<IClaimValidator>());
            var claimsPrincipal = new ClaimsPrincipal();

            // Act
            var result = validationService.Validate(claimsPrincipal);

            // Assert
            Assert.True(result); // Quando não há validadores, deve retornar true
        }
    }
}
