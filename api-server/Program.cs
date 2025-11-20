using Microsoft.Data.SqlClient;
using StackExchange.Redis;
using System.Data;
using System.Text.Json;

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
    $"Encrypt=true;TrustServerCertificate={trustServerCertificate};Connect Timeout=300;";

// -------- Redis wiring (6 hours TTL) --------
string? redisConn = Environment.GetEnvironmentVariable("REDIS_CONNECTION");
if (string.IsNullOrWhiteSpace(redisConn))
{
    var pwd = Environment.GetEnvironmentVariable("WSHP_REDIS_PASSWORD");
    if (!string.IsNullOrEmpty(pwd))
        redisConn = $"redis:6379,password={pwd},abortConnect=false";
}

ConnectionMultiplexer? redis = null;
IDatabase? cache = null;
TimeSpan cacheTtl = TimeSpan.FromHours(6);

try
{
    if (!string.IsNullOrWhiteSpace(redisConn))
    {
        redis = await ConnectionMultiplexer.ConnectAsync(redisConn);
        cache = redis.GetDatabase();
        app.Logger.LogInformation("Redis cache enabled.");
    }
    else
    {
        app.Logger.LogWarning("Redis cache DISABLED (no REDIS_CONNECTION or WSHP_REDIS_PASSWORD).");
    }
}
catch (Exception ex)
{
    app.Logger.LogError(ex, "Redis connection failed. Continuing without cache.");
}

var jsonOptions = new JsonSerializerOptions { PropertyNamingPolicy = JsonNamingPolicy.CamelCase };

app.MapGet("/", () => Results.Text("Welcome to the server!"));

app.MapGet("/api/products", async () =>
{
    // Try cache first
    if (cache is not null)
    {
        var cached = await cache.StringGetAsync("products:all:v1");
        if (cached.HasValue)
            return Results.Content(cached!, "application/json");
    }

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

        var json = JsonSerializer.Serialize(list, jsonOptions);

        // Write to Redis if available
        if (cache is not null)
            _ = cache.StringSetAsync("products:all:v1", json, cacheTtl);

        return Results.Content(json, "application/json");
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
