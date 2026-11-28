
using Microsoft.AspNetCore.Mvc;
using Ag13.Api.Models;
using MySqlConnector;

namespace Ag13.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class UsuariosController : ControllerBase
{
private readonly MySqlConnection _conexion;
   public UsuariosController(MySqlConnection conexion)
   {
   _conexion = conexion;
   }
    // Consultar todos
    [HttpGet]
    public async Task<IActionResult> ObtenerUsuarios()
    {
        await _conexion.OpenAsync();
        using var comando = new MySqlCommand("SELECT * FROM usuarios", _conexion);

        using var lector = await comando.ExecuteReaderAsync();
        var usuarios = new List<Usuario>();

        while (await lector.ReadAsync())
        {
        usuarios.Add(new Usuario
        {
        Id = lector.GetInt32(lector.GetOrdinal("id")),
        ApellidoPaterno = lector.GetString(lector.GetOrdinal("apellido_paterno")),
         ApellidoMaterno = lector.GetString(lector.GetOrdinal("apellido_materno")),
          Telefono = lector.GetString(lector.GetOrdinal("telefono")),
           Correo = lector.GetString(lector.GetOrdinal("correo")),
            NumeroControl = lector.GetString(lector.GetOrdinal("numero_control"))
            });
            }
            return Ok(usuarios);
   }

    // Consultar por ID
    [HttpGet("{id}")]
    public async Task<IActionResult>ObtenerUsuario(int id)
    {
      await _conexion.OpenAsync();
      using var comando = new MySqlCommand ("SELECT * FROM usuarios WHERE id = @id",
      _conexion);

      comando.Parameters.AddWithValue("@id", id);
      using var lector = await comando.ExecuteReaderAsync();
      if (!await lector.ReadAsync())
      {
      return NotFound(new { mensaje = "Usuario no encontrado"});
      }
      var usuario = new Usuario
      {
      Id = lector.GetInt32(lector.GetOrdinal("id")),
         ApellidoPaterno = lector.GetString(lector.GetOrdinal("apellido_paterno")),
         ApellidoMaterno = lector.GetString(lector.GetOrdinal("apellido_materno")),
         Telefono = lector.GetString(lector.GetOrdinal("telefono")),
           Correo = lector.GetString(lector.GetOrdinal("correo")),
            NumeroControl = lector.GetString(lector.GetOrdinal("numero_control"))
            };
        return Ok(usuario);
    }

    // Buscar por apellidos o número de control
    [HttpGet("buscar")]
    public async Task<IActionResult>BuscarUsuarios([FromQuery] string termino)
    {
    if (string.IsNullOrWhiteSpace(termino))
    return BadRequest(new {mensaje = "Escribe un término de búsqueda"});
     await _conexion.OpenAsync();
     using var comando = new MySqlCommand (@"SELECT * FROM usuarios WHERE apellido_paterno LIKE @busqueda OR apellido_materno LIKE 
     @busqueda OR numero_control LIKE
     @busqueda", _conexion);
 
       comando.Parameters.AddWithValue("@busqueda", $"%{termino}%");
       using var lector = await comando.ExecuteReaderAsync();
       var resultados = new List<Usuario>();
       while (await lector.ReadAsync())
       {
       resultados.Add(new Usuario
       {
        Id = lector.GetInt32(lector.GetOrdinal("id")),
         ApellidoPaterno = lector.GetString(lector.GetOrdinal("apellido_paterno")),
         ApellidoMaterno = lector.GetString(lector.GetOrdinal("apellido_materno")),
         Telefono = lector.GetString(lector.GetOrdinal("telefono")),
           Correo = lector.GetString(lector.GetOrdinal("correo")),
            NumeroControl = lector.GetString(lector.GetOrdinal("numero_control"))
            });
            }
            return Ok(resultados);
            }

    // Registrar
    [HttpPost]
     public async Task<IActionResult>RegistrarUsuario(Usuario usuario)
    {    
    await _conexion.OpenAsync();
     using var verificar = new MySqlCommand ("SELECT COUNT(*) FROM usuarios WHERE numero_control = @control", _conexion);
    verificar.Parameters.AddWithValue("@control", usuario.NumeroControl);
    var cantidad= Convert.ToInt32(await verificar.ExecuteScalarAsync());

    if(cantidad > 0)
    return Conflict(new{ mensaje = "El numero de control ya existe" });
using var comando = new MySqlCommand (@"INSERT INTO usuarios(apellido_paterno, apellido_materno,telefono, correo, numero_control)
VALUES(@paterno, @materno, @telefono, @correo, @control)", _conexion);

comando.Parameters.AddWithValue("@paterno", usuario.ApellidoPaterno);
comando.Parameters.AddWithValue("@materno", usuario.ApellidoMaterno);
comando.Parameters.AddWithValue("@telefono", usuario.Telefono);
comando.Parameters.AddWithValue("@correo", usuario.Correo);
comando.Parameters.AddWithValue("@control", usuario.NumeroControl);
await comando.ExecuteNonQueryAsync();

usuario.Id = Convert.ToInt32(comando.LastInsertedId);
return CreatedAtAction(nameof(ObtenerUsuario),
new { id = usuario.Id},usuario);
}

    // Actualizar
    [HttpPut("{id}")]
    public async Task<IActionResult>ActualizarUsuario(int id, Usuario datos)
    {
     await _conexion.OpenAsync();
    using var verificarUsuario = new MySqlCommand("SELECT COUNT(*) FROM usuarios WHERE id = @id", _conexion);
    verificarUsuario.Parameters.AddWithValue("@id", id);

    var existe = Convert.ToInt32(await verificarUsuario.ExecuteScalarAsync());

    if (existe == 0)
    return NotFound(new{ mensaje = "Usuario no encontrado" });

    using var verificarControl = new MySqlCommand("SELECT COUNT(*) FROM usuarios WHERE numero_control = @control AND id <> @id",_conexion);
    verificarControl.Parameters.AddWithValue("@control", datos.NumeroControl);
    verificarControl.Parameters.AddWithValue("@id", id);

    var cantidad = Convert.ToInt32(await verificarControl.ExecuteScalarAsync());
    if (cantidad >0)
    return Conflict(new { mensaje = "El numero de control ya existe"});
       using var comando = new MySqlCommand(@"UPDATE usuarios SET apellido_paterno = @paterno, apellido_materno = @materno,
       telefono = @telefono, correo = @correo, numero_control = @control WHERE id = @id",
       _conexion);
       
    comando.Parameters.AddWithValue("@paterno", datos.ApellidoPaterno);
    comando.Parameters.AddWithValue("@materno", datos.ApellidoMaterno);
    comando.Parameters.AddWithValue("@telefono", datos.Telefono);
    comando.Parameters.AddWithValue("@correo", datos.Correo);
    comando.Parameters.AddWithValue("@control", datos.NumeroControl);
    comando.Parameters.AddWithValue("@id", id);
    await comando.ExecuteNonQueryAsync();
    datos.Id = id;
    return Ok(datos);
    }

    // Eliminar
    [HttpDelete("{id}")]
    public async Task<IActionResult>EliminarUsuario(int id)
    {
         await _conexion.OpenAsync();
         using var comando = new MySqlCommand("DELETE FROM usuarios WHERE id = @id",_conexion);
         comando.Parameters.AddWithValue("@id", id);
         int filasAfectadas = await comando.ExecuteNonQueryAsync();

         if(filasAfectadas ==0)
         return NotFound(new { mensaje = "Usuario no encontrado"});
         return Ok(new{mensaje = "Usuario eliminado correctamente"});
    }
}
