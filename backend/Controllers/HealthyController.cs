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

    [HttpGet("backend-update")]
    public IActionResult GetBackendUpdate()
    {
        return Ok(new
        {
            success = true,
            message = "ALERTA! O backend foi atualizado com sucesso no servidor."
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

        var item = new HealtyItem
        {
            Message = request.Message.Trim(),
            Category = string.IsNullOrWhiteSpace(request.Category)
                ? "Geral"
                : request.Category.Trim()
        };
        _dbContext.HealtyItems.Add(item);
        await _dbContext.SaveChangesAsync();

        return Ok(new
        {
            success = true,
            message = "Registro inserido com sucesso",
            data = item
        });
    }

    [HttpGet("tasks")]
    public async Task<IActionResult> GetTasks()
    {
        var items = await _dbContext.HealthyTaskItems
            .OrderBy(i => i.Id)
            .ToListAsync();

        return Ok(new
        {
            success = true,
            message = "Dados da nova tabela recuperados com sucesso",
            data = items
        });
    }

    [HttpPost("tasks")]
    public async Task<IActionResult> PostTask([FromBody] CreateHealthyTaskItemRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Title))
        {
            return BadRequest(new { success = false, message = "O campo title é obrigatório" });
        }

        var item = new HealthyTaskItem
        {
            Title = request.Title.Trim(),
            Notes = string.IsNullOrWhiteSpace(request.Notes)
                ? "Sem observações"
                : request.Notes.Trim()
        };

        _dbContext.HealthyTaskItems.Add(item);
        await _dbContext.SaveChangesAsync();

        return Ok(new
        {
            success = true,
            message = "Item da nova tabela inserido com sucesso",
            data = item
        });
    }
}
