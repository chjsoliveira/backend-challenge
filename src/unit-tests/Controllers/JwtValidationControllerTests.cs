using AuthCloud.Interface;
using AuthCloudApi.Controllers;
using Microsoft.AspNetCore.Mvc;
using Moq;
using Xunit;

namespace authcloud.UnitTests.Controllers
{
    public class JwtValidationControllerTests
    {
        private readonly JwtValidationController _controller;
        private readonly Mock<IJwtValidatorService> _mockJwtValidatorService;

        public JwtValidationControllerTests()
        {
            _mockJwtValidatorService = new Mock<IJwtValidatorService>();
            _controller = new JwtValidationController(_mockJwtValidatorService.Object);
        }

        [Fact]
        public void ValidateJwt_ValidToken_ReturnsOk()
        {
            // Arrange
            var validToken = "anyValidToken";
            _mockJwtValidatorService.Setup(service => service.ValidateJwt(validToken)).Returns(true);

            // Act
            var result = _controller.ValidateJwt(validToken) as OkObjectResult;

            // Assert
            Assert.NotNull(result); // Verifica se o resultado não é nulo
            Assert.Equal(200, result.StatusCode); // Verifica se o status code é 200
            Assert.True((bool)result.Value); // Verifica se o retorno é true
        }

        [Fact]
        public void ValidateJwt_ValidToken_ReturnsNOk()
        {
            // Arrange
            var invalidToken = "anyInvalidToken";
            _mockJwtValidatorService.Setup(service => service.ValidateJwt(invalidToken)).Returns(false);

            // Act
            var result = _controller.ValidateJwt(invalidToken) as OkObjectResult;

            // Assert
            Assert.NotNull(result); // Verifica se o resultado não é nulo
            Assert.Equal(200, result.StatusCode); // Verifica se o status code é 200
            Assert.False((bool)result.Value); // Verifica se o retorno é false
        }

        [Fact]
        public void ValidateJwt_EmptyToken_ReturnsBadRequest()
        {
            // Arrange
            var invalidToken = ""; // Token vazio

            // Act
            var result = _controller.ValidateJwt(invalidToken) as BadRequestObjectResult;

            // Assert
            Assert.NotNull(result); // Verifica se o resultado não é nulo
            Assert.Equal(400, result.StatusCode); // Verifica se o status code é 400
            Assert.False((bool)result.Value); // Verifica se o retorno é false
        }
    }
}
