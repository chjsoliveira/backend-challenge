using authcloud.Validators;
using AuthCloud.Service;
using Moq;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using Xunit;

namespace authcloud.UnitTests.Service
{
    public class JwtValidatorServiceTests
    {
        private readonly Mock<IValidationService> _mockValidationService;
        private readonly JwtValidatorService _jwtValidatorService;

        public JwtValidatorServiceTests()
        {
            _mockValidationService = new Mock<IValidationService>();
            _jwtValidatorService = new JwtValidatorService(_mockValidationService.Object);
        }

        [Fact]
        public void ValidateJwt_ReturnsFalse_WhenTokenIsInvalid()
        {
            // Arrange
            string invalidToken = "invalidToken";
            var handler = new JwtSecurityTokenHandler();

            // Act
            var result = _jwtValidatorService.ValidateJwt(invalidToken);

            // Assert
            Assert.False(result);
            _mockValidationService.Verify(v => v.Validate(It.IsAny<ClaimsPrincipal>()), Times.Never);
        }

        [Fact]
        public void ValidateJwt_ReturnsFalse_WhenTokenCannotBeRead()
        {
            // Arrange
            string unreadableToken = "unreadableToken";
            _mockValidationService.Setup(v => v.Validate(It.IsAny<ClaimsPrincipal>())).Returns(false);

            // Act
            var result = _jwtValidatorService.ValidateJwt(unreadableToken);

            // Assert
            Assert.False(result);
            _mockValidationService.Verify(v => v.Validate(It.IsAny<ClaimsPrincipal>()), Times.Never);
        }

        [Fact]
        public void ValidateJwt_ReturnsTrue_WhenValidationServiceReturnsTrue()
        {
            // Arrange
            var validToken = new JwtSecurityTokenHandler().WriteToken(new JwtSecurityToken());
            _mockValidationService.Setup(v => v.Validate(It.IsAny<ClaimsPrincipal>())).Returns(true);

            // Act
            var result = _jwtValidatorService.ValidateJwt(validToken);

            // Assert
            Assert.True(result);
            _mockValidationService.Verify(v => v.Validate(It.IsAny<ClaimsPrincipal>()), Times.Once);
        }

        [Fact]
        public void ValidateJwt_ReturnsFalse_WhenValidationServiceReturnsFalse()
        {
            // Arrange
            var validToken = new JwtSecurityTokenHandler().WriteToken(new JwtSecurityToken());
            _mockValidationService.Setup(v => v.Validate(It.IsAny<ClaimsPrincipal>())).Returns(false);

            // Act
            var result = _jwtValidatorService.ValidateJwt(validToken);

            // Assert
            Assert.False(result);
            _mockValidationService.Verify(v => v.Validate(It.IsAny<ClaimsPrincipal>()), Times.Once);
        }

        [Fact]
        public void ValidateJwt_ReturnsFalse_WhenExceptionIsThrown()
        {
            // Arrange
            var token = "anyToken";
            var handler = new JwtSecurityTokenHandler();

            // Faça o mock do Validate para lançar uma exceção
            _mockValidationService.Setup(v => v.Validate(It.IsAny<ClaimsPrincipal>()))
                .Throws(new Exception("Validation error"));

            // Use um token válido para que a leitura do token não falhe
            var jwtToken = new JwtSecurityToken();
            string validToken = handler.WriteToken(jwtToken);

            // Act
            var result = _jwtValidatorService.ValidateJwt(validToken);

            // Assert
            Assert.False(result);
            _mockValidationService.Verify(v => v.Validate(It.IsAny<ClaimsPrincipal>()), Times.Once);
        }
    }
}
