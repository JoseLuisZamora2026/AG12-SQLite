namespace Ag13.Api.Models;

public class Usuario
{
    public int Id { get; set; }

    public string ApellidoPaterno { get; set; } = string.Empty;

    public string ApellidoMaterno { get; set; } = string.Empty;

    public string Telefono { get; set; } = string.Empty;

    public string Correo { get; set; } = string.Empty;

    public string NumeroControl { get; set; } = string.Empty;
}