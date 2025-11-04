// server/server.js
// Minimal API for db-data-explorer
// - GET  /health
// - POST /api/traverseStepMulti  -> calls dbgraph.TraverseStep_MultiViews_PerViewExclude_Lang
//
// .env (in server/ or project root):
//   SQL_SERVER=(localdb)\MSSQLLocalDB
//   SQL_DATABASE=IAS
//   SQL_TRUSTED=true
//   SQL_USER=            # only if SQL_TRUSTED=false
//   SQL_PASSWORD=        # only if SQL_TRUSTED=false
//   SQL_ENCRYPT=false
//   PORT=3000

const path = require('path');
const dotenv = require('dotenv');
// Load env from project root then allow server/.env to override
dotenv.config({ path: path.resolve(__dirname, '..', '.env') });
dotenv.config({ path: path.resolve(__dirname, '.env') });
// Also respect actual environment variables provided by the host
const express = require('express');
const cors = require('cors');

const {
  SQL_SERVER = '(localdb)\\MSSQLLocalDB',
  SQL_DATABASE = 'IAS',
  SQL_TRUSTED = 'true',
  SQL_USER,
  SQL_PASSWORD,
  SQL_ENCRYPT = 'false',
  PORT = 3000,
} = process.env;

const useTrusted = String(SQL_TRUSTED).toLowerCase() === 'true';
const encrypt = String(SQL_ENCRYPT).toLowerCase() === 'true';
const isLocalDb = /^\(localdb\)\\/i.test(String(SQL_SERVER));

let sqlConfig;
let chosenDriver = 'tedious';
let chosenOdbcDriver = '';

// Prefer msnodesqlv8 for LocalDB or when using Trusted auth on Windows
if (isLocalDb) {
  try {
    require.resolve('msnodesqlv8');
    chosenDriver = 'msnodesqlv8';
  } catch (e) {
    console.warn('[config] Detected LocalDB but msnodesqlv8 is not installed.');
    console.warn('         Install it: cd server && npm i msnodesqlv8');
  }
}

// Require mssql with the correct driver wrapper
let sql;
if (chosenDriver === 'msnodesqlv8') {
  try {
    sql = require('mssql/msnodesqlv8');
  } catch (e) {
    // Fallback to base driver if wrapper not available (should not happen since msnodesqlv8 is installed)
    sql = require('mssql');
  }
} else {
  sql = require('mssql');
}

if (chosenDriver === 'msnodesqlv8') {
  const odbcDriver = process.env.SQL_ODBC_DRIVER || 'ODBC Driver 18 for SQL Server';
  chosenOdbcDriver = odbcDriver;
  let connectionString = `Driver={${odbcDriver}};Server=${SQL_SERVER};Database=${SQL_DATABASE};`;
  if (useTrusted) {
    connectionString += 'Trusted_Connection=yes;';
  } else {
    if (!SQL_USER || !SQL_PASSWORD) {
      console.error('[config] SQL_TRUSTED=false but SQL_USER/SQL_PASSWORD not set.');
      process.exit(1);
    }
    connectionString += `Uid=${SQL_USER};Pwd=${SQL_PASSWORD};`;
  }
  connectionString += `Encrypt=${encrypt ? 'yes' : 'no'};`;

  sqlConfig = {
    driver: 'msnodesqlv8',
    connectionString,
    pool: { max: 10, min: 0, idleTimeoutMillis: 30000 },
  };
} else {
  // Default to tedious (TCP) for non-LocalDB
  sqlConfig = {
    server: SQL_SERVER,
    database: SQL_DATABASE,
    options: {
      encrypt,
      trustServerCertificate: !encrypt,
      enableArithAbort: true,
      appName: 'db-data-explorer',
    },
    pool: { max: 10, min: 0, idleTimeoutMillis: 30000 },
  };
  if (!useTrusted) {
    if (!SQL_USER || !SQL_PASSWORD) {
      console.error('[config] SQL_TRUSTED=false but SQL_USER/SQL_PASSWORD not set.');
      process.exit(1);
    }
    sqlConfig.user = SQL_USER;
    sqlConfig.password = SQL_PASSWORD;
  }
}

const app = express();
app.use(cors());
app.use(express.json({ limit: '1mb' }));

// Serve static frontend from repo root (index.html lives in project root)
const staticRoot = path.join(__dirname, '..');
app.use(express.static(staticRoot));
app.get('/', (req, res) => res.sendFile(path.join(staticRoot, 'index.html')));

// ---------- TVP builders (must match SQL types exactly) ----------
function buildIntListTVP(viewIds = []) {
  // SQL type: dbgraph.IntList (id INT)
  const t = new sql.Table('dbgraph.IntList');
  t.create = false; // TVP, not creating a temp table
  t.columns.add('id', sql.Int, { nullable: false });
  for (const v of viewIds) {
    const n = Number(v);
    if (Number.isFinite(n)) t.rows.add(n);
  }
  return t;
}

function buildColValPairTVP(pairs = []) {
  // SQL type: dbgraph.ColValPair (col SYSNAME, val NVARCHAR(4000))
  const t = new sql.Table('dbgraph.ColValPair');
  t.create = false;
  t.columns.add('col', sql.NVarChar(128),  { nullable: false });   // SYSNAME ~ NVARCHAR(128)
  t.columns.add('val', sql.NVarChar(4000), { nullable: false });
  for (const p of pairs) {
    if (!p || typeof p !== 'object') continue;
    const col = String(p.col ?? '').trim();
    const val = String(p.val ?? '').trim();
    if (!col) continue;
    t.rows.add(col, val);
  }
  return t;
}

function buildViewColValPairTVP(rows = []) {
  // SQL type: dbgraph.ViewColValPair (ViewID INT, col SYSNAME, val NVARCHAR(4000))
  const t = new sql.Table('dbgraph.ViewColValPair');
  t.create = false;
  t.columns.add('ViewID', sql.Int,          { nullable: false });
  t.columns.add('col',    sql.NVarChar(128),  { nullable: false });
  t.columns.add('val',    sql.NVarChar(4000), { nullable: false });
  for (const r of rows) {
    if (!r || typeof r !== 'object') continue;
    const viewId = Number(r.ViewID ?? r.viewId ?? r.viewID);
    const col    = String(r.col ?? '').trim();
    const val    = String(r.val ?? '').trim();
    if (!Number.isFinite(viewId) || !col) continue;
    t.rows.add(viewId, col, val);
  }
  return t;
}

// ---------- Single shared connection pool ----------
let poolPromise = null;
async function getPool() {
  if (!poolPromise) {
    poolPromise = sql.connect(sqlConfig).catch(err => {
      poolPromise = null; // allow retry on next request
      throw err;
    });
  }
  return poolPromise;
}

// ---------- Health ----------
app.get('/health', async (req, res) => {
  try {
    const pool = await getPool();
    await pool.request().query('SELECT 1 AS ok');
    res.json({ ok: true, db: SQL_DATABASE, server: SQL_SERVER });
  } catch (err) {
    res.status(500).json({ ok: false, error: err.message });
  }
});

// ---------- Traverse step ----------
app.post('/api/traverseStepMulti', async (req, res) => {
  const started = Date.now();
  try {
    const {
      viewIds = [],                 // [int]
      frontier = [],                // [{col, val}]
      perViewExclude = [],          // [{ViewID, col, val}]
      depth = 1,
      lang = 'en',                  // 'en' | 'ar'
      maxFanout = null,             // int | null
    } = req.body || {};

    if (!Array.isArray(viewIds))        return res.status(400).json({ error: '`viewIds` must be an array of integers.' });
    if (!Array.isArray(frontier))       return res.status(400).json({ error: '`frontier` must be an array of {col,val}.' });
    if (!Array.isArray(perViewExclude)) return res.status(400).json({ error: '`perViewExclude` must be an array of {ViewID,col,val}.' });

    const depthInt = Number(depth);
    if (!Number.isFinite(depthInt) || depthInt < 1) return res.status(400).json({ error: '`depth` must be a positive integer.' });

    const maxFanInt = (maxFanout == null) ? null : Number(maxFanout);
    if (maxFanInt != null && (!Number.isFinite(maxFanInt) || maxFanInt <= 0)) {
      return res.status(400).json({ error: '`maxFanout` must be a positive integer if provided.' });
    }

    // Build TVPs
    const tvpViews    = buildIntListTVP(viewIds);
    const tvpFrontier = buildColValPairTVP(frontier);
    const tvpExclude  = buildViewColValPairTVP(perViewExclude);

    const pool = await getPool();
    const request = pool.request();
    request.multiple = true; // expect 2 result sets

    // IMPORTANT: parameter names MUST match your stored procedure signature
    request.input('ViewIDs',        tvpViews);
    request.input('Frontier',       tvpFrontier);
    // Matches proc signature: @PerViewExclude dbgraph.ViewColValPair READONLY
    request.input('PerViewExclude', tvpExclude);
    request.input('Depth',          sql.Int, depthInt);
    request.input('Lang',           sql.NVarChar(2), String(lang || 'en').substring(0, 2));
    request.input('MaxFanout',      sql.Int, maxFanInt); // can be null

    const procName = 'dbgraph.TraverseStep_MultiViews_PerViewExclude_Lang';
    const result = await request.execute(procName);

    const edges       = Array.isArray(result.recordsets?.[0]) ? result.recordsets[0] : [];
    const nextFrontier= Array.isArray(result.recordsets?.[1]) ? result.recordsets[1] : [];

    res.json({
      edges,
      nextFrontier,
      meta: {
        elapsedMs: Date.now() - started,
        edgeCount: edges.length,
        frontierCount: nextFrontier.length,
      },
    });
  } catch (err) {
    console.error('API error:', err);
    res.status(500).json({ error: err.message });
  }
});

// ---------- Start ----------
app.listen(Number(PORT), () => {
  console.log(`[db-data-explorer] API listening on http://localhost:${PORT}`);
  const usingConnStr = chosenDriver === 'msnodesqlv8' ? 'yes' : 'no';
  const odbcInfo = chosenDriver === 'msnodesqlv8' ? ` odbc='${chosenOdbcDriver}'` : '';
  console.log(`DB: ${SQL_SERVER} / ${SQL_DATABASE} (trusted=${useTrusted}) driver=${chosenDriver} connStr=${usingConnStr}${odbcInfo}`);
});

// Graceful shutdown (optional)
process.on('SIGINT', async () => {
  try { await sql.close(); } catch {}
  process.exit(0);
});
