namespace AuthCloud.Interface
{
    public interface IJwtValidatorService
    {
        bool ValidateJwt(string token);
    }
}
