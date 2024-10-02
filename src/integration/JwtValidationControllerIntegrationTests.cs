using authcloud.Integration;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using Xunit;

namespace AuthCloudApi.Tests.Integration
{
    public class JwtValidationControllerIntegrationTests : IClassFixture<CustomWebApplicationFactory<Program>>
    {
        private readonly HttpClient _client;

        public JwtValidationControllerIntegrationTests(CustomWebApplicationFactory<Program> factory)
        {
            _client = factory.WithWebHostBuilder(builder =>
            {}).CreateClient();
        }

        [Fact]
        public async Task ValidateJwt_ValidToken_ReturnsOk()
        {
            // Arrange
            var validToken = "eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiQWRtaW4iLCJTZWVkIjoiNzg0MSIsIk5hbWUiOiJUb25pbmhvIEFyYXVqbyJ9.QY05sIjtrcJnP533kQNk8QXcaleJ1Q01jWY_ZzIZuAg"; 

            // Act
            var response = await _client.PostAsync(
                "/api/jwtvalidation/validate",
                new StringContent($"\"{validToken}\"", Encoding.UTF8, "application/json")
            );

            // Assert
            response.EnsureSuccessStatusCode(); // Verifica se o status code é 2xx
            var isValid = await response.Content.ReadAsStringAsync();
            Assert.Equal("true", isValid); // Verifica se o retorno é "True"
        }

        [Fact]
        public async Task ValidateJwt_ValidToken_ReturnsNOk()
        {
            // Arrange
            var invalidToken = "eyJhbGciOiJzI1NiJ9.dfsdfsfryJSr2xrIjoiQWRtaW4iLCJTZrkIjoiNzg0MSIsIk5hbrUiOiJUb25pbmhvIEFyYXVqbyJ9.QY05fsdfsIjtrcJnP533kQNk8QXcaleJ1Q01jWY_ZzIZuAg"; 

            // Act
            var response = await _client.PostAsync(
                "/api/jwtvalidation/validate",
                new StringContent($"\"{invalidToken}\"", Encoding.UTF8, "application/json")
            );

            // Assert
            response.EnsureSuccessStatusCode(); // Verifica se o status code é 2xx
            var isValid = await response.Content.ReadAsStringAsync();
            Assert.Equal("false", isValid); // Verifica se o retorno é "false"
        }

        [Fact]
        public async Task ValidateJwt_EmptyToken_ReturnsBadRequest()
        {
            // Arrange
            var invalidToken = ""; // Token vazio

            // Act
            var response = await _client.PostAsync(
                "/api/jwtvalidation/validate",
                new StringContent($"\"{invalidToken}\"", Encoding.UTF8, "application/json")
            );

            // Assert
            Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode); // Verifica se o status code é 400
            var isValid = await response.Content.ReadAsStringAsync();
            Assert.Equal("false", isValid); // Certifique-se de que está de acordo com o retorno esperado
        }
    }
}
	