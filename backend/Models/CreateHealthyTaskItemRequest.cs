namespace HealthyApi.Models;

public class CreateHealthyTaskItemRequest
{
    public string Title { get; set; } = string.Empty;
    public string Notes { get; set; } = string.Empty;
}
