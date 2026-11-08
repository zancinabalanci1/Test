var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

// Preverjanje delovanja API-ja
app.MapGet("/", () => Results.Ok("Test API uspešno deluje!"));

// Health check
app.MapGet("/health", () => Results.Ok("Healthy"));

app.Run();
