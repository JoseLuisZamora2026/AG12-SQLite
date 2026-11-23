
using Microsoft.AspNetCore.Mvc;
using Ag13.Api.Models;

namespace Ag13.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsuariosController : ControllerBase
{
    private static readonly List<Usuario> usuarios = new();
    private static int siguienteId = 1;

    // Consultar todos
    [HttpGet]
    public IActionResult ObtenerUsuarios()
    {
        return Ok(usuarios);
    }

    // Consultar por ID
    [HttpGet("{id}")]
    public IActionResult ObtenerUsuario(int id)
    {
        var usuario = usuarios.FirstOrDefault(u => u.Id == id);

        if (usuario == null)
            return NotFound(new { mensaje = "Usuario no encontrado" });

        return Ok(usuario);
    }

    // Buscar por apellidos o número de control
    [HttpGet("buscar")]
    public IActionResult BuscarUsuarios([FromQuery] string termino)
    {
        var resultados = usuarios.Where(u =>
            u.ApellidoPaterno.Contains(termino, StringComparison.OrdinalIgnoreCase) ||
            u.ApellidoMaterno.Contains(termino, StringComparison.OrdinalIgnoreCase) ||
            u.NumeroControl.Contains(termino, StringComparison.OrdinalIgnoreCase)
        ).ToList();

        return Ok(resultados);
    }

    // Registrar
    [HttpPost]
    public IActionResult RegistrarUsuario(Usuario usuario)
    {
        if (usuarios.Any(u => u.NumeroControl == usuario.NumeroControl))
            return Conflict(new { mensaje = "El número de control ya existe" });

        usuario.Id = siguienteId++;
        usuarios.Add(usuario);

        return CreatedAtAction(nameof(ObtenerUsuario),
            new { id = usuario.Id }, usuario);
    }

    // Actualizar
    [HttpPut("{id}")]
    public IActionResult ActualizarUsuario(int id, Usuario datos)
    {
        var usuario = usuarios.FirstOrDefault(u => u.Id == id);

        if (usuario == null)
            return NotFound(new { mensaje = "Usuario no encontrado" });

        if (usuarios.Any(u => u.Id != id &&
            u.NumeroControl == datos.NumeroControl))
            return Conflict(new { mensaje = "El número de control ya existe" });

        usuario.ApellidoPaterno = datos.ApellidoPaterno;
        usuario.ApellidoMaterno = datos.ApellidoMaterno;
        usuario.Telefono = datos.Telefono;
        usuario.Correo = datos.Correo;
        usuario.NumeroControl = datos.NumeroControl;

        return Ok(usuario);
    }

    // Eliminar
    [HttpDelete("{id}")]
    public IActionResult EliminarUsuario(int id)
    {
        var usuario = usuarios.FirstOrDefault(u => u.Id == id);

        if (usuario == null)
            return NotFound(new { mensaje = "Usuario no encontrado" });

        usuarios.Remove(usuario);

        return Ok(new { mensaje = "Usuario eliminado correctamente" });
    }
}
