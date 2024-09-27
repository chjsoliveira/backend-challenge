﻿using AuthCloud.Service;
using Microsoft.AspNetCore.Mvc;

namespace AuthCloudApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JwtValidationController : ControllerBase
    {
        private readonly JwtValidatorService _jwtValidatorService;

        public JwtValidationController(JwtValidatorService jwtValidatorService)
        {
            _jwtValidatorService = jwtValidatorService;
        }

        [HttpPost("validate")]
        public IActionResult ValidateJwt([FromBody] string token)
        {
            if (string.IsNullOrEmpty(token))
                return BadRequest(false); 

            var isValid = _jwtValidatorService.ValidateJwt(token);
            return Ok(isValid); 
        }
    }
}
