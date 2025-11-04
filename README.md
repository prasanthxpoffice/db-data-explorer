# db-data-explorer

A lightweight SQL Server (LocalDB) + HTML viewer + .NET API for exploring data relationships and rendering them as a graph in Cytoscape.js.

Supports multi-view traversal, multi-depth exploration, and English/Arabic labels. The front-end can run in mock mode (no backend) or call the API for live data.

---

## Project Structure

```
db-data-explorer/
├─ db/
│  ├─ export-bacpac.ps1     # Manual DB export (creates IAS.bacpac)
│  ├─ import-bacpac.ps1     # Manual DB import (restores IAS.bacpac)
│  ├─ resolve-sqlserver.ps1 # Picks a SQL Server (defaults to LocalDB)
│  ├─ IAS.bacpac            # BACPAC snapshot (committed)
│  └─ import-log.txt        # Import log (ignored by Git)
├─ server-dotnet/
│  ├─ Program.cs            # Minimal API (POST /api/traverseStepMulti)
│  └─ appsettings.json      # Default connection string + Urls
├─ index.html               # Front-end + Cytoscape.js (mock or API mode)
├─ db-import-bacpac.bat     # Windows import helper (SqlPackage)
├─ db-export-and-push.bat   # Windows export + git add/commit/push helper
├─ start-server.bat         # Starts server-dotnet backend
└─ .gitignore
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

1) Start the backend API (serves `index.html` too):

```
start-server.bat
```

or

```
cd server-dotnet
dotnet run
```

The API binds to `http://localhost:3000` (see `server-dotnet/appsettings.json`). Open `http://localhost:3000` in your browser.

2) Front-end modes:

- Mock mode: uses built-in sample graph (no DB required)
- API mode: posts to `POST /api/traverseStepMulti` on the .NET backend

Switch modes using the radio buttons in the left panel.

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

