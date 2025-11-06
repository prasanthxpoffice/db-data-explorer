using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.FileProviders;

var builder = WebApplication.CreateBuilder(args);

// Build connection string from environment if provided, else appsettings
string BuildConnString()
{
    var server = Environment.GetEnvironmentVariable("SQL_SERVER");
    var db = Environment.GetEnvironmentVariable("SQL_DATABASE");
    var trusted = (Environment.GetEnvironmentVariable("SQL_TRUSTED") ?? "true").ToLowerInvariant() == "true";
    var user = Environment.GetEnvironmentVariable("SQL_USER");
    var pwd = Environment.GetEnvironmentVariable("SQL_PASSWORD");
    var encrypt = (Environment.GetEnvironmentVariable("SQL_ENCRYPT") ?? "false").ToLowerInvariant() == "true";

    if (!string.IsNullOrWhiteSpace(server) && !string.IsNullOrWhiteSpace(db))
    {
        var csb = new SqlConnectionStringBuilder
        {
            DataSource = server,
            InitialCatalog = db,
            IntegratedSecurity = trusted,
            Encrypt = encrypt,
            TrustServerCertificate = !encrypt,
            ApplicationName = "db-data-explorer"
        };
        if (!trusted)
        {
            if (string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(pwd))
                throw new InvalidOperationException("SQL_TRUSTED=false but SQL_USER/SQL_PASSWORD not set.");
            csb.UserID = user;
            csb.Password = pwd;
        }
        return csb.ConnectionString;
    }
    return builder.Configuration.GetConnectionString("Default")!;
}

var connStr = BuildConnString();

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(p => p.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());
});

var app = builder.Build();

// Serve static files from repo root so existing index.html works
var repoRoot = Path.GetFullPath(Path.Combine(builder.Environment.ContentRootPath, ".."));
var staticProvider = new PhysicalFileProvider(repoRoot);
app.UseDefaultFiles(new DefaultFilesOptions { FileProvider = staticProvider });
app.UseStaticFiles(new StaticFileOptions { FileProvider = staticProvider });
// Explicit root mapping (helps in some hosting modes)
app.MapGet("/", () => Results.File(Path.Combine(repoRoot, "index.html"), "text/html"));
app.UseCors();

app.MapGet("/health", async () =>
{
    try
    {
        await using var c = new SqlConnection(connStr);
        await c.OpenAsync();
        await using var cmd = new SqlCommand("SELECT 1", c);
        await cmd.ExecuteScalarAsync();
        return Results.Json(new { ok = true });
    }
    catch (Exception ex)
    {
        return Results.Json(new { ok = false, error = ex.Message }, statusCode: 500);
    }
});

app.MapGet("/api/views", async (HttpRequest http) =>
{
    try
    {
        await using var c = new SqlConnection(connStr);
        await c.OpenAsync();
        const string sql = @"SELECT ViewID, ViewDescriptionEn, ViewDescriptionAr, ViewNameEn, ViewNameAr
                              FROM dbgraph.ViewRegistry
                              ORDER BY ViewID";
        await using var cmd = new SqlCommand(sql, c);
        await using var rdr = await cmd.ExecuteReaderAsync();
        var list = new List<Dictionary<string, object?>>();
        while (await rdr.ReadAsync())
        {
            list.Add(new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase)
            {
                ["id"] = rdr.GetInt32(0),
                ["descriptionEn"] = rdr.IsDBNull(1) ? null : rdr.GetString(1),
                ["descriptionAr"] = rdr.IsDBNull(2) ? null : rdr.GetString(2),
                ["nameEn"] = rdr.IsDBNull(3) ? null : rdr.GetString(3),
                ["nameAr"] = rdr.IsDBNull(4) ? null : rdr.GetString(4)
            });
        }
        return Results.Json(list);
    }
    catch (Exception ex)
    {
        return Results.Json(new { error = ex.Message }, statusCode: 500);
    }
});

app.MapPost("/api/traverseStepMulti", async (HttpRequest http) =>
{
    try
    {
        var payload = await http.ReadFromJsonAsync<Payload>() ?? new Payload();
        if (payload.Depth < 1) return Results.BadRequest(new { error = "`depth` must be >= 1" });

        await using var c = new SqlConnection(connStr);
        await c.OpenAsync();
        await using var cmd = new SqlCommand("dbgraph.TraverseStep_MultiViews_PerViewExclude_Lang", c)
        {
            CommandType = CommandType.StoredProcedure
        };

        cmd.Parameters.Add(new SqlParameter("@ViewIDs", SqlDbType.Structured)
        { TypeName = "dbgraph.IntList", Value = ToIntList(payload.ViewIds) });
        cmd.Parameters.Add(new SqlParameter("@Frontier", SqlDbType.Structured)
        { TypeName = "dbgraph.ColValPair", Value = ToColValPair(payload.Frontier) });
        cmd.Parameters.Add(new SqlParameter("@PerViewExclude", SqlDbType.Structured)
        { TypeName = "dbgraph.ViewColValPair", Value = ToViewColValPair(payload.PerViewExclude) });
        cmd.Parameters.Add(new SqlParameter("@Depth", SqlDbType.Int) { Value = payload.Depth });
        var lang = (payload.Lang ?? "en");
        cmd.Parameters.Add(new SqlParameter("@Lang", SqlDbType.NVarChar, 2) { Value = lang[..Math.Min(2, lang.Length)] });
        cmd.Parameters.Add(new SqlParameter("@MaxFanout", SqlDbType.Int) { Value = (object?)payload.MaxFanout ?? DBNull.Value });

        await using var rdr = await cmd.ExecuteReaderAsync();
        var edges = ReadRows(rdr);
        await rdr.NextResultAsync();
        var nextFrontier = ReadRows(rdr);
        return Results.Json(new { edges, nextFrontier });
    }
    catch (Exception ex)
    {
        return Results.Json(new { error = ex.Message }, statusCode: 500);
    }
});

// ---- Seed helper endpoints ----
// GET /api/seed/columns?viewIds=1,2&lang=en
app.MapGet("/api/seed/columns", async (HttpRequest http) =>
{
    try
    {
        var viewIds = ParseIntListFromQuery(http, "viewIds");
        var lang = (http.Query["lang"].ToString() ?? "en").Trim();
        var lang2 = lang[..Math.Min(2, lang.Length)];

        await using var c = new SqlConnection(connStr);
        await c.OpenAsync();
        await using var cmd = new SqlCommand("dbgraph.GetSeedColumns", c)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.Add(new SqlParameter("@ViewIDs", SqlDbType.Structured) { TypeName = "dbgraph.IntList", Value = ToIntList(viewIds) });
        cmd.Parameters.Add(new SqlParameter("@Lang", SqlDbType.NVarChar, 2) { Value = lang2 });

        var cols = new List<string>();
        await using var rdr = await cmd.ExecuteReaderAsync();
        while (await rdr.ReadAsync())
        {
            if (!rdr.IsDBNull(0)) cols.Add(rdr.GetString(0));
        }
        return Results.Json(cols.Distinct(StringComparer.OrdinalIgnoreCase).OrderBy(s => s).ToArray());
    }
    catch (Exception ex)
    {
        return Results.Json(new { error = ex.Message }, statusCode: 500);
    }
});

// GET /api/seed/values?col=ID_AID&term=jo&pageSize=25&after=...&viewIds=1,2&lang=en
app.MapGet("/api/seed/values", async (HttpRequest http) =>
{
    try
    {
        var col = (http.Query["col"].ToString() ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(col)) return Results.BadRequest(new { error = "Missing `col`" });
        var term = (http.Query["term"].ToString() ?? string.Empty).Trim();
        var after = http.Query["after"].ToString();
        var lang = (http.Query["lang"].ToString() ?? "en").Trim();
        var lang2 = lang[..Math.Min(2, lang.Length)];
        var pageSize = 25;
        if (int.TryParse(http.Query["pageSize"], out var ps)) pageSize = Math.Clamp(ps, 1, 200);
        var viewIds = ParseIntListFromQuery(http, "viewIds");

        await using var c = new SqlConnection(connStr);
        await c.OpenAsync();
        await using var cmd = new SqlCommand("dbgraph.GetSeedValues", c)
        {
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.Add(new SqlParameter("@Col", SqlDbType.NVarChar, 128) { Value = col });
        cmd.Parameters.Add(new SqlParameter("@Term", SqlDbType.NVarChar, 4000) { Value = term });
        cmd.Parameters.Add(new SqlParameter("@After", SqlDbType.NVarChar, 4000) { Value = string.IsNullOrEmpty(after) ? DBNull.Value : after });
        cmd.Parameters.Add(new SqlParameter("@PageSize", SqlDbType.Int) { Value = pageSize });
        cmd.Parameters.Add(new SqlParameter("@ViewIDs", SqlDbType.Structured) { TypeName = "dbgraph.IntList", Value = ToIntList(viewIds) });
        cmd.Parameters.Add(new SqlParameter("@Lang", SqlDbType.NVarChar, 2) { Value = lang2 });

        var list = new List<string>();
        await using var rdr = await cmd.ExecuteReaderAsync();
        while (await rdr.ReadAsync())
        {
            if (!rdr.IsDBNull(0)) list.Add(Convert.ToString(rdr.GetValue(0)) ?? "");
        }

        // The proc should return up to pageSize+1 rows; if we got more than pageSize, set next
        string? next = null;
        if (list.Count > pageSize)
        {
            next = list[^1];
            list.RemoveAt(list.Count - 1);
        }
        return Results.Json(new { items = list, next });
    }
    catch (Exception ex)
    {
        return Results.Json(new { error = ex.Message }, statusCode: 500);
    }
});

var port = Environment.GetEnvironmentVariable("PORT");
if (!string.IsNullOrWhiteSpace(port))
{
    app.Urls.Add($"http://localhost:{port}");
}

app.Run();

static List<int> ParseIntListFromQuery(HttpRequest http, string key)
{
    var vals = new List<int>();
    var raw = http.Query[key].ToString();
    if (!string.IsNullOrWhiteSpace(raw))
    {
        foreach (var part in raw.Split(new[] { ',', ' ', ';' }, StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            if (int.TryParse(part, out var v)) vals.Add(v);
    }
    // also support repeated query keys ?key=1&key=2
    foreach (var q in http.Query[key])
    {
        if (int.TryParse(q, out var v)) vals.Add(v);
    }
    return vals.Distinct().ToList();
}

static DataTable ToIntList(IEnumerable<int>? ids)
{
    var t = new DataTable();
    t.Columns.Add("id", typeof(int));
    foreach (var v in ids ?? Array.Empty<int>()) t.Rows.Add(v);
    return t;
}

static DataTable ToColValPair(IEnumerable<ColVal>? rows)
{
    var t = new DataTable();
    t.Columns.Add("col", typeof(string));
    t.Columns.Add("val", typeof(string));
    foreach (var r in rows ?? Array.Empty<ColVal>())
    {
        var col = (r.col ?? string.Empty).Trim();
        var val = (r.val ?? string.Empty).ToString();
        if (string.IsNullOrWhiteSpace(col)) continue;
        t.Rows.Add(col, val);
    }
    return t;
}

static DataTable ToViewColValPair(IEnumerable<ViewColVal>? rows)
{
    var t = new DataTable();
    t.Columns.Add("ViewID", typeof(int));
    t.Columns.Add("col", typeof(string));
    t.Columns.Add("val", typeof(string));
    var seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
    foreach (var r in rows ?? Array.Empty<ViewColVal>())
    {
        if (!r.ViewID.HasValue) continue;
        var col = (r.col ?? string.Empty).Trim();
        if (string.IsNullOrWhiteSpace(col)) continue;
        var val = (r.val ?? string.Empty).ToString();
        var key = $"{r.ViewID.Value}|{col}|{val}";
        if (seen.Contains(key)) continue;
        seen.Add(key);
        t.Rows.Add(r.ViewID.Value, col, val);
    }
    return t;
}

static List<Dictionary<string, object?>> ReadRows(SqlDataReader rdr)
{
    var list = new List<Dictionary<string, object?>>();
    while (rdr.Read())
    {
        var row = new Dictionary<string, object?>(StringComparer.OrdinalIgnoreCase);
        for (int i = 0; i < rdr.FieldCount; i++)
            row[rdr.GetName(i)] = rdr.IsDBNull(i) ? null : rdr.GetValue(i);
        list.Add(row);
    }
    return list;
}

public sealed record Payload
{
    public List<int>? ViewIds { get; set; }
    public List<ColVal>? Frontier { get; set; }
    public List<ViewColVal>? PerViewExclude { get; set; }
    public int Depth { get; set; } = 1;
    public string? Lang { get; set; }
    public int? MaxFanout { get; set; }
}

public sealed record ColVal(string col, object? val);
public sealed record ViewColVal(int? ViewID, string col, object? val);
