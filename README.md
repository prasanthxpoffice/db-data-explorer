# db-data-explorer

A lightweight SQL Server (LocalDB) + HTML viewer + .NET API for exploring data relationships and rendering them as a graph in Cytoscape.js.

Supports multi-view traversal, multi-depth exploration, and English/Arabic labels. The front-end calls the API for live data.

---

## Project Structure

```
db-data-explorer/
  db/
  server-dotnet/
  index.html                 # Front-end + Cytoscape.js
  db-import-bacpac.bat       # Windows import helper (SqlPackage)
  db-export-and-push.bat     # Windows export + git add/commit/push helper
  start-app.bat              # Start server then open browser
  .gitignore
```

---

## Prerequisites

- Windows (for the .bat helpers; PowerShell scripts are cross-shell on Windows)
- .NET 8 SDK for the backend
- SQL Server LocalDB (installed with Visual Studio or as a component)
- SqlPackage (on PATH or installed in a common location)

Links: https://dotnet.microsoft.com/ and https://learn.microsoft.com/sql/tools/sqlpackage/sqlpackage-download

---

## Running

Recommended: start the app (server + browser) with one command

```
start-app.bat
```

- Uses `PORT` if set (defaults to 3000)
- Starts the .NET API, waits until reachable, then opens `http://localhost:%PORT%/`

Manual alternative:

```
cd server-dotnet
dotnet run
```

Then open `http://localhost:3000` (or your `PORT`) in the browser. The API also serves `index.html` from the repo root.

---

## Database Snapshot Workflow (BACPAC)

You commit the `db/IAS.bacpac` snapshot into Git. MDF/LDF are ignored.

Export on a machine that made DB changes:

```
db/export-bacpac.ps1
# or
db-export-and-push.bat
```

Import on another machine:

```
db/import-bacpac.ps1           # default server (LocalDB) and DB name (IAS)
# or with replace
db/import-bacpac.ps1 -Replace

# Batch alternative
db-import-bacpac.bat           # uses defaults
db-import-bacpac.bat \
  "(localdb)\\MSSQLLocalDB" IAS db\\IAS.bacpac /REPLACE

Schema-only updates (keep data):

```
db-publish-dacpac.bat                   # expects db/IAS.dacpac
# or specify a dacpac
db-publish-dacpac.bat "(localdb)\\MSSQLLocalDB" IAS db\\Your.dacpac
```
```

Both import helpers attempt to start LocalDB when available. The batch script writes a log to `db/import-log.txt`.

---

## Configuration

- Default connection string: `server-dotnet/appsettings.json`
- Environment overrides (optional):
  - `SQL_SERVER`, `SQL_DATABASE`
  - `SQL_TRUSTED` (true/false), `SQL_USER`, `SQL_PASSWORD`
  - `SQL_ENCRYPT` (true/false)
  - `PORT` (overrides port for the API)

---

## Notes

- `.gitignore` excludes `db/*.mdf`, `db/*.ldf`, classic backups, and `db/import-log.txt`.
- Scripts resolve `SqlPackage` from PATH or common install locations; if not found, they print a clear error.
- The API enables permissive CORS for development.

---

## Future Enhancements (optional)

- Auto-detect schema diffs
- Push BACPAC only for tagged releases
- Shared remote SQL DB option

