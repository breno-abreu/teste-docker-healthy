using HealthyApi.Data;
using HealthyApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HealthyApi.Controllers;

[ApiController]
[Route("api/[controller]")]
public class HealthyController : ControllerBase
{
    private readonly HealthyDbContext _dbContext;

    public HealthyController(HealthyDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    [HttpGet("basic")]
    public IActionResult GetBasic()
    {
        return Ok(new
        {
            success = true,
            message = "API funcionando corretamente"
        });
    }

    [HttpGet("data")]
    public async Task<IActionResult> GetData()
    {
        var items = await _dbContext.HealtyItems
            .OrderBy(i => i.Id)
            .ToListAsync();

        return Ok(new
        {
            success = true,
            message = "Dados recuperados do banco com sucesso",
            data = items
        });
    }

    [HttpPost("data")]
    public async Task<IActionResult> PostData([FromBody] CreateHealtyItemRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Message))
        {
            return BadRequest(new { success = false, message = "O campo message é obrigatório" });
        }

        var item = new HealtyItem { Message = request.Message.Trim() };
        _dbContext.HealtyItems.Add(item);
        await _dbContext.SaveChangesAsync();

        return Ok(new
        {
            success = true,
            message = "Registro inserido com sucesso",
            data = item
        });
    }
}
