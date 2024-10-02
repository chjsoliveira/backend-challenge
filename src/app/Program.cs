using authcloud.Validators;
using AuthCloud.Interface;
using AuthCloud.Service;
using AuthCloud.Validators;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddScoped<IClaimValidator, JwtClaimsValidator>();
builder.Services.AddScoped<IValidationService, ValidationService>();
builder.Services.AddScoped<IJwtValidatorService, JwtValidatorService>();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "AuthCloud Validação Jwt", Version = "v1" });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "AuthCloud Validação V1");
    c.RoutePrefix = string.Empty;
});

// app.UseAuthorization();

app.MapControllers();

app.Run();

public partial class Program { }

