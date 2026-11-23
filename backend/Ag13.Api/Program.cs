
var builder = WebApplication.CreateBuilder(args);

// Servicios de la aplicación
builder.Services.AddOpenApi();
builder.Services.AddControllers();

var app = builder.Build();

// Configuración de la API
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();
app.MapControllers();
// Primera ruta de nuestra API
app.MapGet("/api", () =>
{
    return Results.Ok(new
    {
        aplicacion = "AG13 - API de Usuarios",
        mensaje = "El backend está funcionando correctamente",
        estado = "Activo"
    });
});

app.Run();
