using Microsoft.Data.SqlClient;
using System.Data;

var builder = WebApplication.CreateBuilder(args);

// CORS (open by default — adjust for prod)
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy => policy
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader());
});

var app = builder.Build();
app.UseCors();

// Read env vars with sane defaults for local compose
string GetEnv(string key, string fallback) => Environment.GetEnvironmentVariable(key) ?? fallback;

string dbHost = GetEnv("DB_HOST", "sqlserver");
string dbUser = GetEnv("DB_USER", "cash100m");
string dbPassword = GetEnv("DB_USER_PASSWORD", "S0f1a^2025_Data!1");
string dbName = GetEnv("DB_NAME", "mydb");
string trustServerCertificate = GetEnv("DB_TRUST_SERVER_CERT", "true");

// Encrypt on; trust server cert for local network
string connectionString =
    $"Server={dbHost},1433;User ID={dbUser};Password={dbPassword};Database={dbName};" +
    $"Encrypt=true;TrustServerCertificate={trustServerCertificate};";

// GET /
app.MapGet("/", () => Results.Text("Welcome to the server!"));

// GET /api/products  -> mirrors your Express route
app.MapGet("/api/products", async () =>
{
    try
    {
        var list = new List<Product>();
        await using var conn = new SqlConnection(connectionString);
        await conn.OpenAsync();

        await using var cmd = new SqlCommand(
            "SELECT id, name, price FROM dbo.products ORDER BY id", conn);

        using var reader = await cmd.ExecuteReaderAsync(CommandBehavior.CloseConnection);
        while (await reader.ReadAsync())
        {
            list.Add(new Product(
                reader.GetInt32(0),
                reader.GetString(1),
                reader.GetDecimal(2)
            ));
        }

        return Results.Json(list);
    }
    catch (Exception ex)
    {
        return Results.Problem(
            title: "Error querying the database",
            detail: ex.Message,
            statusCode: 500);
    }
});

app.Run();

public record Product(int Id, string Name, decimal Price);
