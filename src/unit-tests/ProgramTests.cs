using AuthCloud.Interface;
using authcloud.Validators;
using AuthCloud.Validators;
using Xunit;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.DependencyInjection;

namespace authcloud.UnitTests
{
    public class ProgramTests : IClassFixture<WebApplicationFactory<Program>>
    {
        private readonly WebApplicationFactory<Program> _factory;

        public ProgramTests(WebApplicationFactory<Program> factory)
        {
            _factory = factory;
        }

        [Fact]
        public void Test_Service_Registration()
        {
            // Arrange
            using var scope = _factory.Services.CreateScope();
            var serviceProvider = scope.ServiceProvider;

            // Act
            var claimValidator = serviceProvider.GetService<IClaimValidator>();
            var validationService = serviceProvider.GetService<IValidationService>();
            var jwtValidatorService = serviceProvider.GetService<IJwtValidatorService>();

            // Assert
            Assert.NotNull(claimValidator);
            Assert.NotNull(validationService);
            Assert.NotNull(jwtValidatorService);
        }

        [Fact]
        public void Test_Endpoints()
        {
            // Arrange
            var client = _factory.CreateClient();

            // Act
            var response = client.GetAsync("/swagger").Result;

            // Assert
            response.EnsureSuccessStatusCode(); // Verifica se o status é 200 OK
        }
    }
}
