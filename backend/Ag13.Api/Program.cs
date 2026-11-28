using MySqlConnector;
var builder = WebApplication.CreateBuilder(args);

// Servicios de la aplicación
builder.Services.AddOpenApi();
builder.Services.AddControllers();
builder.Services.AddCors(options =>{
options.AddPolicy("FlutterDev", policy =>{
policy.SetIsOriginAllowed(origin=>
{
var uri = new Uri(origin);
return uri.Host == "localhost" || uri.Host == "127.0.0.1";
})
.AllowAnyHeader()
.AllowAnyMethod();
});
});
builder.Services.AddScoped<MySqlConnection>(_=>

{
var conexion = builder.Configuration.GetConnectionString("MySql");

if 
(string.IsNullOrWhiteSpace(conexion))
{
throw new InvalidOperationException("Falta configurar la conexion a MySQL.");
}
return new 
MySqlConnection(conexion);
});
var app = builder.Build();
app.UseCors("FlutterDev");

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
